library ieee;
use ieee.std_logic_1164.all;
use work.SAD_lib.all;


entity SAD is 
	generic (data_width: Integer := 8;
		Mat_size: integer := 16; -- Do rong bit cua ma tran dau vao
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
	

	
        data_out : out std_logic_vector(15 downto 0)           
    );
end SAD;

architecture rtl of SAD is 
signal subzero: std_logic;
signal ld_i: std_logic;
signal En_enable: std_logic; 
signal i_enable: std_logic;
signal z_sel: std_logic;
signal Z_i: std_logic;


begin
ctrl_unit: FSM_Controller
    Port Map(
        clk ,     
        rst   ,     
        start   ,   
        subzero 	,
        done   ,
        R_e    ,
        ld_i       ,
        En_enable ,
	i_enable  ,
        z_sel 
    );


datapath_unit: SAD_Calc 
generic map(
		Mat_size, -- Kich thuoc ma tran MxN
		data_width,  -- Do rong bit cua ma tran dau vao
		SAD_dw -- Do rong bit loi ra
   )
  

    port map(
	-- bo dem i
        clk ,
        rst ,
	start,
	done,
	
	-- Khoi ma tran dau vao
	data_A_in,
	data_B_in, 


	W_e ,
	R_e ,
	
	Z_i,
        ld_i,
	subzero,
        i_enable,

	
        data_out      
    );

end rtl;

