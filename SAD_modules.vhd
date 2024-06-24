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
	signal SAD: std_logic_vector((SAD_dw - 1) downto 0) := (others => '0'); -- Initialize SAD to 0
	constant zeros : std_logic_vector((SAD_dw - data_width - 1) downto 0) := (others => '0');
	signal i : integer; 


	begin
  sad_calc: process(clk, rst)
    variable sub, A_i, B_i: std_logic_vector((SAD_dw - 1) downto 0);
  begin
    if rst = '1' then
      i <= 0;
      SAD <= (others => '0');        -- Reset SAD inside the process
      done <= '0';
      W_e <= '0';
      R_e <= '0';
      Z_i <= '0';
    elsif clk = '1' and clk'event then
      Z_i <= '0';  -- Clear Z_i unless the condition is met

      if start = '1' then
        W_e <= '0';
        R_e <= '1';

        -- Check the condition here to avoid the latching issue
        if i + 1 = Mat_size then
          Z_i <= '1';
          done <= '1';
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
      end if;  -- End of start = '1'

    end if;  -- End of clk'event
  end process;

  data_out <= SAD; -- Assign data_out outside the process

end RTL;

				
			
	
		
	
	
	







