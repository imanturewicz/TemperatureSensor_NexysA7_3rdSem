library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;

entity display is
    Port (
        CLK: in std_logic;
        RST: in std_logic;
        th: in integer range 0 to 10;
        rd: in integer range 0 to 9;
        nd: in integer range 0 to 9;
        st: in integer range 0 to 9;
        F: in std_logic;
        DIGITS: out std_logic_vector (7 downto 0) := "00000000";
        DP: out std_logic;
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic
    );
end display;

architecture display_arch of display is
begin
    Display: process(CLK, RST)
        variable temp: integer range 1 to 5 := 5;
    begin
        if RST = '1' then
            DIGITS <= "11111111";
        elsif rising_edge(CLK) then
            if temp = 5 then
                DIGITS <= "01111111";
                if F = '0' then CA <= '0'; CB <= '1'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
                else CA <= '0'; CB <= '1'; CC <= '1'; CD <= '1'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                end if;
            elsif temp = 4 then
                DIGITS <= "11110111";
                if th = 10 then
                    DIGITS <= "11111111";
                elsif th = 9 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif th = 8 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif th = 7 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                elsif th = 6 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif th = 5 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif th = 4 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif th = 3 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif th = 2 then CA <= '0'; CB <= '0'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif th = 1 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                else  CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
                end if;
            elsif temp = 3 then
                DIGITS <= "11111011";
                if rd = 9 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif rd = 8 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif rd = 7 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                elsif rd = 6 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif rd = 5 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif rd = 4 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif rd = 3 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif rd = 2 then CA <= '0'; CB <= '0'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif rd = 1 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                else  CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
                end if;
            elsif temp = 2 then
                DIGITS <= "11111101";
                if nd = 9 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '0';
                elsif nd = 8 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '0';
                elsif nd = 7 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '0';
                elsif nd = 6 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '0';
                elsif nd = 5 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '0';
                elsif nd = 4 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '0';
                elsif nd = 3 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '1'; CG <= '0'; DP <= '0';
                elsif nd = 2 then CA <= '0'; CB <= '0'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0'; DP <= '0';
                elsif nd = 1 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '0';
                else  CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
                end if;
            elsif temp = 1 then
                DIGITS <= "11111110";
                if st = 9 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif st = 8 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif st = 7 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                elsif st = 6 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif st = 5 then CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif st = 4 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
                elsif st = 3 then CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif st = 2 then CA <= '0'; CB <= '0'; CC <= '1'; CD <= '0'; CE <= '0'; CF <= '1'; CG <= '0'; DP <= '1';
                elsif st = 1 then CA <= '1'; CB <= '0'; CC <= '0'; CD <= '1'; CE <= '1'; CF <= '1'; CG <= '1'; DP <= '1';
                else  CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
                end if;
            end if;
            if temp = 1 then temp := 5;
            else temp := temp - 1;
            end if;
        end if;
    end process Display;
end display_arch;
