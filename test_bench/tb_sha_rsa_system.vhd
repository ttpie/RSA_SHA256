library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_sha_rsa_system is
end tb_sha_rsa_system;

architecture Behavioral of tb_sha_rsa_system is

    component SHA_RSA_System
     generic (
          N_BITS : integer := 512; 
          INPUT_LENGTH : integer := 64 );
     Port (
        clk       : in std_logic;                  
        reset     : in std_logic; 
        start     : in std_logic;                              
        message   : in std_logic_vector(INPUT_LENGTH-1 downto 0);     
        d         : in unsigned(N_BITS-1 downto 0);        
        e         : in unsigned(N_BITS-1 downto 0);        
        N         : in unsigned(N_BITS-1 downto 0);     
        Verify    : out std_logic                 
      );
    end component;

----------------------------------------------------------------------------
    constant N_BITS       : integer := 512;
    constant INPUT_LENGTH : integer := 64;
    signal clk            : std_logic := '0';
    signal reset          : std_logic := '0';
    signal start          : std_logic := '0';
    signal message        :std_logic_vector(INPUT_LENGTH-1 downto 0) := (others => '0');
    signal d              : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal n              : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal e              : unsigned(N_BITS-1 downto 0) := (others => '0');
    signal Verify         : std_logic := '0';

    constant CLK_PERIOD : time := 10 ns;
-------------------------------------------------------------------------------
begin

  uut: SHA_RSA_System
        generic map (
            N_BITS => N_BITS,
            INPUT_LENGTH => INPUT_LENGTH )
        port map (
            clk      => clk,
            reset    => reset,
            start    => start,
            message  => message,
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
        
--         -- testcase 1
      
--        message <= x"1132333435363730";
--        d <= to_unsigned(7, N_BITS);
--        e <= to_unsigned(15, N_BITS);
--        n <= to_unsigned(26, N_BITS);
--        wait for 92974 ns;
        
--        -- testcase 2
--        reset <= '0';
--        wait for CLK_PERIOD * 2;
--        reset <= '1';
      
--        message <= x"2232373435363748";
--        d <= to_unsigned(4, N_BITS);
--        e <= to_unsigned(10, N_BITS);
--        n <= to_unsigned(13, N_BITS);
--        wait for 92974 ns;
        
--        -- testcase 3
--        message <= x"3621313165626894";
--        d <= to_unsigned(223, N_BITS);
--        e <= to_unsigned(367, N_BITS);
--        n <= to_unsigned(713, N_BITS);
--        wait for 92974 ns;
        
--        -- testcase 4
--        reset <= '0';
--        wait for CLK_PERIOD * 2;
--        reset <= '1';
      
        message <= x"7131353161626384";
        d <= x"755ba91c679fa5a759cecb798f9816bc17098f2b6167490a09cb44930f02d4fe759d7eb0e4208092ee3f096983b961c69e07f7fce30be0d9ddfe7755799edc01";
        e <= to_unsigned(65537, N_BITS);
        n <= x"997b6a37aaa580da65f513017231e45002514737d448cc98207a065def1c4d2c1b2a592bd24bb0c70d85fd4c9661027628ecff6a241d5174521539349a534047";
        wait for 92974 ns;
        
        -- testcase 5
--        reset <= '0';
--        wait for CLK_PERIOD * 2;
--        reset <= '1';
      
--        message <= x"3582333005383738";
--        d <= x"7b1228a26fc383055675cb5befcabb179746a9e09911ae79d8d8619b148e3f77b9c7223dc51de0bd2569337847ddaef198652947917e367a74ddc0fb57cd0679";
--        e <= to_unsigned(65537, N_BITS);
--        n <= x"95652e8fc7a8a6e97f862a6d71ad14cb3da37ea965afedec210824c62cf797d49eccb2bf427b49401dd346678d9f7304c1fc5b2c6bbc745fc0070071ff3606b7";
--        wait for 92974 ns;
        
        
        wait;
    end process;

end Behavioral;
