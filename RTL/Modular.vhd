library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Modular is
   generic (
        N_BITS : integer := 512  
    );
    Port (
        clk       : in std_logic;                  
        reset     : in std_logic;                   
        start     : in std_logic;                   
        a         : in unsigned(N_BITS-1 downto 0);     
        k         : in unsigned(N_BITS-1 downto 0);        
        n         : in unsigned(N_BITS-1 downto 0);        
        result    : out unsigned(N_BITS-1 downto 0);     
        done      : out std_logic                 
    );
end Modular;

architecture Behavioral of Modular is

-------------------------------------------------------------------------------------

    signal base       : unsigned(N_BITS-1 downto 0); 
    signal exponent   : unsigned(N_BITS-1 downto 0); 
    signal modulus    : unsigned(N_BITS-1 downto 0); 
    signal res        : unsigned(N_BITS-1 downto 0);
    signal bit_index  : integer range 0 to N_BITS-1;
   
begin
 --------------------------------------------------------------------------------------   
    process(clk, reset, exponent, start, bit_index)
      variable r: unsigned(N_BITS-1 downto 0);
      variable done_i : std_logic:= '0';

    begin
      if rising_edge(clk) then 
        if reset = '0' then
        
            base      <= (others => '0');
            exponent  <= (others => '0');
            modulus   <= (others => '0');
            res       <= (others => '0');
            bit_index <= 0;               
            done_i    := '0';
            r         := to_unsigned(1, N_BITS);
            
        else
            if start = '1' then
             
                base      <= a;   
                exponent  <= k;         
                modulus   <= n;           
       
                 if exponent = 0 then
                    r := to_unsigned(1, N_BITS);
                else
                    if exponent(bit_index) = '1' then
                        r := (r * base) mod modulus; 
                    end if;
                    
                    base <= (base * base) mod modulus;  
                    bit_index <= bit_index + 1;
                    res <= r;
                    
                    if bit_index = (N_BITS-1) then
                        done_i := '1';
                        bit_index <= 0;
                    else 
                       done_i := '0';
                    end if;  
                    
                end if;
            elsif start = '0' then
                done_i := '0';  
            end if;
            
            done <= done_i;
        end if;
    end if;
 end process;
              
              ---out result
              result <= res;
end Behavioral;

