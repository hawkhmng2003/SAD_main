library ieee;
use ieee.std_logic_1164.all;
use work.SAD_lib.all;
use ieee.numeric_std.all;

entity SAD_tb is
end SAD_tb;

architecture behavior of SAD_tb is
    constant data_width: Integer := 8;
    constant Mat_size: Integer := 4; -- Adjusted for example as 4x4 matrix
    constant SAD_dw: Integer := 16;
    
    signal rst, clk, done, start: std_logic;
    signal data_A_in: std_logic_vector(data_width - 1 downto 0);
    signal data_B_in: std_logic_vector(data_width - 1 downto 0);
    signal data_out: std_logic_vector(SAD_dw - 1 downto 0);
    signal W_e, R_e: std_logic;
    signal ld_i: std_logic;
    signal i_enable: std_logic;

    -- Example matrices represented as 1D arrays
    type matrix_array is array (0 to Mat_size*Mat_size - 1) of std_logic_vector(data_width - 1 downto 0);
    signal matrix_A: matrix_array := (
        "00000001", "00000010", "00000011", "00000100",
        "00000101", "00000110", "00000111", "00001000",
        "00001001", "00001010", "00001011", "00001100",
        "00001101", "00001110", "00001111", "00010000"
    );
    signal matrix_B: matrix_array := (
        "00010000", "00001111", "00001110", "00001101",
        "00001100", "00001011", "00001010", "00001001",
        "00001000", "00000111", "00000110", "00000101",
        "00000100", "00000011", "00000010", "00000001"
    );

begin
    UUT: entity work.SAD_Calc
        generic map (
            data_width => data_width,
            Mat_size => Mat_size,
            SAD_dw => SAD_dw
        )
        port map (
            clk => clk,
            rst => rst,
            start => start,
            done => done,
            data_A_in => data_A_in,
            data_B_in => data_B_in,
            W_e => W_e,
            R_e => R_e,
            data_out => data_out,
            ld_i => ld_i,
            i_enable => i_enable
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus_process: process
        variable i, row, col: integer := 0; -- Added row, col for indexing
  begin
        -- Initialize signals
        rst <= '1';
        start <= '0';
        data_A_in <= (others => '0');
        data_B_in <= (others => '0');
        W_e <= '0';
        R_e <= '0';
        ld_i <= '0';
        i_enable <= '0';
        
        wait for 20 ns;
        
        -- Reset deassertion
        rst <= '0';
        wait for 20 ns;

        -- Apply input stimuli for matrix A and B row by row
        for row in 0 to Mat_size - 1 loop
      		for col in 0 to Mat_size - 1 loop
        		i := row * Mat_size + col;
            		data_A_in <= matrix_A(i);
        		W_e <= '1';
        		ld_i <= '1';
        		i_enable <= '1'; -- Enable for all rows
        		wait for 20 ns;

            		-- Input loading for Matrix B
        		data_B_in <= matrix_B(i);
        		W_e <= '1';
        		wait for 20 ns;
        
        				-- Disable signals
      			W_e <= '0';
        		ld_i <= '0';
        	wait for 20 ns;
      		end loop;
   	 end loop;

        -- Signal completion
    i_enable <= '0';
    start <= '1';
    wait for 20 ns;
    start <= '0';

    -- Output reading
    R_e <= '1';
for i in 0 to Mat_size - 1 loop
  wait for 20 ns;
  report "SAD value at " & integer'image(i) & ": " & integer'image(to_integer(unsigned(data_out))); -- Conversion
end loop;
R_e <= '0';

    wait; -- Stop the simulation
  end process;

end behavior;
