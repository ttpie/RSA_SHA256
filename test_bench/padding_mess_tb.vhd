library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_padding_mess is
end entity;

architecture Behavioral of tb_padding_mess is
 
    component padding_mess is
        generic (
            INPUT_LENGTH : integer := 64
        );
        port (
            clk: std_logic;
            reset: std_logic;
            input_data : in std_logic_vector(INPUT_LENGTH-1 downto 0);
            padded_data : out std_logic_vector(511 downto 0)
        );
    end component;
 --------------------------------------------------------------------------------------------   
    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    constant INPUT_LENGTH : integer := 64; -- do dai chuoi data vào (bit)
    CONSTANT clock_period : TIME := 10 ns; -- chu ky clock
    signal input_data : std_logic_vector(INPUT_LENGTH-1 downto 0) := (others => '0');
    signal padded_data : std_logic_vector(511 downto 0) := (others => '0');
  
---------------------------------------------------------------------------------------------    
begin
    uut: padding_mess
        generic map (
            INPUT_LENGTH => INPUT_LENGTH
        )
        port map (
            clk => clk,
            reset => reset,
            input_data => input_data,
            padded_data => padded_data
        );
---------------------------------------------------------------------------------------------

    clock_gen: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clock_period / 2;
        clk <= '1';
        WAIT FOR clock_period / 2;
    END PROCESS;
---------------------------------------------------------------------------------------------    
  
    process
    begin
        reset <= '0';
        wait for 4 * clock_period;
        reset <= '1';
        
        input_data <= x"3131313161626364"; -- "1111abcd"
        wait for 20 ns;

        input_data <= x"3132333435363738"; -- "12345678" 
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
