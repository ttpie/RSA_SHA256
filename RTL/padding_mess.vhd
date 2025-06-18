library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------------------------------------------------------------------
entity padding_mess is
    generic (
        INPUT_LENGTH : integer := 64);  
    port (
        clk: std_logic;
        reset: std_logic;
        input_data : in std_logic_vector(INPUT_LENGTH-1 downto 0);
        padded_data : out std_logic_vector(511 downto 0)
    );
end entity;

architecture Behavioral of padding_mess is
   signal padding_message: std_logic_vector(511 downto 0);
-------------------------------------------------------------------------------------------------------------------   
begin
    process(input_data, clk, reset)
        variable k : integer;
        variable padded_message_temp : std_logic_vector(511 downto 0);   
    begin
      if rising_edge (clk) then
        if reset = '0' then
          padded_message_temp := (others => '0');
        
        else
      
        padded_message_temp := (others => '0');
        ---  input_data + '1' + k = 448 mod 512
        ---  k : number '0' bit
        padded_message_temp(511 downto (512-INPUT_LENGTH)) := input_data; 
        -- Thêm bit '1'
        padded_message_temp(512-INPUT_LENGTH-1) := '1';
        -- 64 bit cuoi ma hoa chieu dai chuoi input_data
        padded_message_temp(63 downto 0) := std_logic_vector(to_unsigned(INPUT_LENGTH, 64)); 
        padding_message <= padded_message_temp;
        
      end if;
    end if; 
  end process;
     -- out
     padded_data <= padding_message;
     
end Behavioral;
