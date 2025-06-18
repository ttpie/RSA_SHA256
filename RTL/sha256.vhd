LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY sha256 is
    generic (
            INPUT_LENGTH : integer := 64
        );
    Port ( reset 	: in  STD_LOGIC;
           clock 	: in  STD_LOGIC;
           data 	: in  STD_LOGIC_VECTOR (INPUT_LENGTH-1 downto 0);
           digest	: out STD_LOGIC_VECTOR (255 downto 0);
           done_hash: out std_logic
    );  
end sha256;

ARCHITECTURE Behavioral of sha256 is
-----------------------------------------------------------------------------------------------------------------    
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
-----------------------------------------------------------------------------------------------------------------    
   ---- khai bao hang so 
   type hT is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
   constant hInit : hT :=
     (x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19");
     
   type kT is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);  
   constant k : kT :=
     (x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
      x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
      x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
      x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
      x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
      x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
      x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
      x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2");
      
----------------------------------------------------------------------------------------------------------------------   
   -- signal dung trong function
   signal a,b,c,d,e,f,g,h,h0,h1,h2,h3,h4,h5,h6,h7 : STD_LOGIC_VECTOR(31 downto 0);
  -- signal clk, reset_t : std_logic;
 --  signal input_data: std_logic_vector(INPUT_LENGTH-1 downto 0);
   signal padded_data: std_logic_vector(511 downto 0);
   
   type W_array is array (0 to 63) of std_logic_vector(31 downto 0);
        signal W : W_array := (others => (others => '0'));
 
----------------------------------------------------------------------------------------------------------------------
    
   -- Hàm tính toán sigma_0
 function sigma_0(x : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(31 downto 0);                  
    begin
    result := std_logic_vector(shift_right(unsigned(x), 7) or shift_left(unsigned(x), 25))  xor  --ROTR 7 = ( X >> 7) OR (X << (32 - 7))
              std_logic_vector(shift_right(unsigned(x), 18) or shift_left(unsigned(x), 14)) xor -- ROTR 18
              std_logic_vector(shift_right(unsigned(x),3));                                     -- SHR 3
    return result;
  end function;
  
-------------------------------------------------------------------------------------------------------
  
    -- Hàm tính toán sigma_1
 function sigma_1(x : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(31 downto 0);
    begin
    result := std_logic_vector(shift_right(unsigned(x), 17) or shift_left(unsigned(x), 15)) xor    -- ROTR 17
              std_logic_vector(shift_right(unsigned(x), 19) or shift_left(unsigned(x), 13)) xor  -- ROTR 19
              std_logic_vector(shift_right(unsigned(x),10));                                      -- SHR 10
    return result;
  end function;
  
 --------------------------------------------------------------------------------------------------------  
  
  -- Hàm tính toán sum_0
function sum0(x : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(31 downto 0);
    begin
    result := std_logic_vector(shift_right(unsigned(x), 2) or shift_left(unsigned(x), 30))  xor  -- ROTR 2
              std_logic_vector(shift_right(unsigned(x), 13) or shift_left(unsigned(x), 19)) xor -- ROTR 13
              std_logic_vector(shift_right(unsigned(x), 22) or shift_left(unsigned(x), 10));     -- ROTR 22  
    return result;
  end function;
  
--------------------------------------------------------------------------------------------------------
  
    -- Hàm tính toán sum_1
 function sum1(x : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(31 downto 0);
    begin
    result := std_logic_vector(shift_right(unsigned(x), 6) or shift_left(unsigned(x), 26))  xor   -- ROTR 6
              std_logic_vector(shift_right(unsigned(x), 11) or shift_left(unsigned(x), 21)) xor -- ROTR 11
              std_logic_vector(shift_right(unsigned(x),25) or shift_left(unsigned(x), 7));      -- ROTR 25
    return result;
 end function;
  
--------------------------------------------------------------------------------------------------------
  -- Hàm Ch(e, f, g) và Maj(a, b, c)
    function Choose(e, f, g : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return (e and f) xor (not e and g);
    end function;
--------------------------------------------------------------------------------------------------------
    function Majority(a, b, c : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return (a and b) xor (a and c) xor (b and c);
    end function;
------------------------------------------------------------------------------------------------------- 

BEGIN
   
    uut: padding_mess
        generic map (
            INPUT_LENGTH => INPUT_LENGTH
        )
        port map (
            clk => clock,
            reset => reset,
            input_data => data,
            padded_data => padded_data
        );
        
   main_loop_pipe: process(clock)
   variable a_temp, b_temp, c_temp, d_temp, e_temp, f_temp, g_temp, h_temp, temp1, temp2 : std_logic_vector( 31 downto 0);
   type W_array is array (0 to 63) of std_logic_vector(31 downto 0);
   variable W_temp : W_array := (others => (others => '0'));
   
   begin
      if rising_edge(clock) then
         if reset = '0' then
            a_temp := (others => '0');
            b_temp := (others => '0');
            c_temp := (others => '0');
            d_temp := (others => '0');
            e_temp := (others => '0');
            f_temp := (others => '0');
            g_temp := (others => '0');
            h_temp := (others => '0');
            
            done_hash <= '0';
      else     
        -- Tinh gia tri mang W_t
      for t in 0 to 63 loop
        -- 1.
          if t >= 0 and t <= 15 then
               W_temp(t) := std_logic_vector(padded_data(511 - t*32 downto 480 - t*32));
          else
               W_temp(t) := std_logic_vector(unsigned(sigma_1(W_temp(t-2))) + unsigned(W_temp(t-7)) +  unsigned(sigma_0(W_temp(t-15))) + unsigned(W_temp(t-16)));
         end if;
      end loop; 
   ---------------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 2.
       a_temp := hInit(0);
       b_temp := hInit(1);
       c_temp := hInit(2);
       d_temp := hInit(3);
       e_temp := hInit(4);
       f_temp := hInit(5);
       g_temp := hInit(6);
       h_temp := hInit(7);
     --3.
    for t in 0 to 63 loop  
                temp1 := std_logic_vector(unsigned(h_temp) + 
                         unsigned(Sum1(e_temp)) + 
                         unsigned(Choose(e_temp,f_temp,g_temp)) + 
                         unsigned(k(t)) + unsigned(W_temp(t)));
                temp2 := std_logic_vector(unsigned(Sum0(a_temp)) + unsigned(Majority(a_temp,b_temp,c_temp)));
                h_temp := g_temp;
                g_temp := f_temp;
                f_temp := e_temp;
                e_temp := std_logic_vector(unsigned(d_temp) + unsigned(temp1));
                d_temp := c_temp;
                c_temp := b_temp;
                b_temp := a_temp;
                a_temp := std_logic_vector(unsigned(temp2) + unsigned(temp1)); -- a = T1 + T2
    end loop;

        ------ 4.
        h0 <= std_logic_vector(unsigned(a_temp) + unsigned(hInit(0)));  -- a+ hInit(0);
        h1 <= std_logic_vector(unsigned(b_temp) + unsigned(hInit(1)));  --b + hInit(1);
        h2 <= std_logic_vector(unsigned(c_temp) + unsigned(hInit(2)));  --c + hInit(2);
        h3 <= std_logic_vector(unsigned(d_temp) + unsigned(hInit(3)));  --d + hInit(3);
        h4 <= std_logic_vector(unsigned(e_temp) + unsigned(hInit(4)));  --e + hInit(4);
        h5 <= std_logic_vector(unsigned(f_temp) + unsigned(hInit(5)));  --f + hInit(5);
        h6 <= std_logic_vector(unsigned(g_temp) + unsigned(hInit(6)));  --g + hInit(6);
        h7 <= std_logic_vector(unsigned(h_temp) + unsigned(hInit(7)));  ---h + hInit(7);
        
        end if; 
      end if;
      --done_hash <= '1';
   end process;
   done_hash <= '1';
   digest <= h0 & h1 & h2 & h3 & h4 & h5 & h6 & h7;
  -- done_hash <= '1';
end Behavioral;