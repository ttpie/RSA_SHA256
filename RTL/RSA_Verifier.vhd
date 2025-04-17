LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity RSA_Verifier is
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
end RSA_Verifier;

architecture Behavioral of RSA_Verifier is

-------------------------------------------------------------------------------------

    signal base       : unsigned(N_BITS-1 downto 0); 
    signal exponent   : unsigned(N_BITS-1 downto 0); 
    signal modulus    : unsigned(N_BITS-1 downto 0); 
    signal result     : unsigned(N_BITS-1 downto 0);
    signal bit_index  : integer range 0 to N_BITS-1;  
   
begin
 --------------------------------------------------------------------------------------   
    process(clk, reset, exponent, start, bit_index)
      variable r: unsigned(N_BITS-1 downto 0);
      variable done_i : std_logic:= '0';

    begin
      if rising_edge(clk) then 
        if reset = '0' then
         --   D_2       <= (others => '0');  -- moi them
            base      <= (others => '0');
            exponent  <= (others => '0');
            modulus   <= (others => '0');
            result    <= (others => '0');
            bit_index <= 0;               
            done_i    := '0';
            r         := to_unsigned(1, N_BITS);
            
        else
            if start = '1' then
             
                base      <= S;   
                exponent  <= e;         
                modulus   <= n;           
       
                if exponent = 0 then
                    r := to_unsigned(1, N_BITS);
                else
                    if exponent(bit_index) = '1' then
                        r := (r * base) mod modulus; 
                    end if;
                    
                    base <= (base * base) mod modulus;  
                    bit_index <= bit_index + 1;
                    result <= r;
                    
                    if bit_index >= (N_BITS-1) then
                        done_i := '1';
                        bit_index <= 0;
                    else 
                       done_i := '0';
                    end if;  
                    
                end if;
            elsif start = '0' then
                done_i := '0';  
            end if; 
            
            done_v <= done_i;
        end if;
    end if;
 end process;
              ---out result
              D_2 <= result;
end Behavioral;
