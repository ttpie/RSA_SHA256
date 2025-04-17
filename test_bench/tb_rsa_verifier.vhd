library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_rsa_verifier is
end tb_rsa_verifier;

architecture Behavioral of tb_rsa_verifier is

   
    component RSA_Verifier
        generic (
        N_BITS : integer := 512  
    );
    Port (
        clk       : in std_logic;                  
        reset     : in std_logic;                   
        start     : in std_logic;                   
        S         : in unsigned(N_BITS-1 downto 0);     
        e         : in unsigned(N_BITS-1 downto 0);        
        n         : in unsigned(N_BITS-1 downto 0);        
        D_2       : out unsigned(N_BITS-1 downto 0);     
        done_v    : out std_logic                 
    );
    end component;
    

 -------------------------------------------------------------------------------------------
    
    constant N_BITS : INTEGER := 512;
  
    signal clk       : std_logic := '0';             
    signal reset     : std_logic := '0';              
    signal start     : std_logic := '0';              
    signal S         : unsigned(N_BITS-1 downto 0) := (others => '0');      
    signal e         : unsigned(N_BITS-1 downto 0) := (others => '0');         
    signal n         : unsigned(N_BITS-1 downto 0) := (others => '0');         
    signal D_2       : unsigned(N_BITS-1 downto 0) := (others => '0');         
    signal done_v    : std_logic;                     

    constant clk_period : time := 10 ns;

begin

    uut1: RSA_Verifier
        Port map (
            clk    => clk,
            reset  => reset,
            start  => start,
            S      => S,
            e      => e,
            n      => n,
            D_2    => D_2,
            done_v => done_v
        );
    
  ----------------------------------------------------------------------------------
  
    clk_process: process
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
        wait for clk_period;
        reset <= '1';

        -- Test case 1
        start <= '1';

--        S <= to_unsigned(3, N_BITS);          -- Base = 7
--        e <= to_unsigned(14, N_BITS);          -- Exponent = 3
--        n <= to_unsigned(25, N_BITS);         -- Modulus = 33
      
--           -- Ki?m tra k?t qu?
--        assert result = to_unsigned(19, N_BITS)
--        report "Test Case 1 Failed"
--        severity error;
--        report "Test Case 1 Passed!" severity note;

--        wait for 40 ns;
--        start <= '0';
   --     wait for 2585 ns;
        
----        start <= '1';
        S <= x"00000000000000000000000000000000000000000000000000000000000000005994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5";
        e <= x"755ba91c679fa5a759cecb798f9816bc17098f2b6167490a09cb44930f02d4fe759d7eb0e4208092ee3f096983b961c69e07f7fce30be0d9ddfe7755799edc01";
        n <= x"997b6a37aaa580da65f513017231e45002514737d448cc98207a065def1c4d2c1b2a592bd24bb0c70d85fd4c9661027628ecff6a241d5174521539349a534047";
        
--        wait for 60 ns;
--        start <= '0';
--        wait for 60 ns;
        
--        start <= '1';
--        a <= x"1994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5";
--        k <= x"4a98a48c2759c3e83649fedef82e208272005ed1ea4f547b60f50cd0c9354389";
--        n <= x"45948030b3cb84dc9935d5fd912cdf6eb8695eaea19cdf2b7edebc84908b1a95";
--        wait for 60 ns;
--        a <= to_unsigned(25, N_BITS);          -- Base = 7
--        k <= to_unsigned(705, N_BITS);          -- Exponent = 3
--        n <= to_unsigned(3542, N_BITS);

--        -- Test case 2
--        wait for clk_period;
--        a <= to_unsigned(2, 32);          -- Base = 2
--        k <= to_unsigned(10, 32);         -- Exponent = 10
--        n <= to_unsigned(17, 64);         -- Modulus = 17
--        start <= '1';
--        wait for clk_period;
--        start <= '0';

--        -- Wait for done signal
--        wait until done = '1';
--        assert result = to_unsigned(15, 64)
--            report "Test case 2 failed: Expected 15" severity error;

--        -- Test case 3
--        wait for clk_period;
--        a <= to_unsigned(5, 32);          -- Base = 5
--        k <= to_unsigned(20, 32);         -- Exponent = 20
--        n <= to_unsigned(101, 64);        -- Modulus = 101
--        start <= '1';
--        wait for clk_period;
--        start <= '0';

--        -- Wait for done signal
--        wait until done = '1';
--        assert result = to_unsigned(76, 64)
--            report "Test case 3 failed: Expected 76" severity error;

        -- Stop simulation
        wait;
    end process;

end Behavioral;
