library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RSA_System is
end tb_RSA_System;

architecture Behavioral of tb_RSA_System is

    component RSA_System
        generic (
        N_BITS : integer := 512  
    );
    Port (
        clk       : in std_logic;                  
        reset     : in std_logic;  
        start     : in std_logic;                                   
        h         : in unsigned(N_BITS-1 downto 0);     
        d         : in unsigned(N_BITS-1 downto 0);        
        e         : in unsigned(N_BITS-1 downto 0);        
        N         : in unsigned(N_BITS-1 downto 0);     
        Verify    : out std_logic                 
    );
    end component;

----------------------------------------------------------------------------
    constant N_BITS : integer := 512;
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal start    : std_logic := '0';
    signal h        : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal d        : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal n        : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal e        : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal Verify   : std_logic := '0';
    constant CLK_PERIOD : time := 10 ns;
-------------------------------------------------------------------------------
begin
  uut: RSA_System
        generic map (
            N_BITS => N_BITS
        )
        port map (
            clk      => clk,
            reset    => reset,
            start    => start,
            h        => h,
            d        => d,
            e        => e,
            n        => n,
            Verify   => Verify
        );
        
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stimulus_process : process
    begin
        
        reset <= '0';
        wait for CLK_PERIOD * 2;
        reset <= '1';
        
        start <= '1';
        wait for CLK_PERIOD;
        h <= x"00000000000000000000000000000000000000000000000000000000000000005994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5";
        d <= x"755ba91c679fa5a759cecb798f9816bc17098f2b6167490a09cb44930f02d4fe759d7eb0e4208092ee3f096983b961c69e07f7fce30be0d9ddfe7755799edc01";
        e <= to_unsigned(65537, N_BITS);
        n <= x"997b6a37aaa580da65f513017231e45002514737d448cc98207a065def1c4d2c1b2a592bd24bb0c70d85fd4c9661027628ecff6a241d5174521539349a534047";
        wait for 92974 ns;
        
        reset <= '0';
        wait for CLK_PERIOD * 2;
        reset <= '1';
        
        h <= x"00000000000000000000000000000000000000000000000000000000000000001224471abb01112afcc18059f6cc74b4f511b09806da59b3caf5a9c173c4cfc5";
        d <= x"755ba91c679fa5a759cecb798f9816bc17098f2b6167490a09cb44930f02d4fe759d7eb0e4208092ee3f096983b961c69e07f7fce30be0d9ddfe7755799edc01";
        e <= to_unsigned(65537, N_BITS);
        n <= x"997b6a37aaa580da65f513017231e45002514737d448cc98207a065def1c4d2c1b2a592bd24bb0c70d85fd4c9661027628ecff6a241d5174521539349a534047";
        wait for 92974 ns;
        
        reset <= '0';
        wait for CLK_PERIOD * 2;
        reset <= '1';
        
        h <= x"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003582333005383738";
        d <= x"7b1228a26fc383055675cb5befcabb179746a9e09911ae79d8d8619b148e3f77b9c7223dc51de0bd2569337847ddaef198652947917e367a74ddc0fb57cd0679";
        e <= to_unsigned(65537, N_BITS);
        n <= x"95652e8fc7a8a6e97f862a6d71ad14cb3da37ea965afedec210824c62cf797d49eccb2bf427b49401dd346678d9f7304c1fc5b2c6bbc745fc0070071ff3606b7";
        wait for 92974 ns;
        wait;
    end process;

end Behavioral;
