LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY tb_sha256 IS
END tb_sha256;

ARCHITECTURE Behavioral OF tb_sha256 IS
----------------------------------------------------------------------------------------
    COMPONENT sha256
      generic (
            INPUT_LENGTH : integer := 64);
       Port ( 
           reset 	: in  STD_LOGIC;
           clock 	: in  STD_LOGIC;
           data 	: in  STD_LOGIC_VECTOR (INPUT_LENGTH-1 downto 0);
           digest	: out STD_LOGIC_VECTOR (255 downto 0)
         --  done_hash: out std_logic
           );
    END COMPONENT;

----------------------------------------------------------------------------------------    
    constant INPUT_LENGTH : integer := 64;
    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL tb_reset   : STD_LOGIC := '0';
    SIGNAL tb_clock   : STD_LOGIC := '0';
    SIGNAL tb_data    : std_logic_vector(INPUT_LENGTH-1 downto 0):= (OTHERS => '0');
    SIGNAL tb_digest  : STD_LOGIC_VECTOR(255 DOWNTO 0) := (others => '0');
  --  SIGNAL done_hash   : STD_LOGIC := '0';
  
------------------------------------------------------------------------------------------  
BEGIN
    DUT: sha256
        PORT MAP (
            reset   => tb_reset,
            clock   => tb_clock,
            data    => tb_data,
            digest  => tb_digest
          --  done_hash => done_hash
        );
------------------------------------------------------------------------------------------         
    clock_gen: PROCESS
    BEGIN
        tb_clock <= '0';
        WAIT FOR clock_period / 2;
        tb_clock <= '1';
        WAIT FOR clock_period / 2;
    END PROCESS;
------------------------------------------------------------------------------------------
    stimulus: PROCESS
    BEGIN
        tb_reset <= '0';
        wait for 2 * clock_period;
        tb_reset <= '1';
        
       --testcase 1
        tb_data <= x"0000000161626364";
          WAIT for 65ns;
          ASSERT (tb_digest = x"ce534547c5a37bd9117aec1ce0e5c512a2b8169042ff3bbfeda10a9715087216") 
            REPORT "Test case 1 failed: Expected digest" SEVERITY ERROR;
          REPORT "Test case 1 passed: tb_digest = ce534547c5a37bd9117aec1ce0e5c512a2b8169042ff3bbfeda10a9715087216 "  SEVERITY NOTE;

        -- testcase 2
        tb_data <= x"0000333435363738";
        wait for 65ns;
        ASSERT (tb_digest = x"b17f263dda8a8eaa2bce01d7f8bb4d31b82ea27a6a6c50dd39a14ff5f237d058") 
            REPORT "Test case 2 failed: Expected digest" SEVERITY ERROR;
        REPORT "Test case 2 passed: tb_digest = b17f263dda8a8eaa2bce01d7f8bb4d31b82ea27a6a6c50dd39a14ff5f237d058 "  SEVERITY NOTE;
        
        -- testcase 3
        tb_data <= x"1257333489360038";
        wait for 65ns;
        ASSERT (tb_digest = x"c568a9aefcc5826341486f9190132982c0fbf44409256fb7fcefda0c96e5b8f0") 
            REPORT "Test case 3 failed: Expected digest" SEVERITY ERROR;
        REPORT "Test case 3 passed: tb_digest = c568a9aefcc5826341486f9190132982c0fbf44409256fb7fcefda0c96e5b8f0 "  SEVERITY NOTE;
        
        --testcase 4
        tb_data <= x"1111333435363738";
        wait for 65ns;
        ASSERT (tb_digest = x"457bff4392d7890498aab081c0a1c5b5ab47a05a6609a65c85d0123cbfffebb2") 
            REPORT "Test case 4 failed: Expected digest" SEVERITY ERROR;
        REPORT "Test case 4 passed: tb_digest = 457bff4392d7890498aab081c0a1c5b5ab47a05a6609a65c85d0123cbfffebb2 "  SEVERITY NOTE;

        -- testcase 5
        tb_data <= x"3131313161626364";
        wait for 65ns;
        ASSERT (tb_digest = x"1dc934414c7b2806e73fc5b62bd79a03125470c002aab6ecee585a6dc861cd77") 
            REPORT "Test case 5 failed: Expected digest" SEVERITY ERROR;
        REPORT "Test case 5 passed: tb_digest = 1dc934414c7b2806e73fc5b62bd79a03125470c002aab6ecee585a6dc861cd77 "  SEVERITY NOTE;

       WAIT;   
    END PROCESS;

END Behavioral;
