library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rsa_sign is
    generic (
        N_BITS : integer := 512  -- S? bit c?a modulus v� c�c s? kh�c
    );
    port (
        clk        : in  std_logic;              -- Xung clock
        reset      : in  std_logic;              -- T�n hi?u reset
        start      : in  std_logic;              -- B?t ??u qu� tr�nh k�
        M          : in  unsigned(N_BITS-1 downto 0); -- Th�ng ?i?p c?n k�
        d          : in  unsigned(N_BITS-1 downto 0); -- Private exponent
        n          : in  unsigned(N_BITS-1 downto 0); -- Modulus
        done       : out std_logic;             -- Ho�n th�nh k�
        signature  : out unsigned(N_BITS-1 downto 0)  -- Ch? k� k?t qu?
    );
end rsa_sign;

architecture Behavioral of rsa_sign is
    signal S       : unsigned(N_BITS-1 downto 0) := (others => '0'); -- Ch? k� (k?t qu? trung gian)
    signal base    : unsigned(N_BITS-1 downto 0);                   -- C? s? (base)
    signal exp     : unsigned(N_BITS-1 downto 0);                   -- S? m? (exponent)
    signal mod_n   : unsigned(N_BITS-1 downto 0);                   -- Modulus
    signal temp    : unsigned(N_BITS-1 downto 0);                   -- Bi?n trung gian
    signal running : std_logic := '0';                              -- ?ang ch?y
begin
    process (clk, reset)
    begin
        if reset = '1' then
            S       <= (others => '0');
            base    <= (others => '0');
            exp     <= (others => '0');
            mod_n   <= (others => '0');
            temp    <= (others => '0');
            running <= '0';
            done    <= '0';
        elsif rising_edge(clk) then
            if start = '1' and running = '0' then
                -- Kh?i t?o gi� tr?
                base    <= M;
                exp     <= d;
                mod_n   <= n;
                S       <= "1";  -- B?t ??u v?i gi� tr? 1
                running <= '1';
                done    <= '0';
            elsif running = '1' then
                if exp = 0 then
                    -- K?t th�c thu?t to�n
                    running <= '0';
                    done    <= '1';
                else
                    -- Modular exponentiation
                    if exp(0) = '1' then
                        S <= mod((S * base), mod_n);
                    end if;
                    base <= mod((base * base), mod_n);
                    exp  <= exp(N_BITS-2 downto 0) & '0';
                end if;
            end if;
        end if;
    end process;

    -- Xu?t ch? k�
    signature <= S;
end Behavioral;
