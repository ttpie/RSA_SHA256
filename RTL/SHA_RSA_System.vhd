library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SHA_RSA_System is
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
end SHA_RSA_System;

architecture Behavioral of SHA_RSA_System is

---------------------------------------------------------------------------------
component sha256
  generic (
            INPUT_LENGTH : integer := 64
        );
    Port ( reset 	: in  STD_LOGIC;
           clock 	: in  STD_LOGIC;
           data 	: in  STD_LOGIC_VECTOR (INPUT_LENGTH-1 downto 0);
           digest	: out STD_LOGIC_VECTOR (255 downto 0);
           done_hash: out std_logic
    ); 
end component;

 --------------------------------------------------------------------------------
component RSA_Signature 
  generic (
  N_BITS : integer := 512 
  );
   Port (
        clk       : in std_logic;                  
        reset     : in std_logic;                   
        start     : in std_logic;                   
        h         : in unsigned(N_BITS-1 downto 0);     
        d         : in unsigned(N_BITS-1 downto 0);        
        n         : in unsigned(N_BITS-1 downto 0);        
        S         : out unsigned(N_BITS-1 downto 0);     
        done_s    : out std_logic                 
    );
  end component;
------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------

   -- signal clock      : std_logic;
    signal done_hash        : std_logic;
    signal S_in       : unsigned(N_BITS-1 downto 0);
    signal done_s      : std_logic;
    signal D_2         : unsigned(N_BITS-1 downto 0);
    signal done_v      : std_logic;
    signal veri        : std_logic;
    signal digest      : unsigned(255 downto 0);
    signal h_padding       : unsigned(N_BITS-1 downto 0) := resize(digest, N_BITS);
    
begin
 
 --------------------------------------------------------------------------------------
 uut: sha256
 port map (
    reset => reset,
    clock => clk,
    data  => message,
    unsigned(digest) => digest,
    done_hash => done_hash
 );
 
 --------------------------------------------------------------------------------------
 uut1: RSA_Signature
        Port map (
            clk    => clk,
            reset  => reset,
            start  => done_hash,
            h      => h_padding,
            d      => d,
            n      => n,
            S      => S_in,
            done_s => done_s
        ); 
 --------------------------------------------------------------------------------------  
  uut2: RSA_Verifier
        Port map (
            clk    => clk,
            reset  => reset,
            start  => done_s,
            S      => S_in,
            e      => e,
            n      => n,
            D_2    => D_2,
            done_v => done_v
        );
 ---------------------------------------------------------------------------------------       
    process(clk, reset, D_2, start)
    begin
      if rising_edge(clk) then 
        if reset = '0' then
           veri <= '0';  
        else
               if D_2 = h_padding then
                  veri <= '1';
               else
                  veri <= '0';   
               end if;
               
          verify <= veri;
               
        end if;    
      end if;                       
 end process;    
              
end Behavioral;

