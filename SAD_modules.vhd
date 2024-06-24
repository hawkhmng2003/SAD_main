library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity SAD_Calc is 
generic (
		Mat_size: integer := 4*4; -- Kich thuoc ma tran MxN
		data_width : integer := 8; -- Do rong bit cua ma tran dau vao
		SAD_dw: integer := 16 -- Do rong bit loi ra
   );
  

    Port (
	-- bo dem i
        clk : in  std_logic;
        rst : in  std_logic;
	start: in std_logic;
	done: out std_logic;
	
	-- Khoi ma tran dau vao
	data_A_in: in std_logic_vector(data_width -1 downto 0); 
	data_B_in: in std_logic_vector(data_width -1 downto 0); 


	W_e : out std_logic;
	R_e : out std_logic;
	
	Z_i: out std_logic;
        ld_i: in std_logic;
	subzero: out std_logic;
        i_enable: in std_logic; 

	
        data_out : out std_logic_vector(15 downto 0)           
    );
end SAD_Calc;
architecture RTL of SAD_Calc is
    signal SAD: std_logic_vector((SAD_dw - 1) downto 0) := (others => '0'); 
    constant zeros : std_logic_vector((SAD_dw - data_width - 1) downto 0) := (others => '0');
    signal i : integer := 0;        
    signal start_reg: std_logic := '0';  
    signal done_reg: std_logic := '0';     

    begin
    sad_calc: process(clk, rst)
    variable sub, A_i, B_i: std_logic_vector((SAD_dw - 1) downto 0);
    begin
        if rst = '1' then
            i <= 0;
            SAD <= (others => '0');   
            done_reg <= '0';
            W_e <= '0';
            R_e <= '0';
            Z_i <= '0';
            start_reg <= '0';
        elsif clk = '1' and clk'event then
            -- Cap nhat thanh ghi start
            start_reg <= start;

            if start_reg = '1' then 
                R_e <= '1';
                W_e <= '0';

                if i + 1 = Mat_size then
                    Z_i <= '1'; -- Gan Z_i trong chu ky tiep theo sau khi dieu kien duoc thoa man
                    done_reg <= '1';
                else
                    Z_i <= '0'; 
                end if;

                A_i := zeros & data_A_in;
                B_i := zeros & data_B_in;

                if ld_i = '1' then
                    sub := std_logic_vector(unsigned(A_i) - unsigned(B_i));
                    if sub(8) = '1' then
                        sub := std_logic_vector(-(signed(sub)));
                    end if;
                    SAD <= std_logic_vector(unsigned(SAD) + unsigned(sub));
                end if;

                if i_enable = '1' then
                    i <= i + 1;
                end if;
            else
                W_e <= '0';
                R_e <= '0';
            end if; 

        end if; 
    end process;

    data_out <= SAD; 
    done <= done_reg; -- Gan done tu thanh ghi 

end RTL;


