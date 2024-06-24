
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package SAD_lib is
--Controller 
component FSM_Controller is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        start      : in  STD_LOGIC;
        subzero 	: out STD_LOGIC;
        done       : out STD_LOGIC;
        R_e        : out STD_LOGIC;
        ld_i       : out STD_LOGIC;
        En_enable  : out STD_LOGIC;
	i_enable   : in STD_Logic;
        z_sel : in STD_LOGIC
    );
end component;

component SAD_Calc is 
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
end component;


end SAD_lib;