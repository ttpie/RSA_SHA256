library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_RSA_Signature is
end tb_RSA_Signature;

architecture behavior of tb_RSA_Signature is
-------------------------------------------------------------------------------------------------
    component RSA_Signature
      generic (
        N_BITS : integer := 512;
       INPUT_LENGTH : integer := 64);
    Port (
        clk       : in std_logic;                  
        reset     : in std_logic;                   
        start     : in std_logic;                   
        message   : in std_logic_vector(INPUT_LENGTH-1 downto 0);        
        d         : in unsigned(N_BITS-1 downto 0);        
        n         : in unsigned(N_BITS-1 downto 0);        
        S         : out unsigned(N_BITS-1 downto 0);     
        done_s     : out std_logic                 
    );
    end component;

  ------------------------------------------------------------------------------------------------  
    -- Signals to connect to UUT
    constant clk_period : time := 10 ns;
    constant INPUT_LENGTH : integer := 64; -- 8 ky tu
    constant N_BITS : integer := 512; -- 8 ky tu
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal start         : std_logic := '0';
    signal message       : std_logic_vector(INPUT_LENGTH-1 downto 0):= (OTHERS => '0');
    signal d             : unsigned(N_BITS-1 downto 0) := (others => '0'); 
    signal n             : unsigned(N_BITS-1 downto 0) := (others => '0'); 
    signal S             : unsigned(N_BITS-1 downto 0) := (others => '0'); 
    signal done_s        : std_logic;
    
begin

           uut: RSA_Signature
        port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            message   => message,
            d         => d,
            n         => n,
            s         => s,
            done_s    => done_s
        );
        
------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;


    stim_proc: process
    begin
        -- Reset the system
        reset <= '0';
        wait for 20 ns;
        reset <= '1';

        start <= '1';
        message <= x"7131353161626384";
        d <= x"755ba91c679fa5a759cecb798f9816bc17098f2b6167490a09cb44930f02d4fe759d7eb0e4208092ee3f096983b961c69e07f7fce30be0d9ddfe7755799edc01";
      --  e <= to_unsigned(65537, N_BITS);
        n <= x"997b6a37aaa580da65f513017231e45002514737d448cc98207a065def1c4d2c1b2a592bd24bb0c70d85fd4c9661027628ecff6a241d5174521539349a534047";
        wait for 92974 ns;
       
--        hash <= std_logic_vector(to_unsigned(5, 256));
--        d <= (to_unsigned(596, 256));
--        n <= (to_unsigned(1234, 256));
--        wait for 40 ns; -- Wait for computation


--        --- message = 12345678
--        input_data <= x"3132333435363738";
--        p <= std_logic_vector(to_unsigned(71, 512));
--        q <= std_logic_vector(to_unsigned(97, 512)); 
--        d <= to_unsigned(4321, 512);                

   
        wait for 40 ns;

        wait;
    end process;

end behavior;
