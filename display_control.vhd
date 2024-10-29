library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_control is
    Port (
        CLK: in std_logic;
        RST: in std_logic;
        F: in std_logic;
        temperatura: in integer range 0 to 120;
        th: out integer range 0 to 10;
        rd: out integer range 0 to 9;
        nd: out integer range 0 to 9;
        st: out integer range 0 to 9;
    );
end display_control;

architecture disp_cntrl_arch of display_control is
begin
    Control: process(CLK, RST)
        variable temp: integer;
    begin
        if RST = '1' then
            --Do we do anything???????????????????????????????????
        elsif rising_edge(CLK) then
            if F = '0' then
                th <= 10;
                rd <= temperatura / 100;
                temp := (temperatura - (100 * (temperatura/100)) );
                nd <= temp / 10;
                st <= (temp - (10 * (temp/10)) );
            end if;
        end if;
    end process Control;

    -- Boobs: process(CLK)
    --     variable temp: integer := 1;
    -- begin
    --     if rising_edge(CLK) then
    --         if temp = 1 then
    --             DIGITS <= "11011111"; 
    --             CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
    --         elsif temp = 2 then
    --             DIGITS <= "11101111";
    --             CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
    --         elsif temp = 3 then
    --             DIGITS <= "11110111";
    --             CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '1'; DP <= '1';
    --         elsif temp = 4 then
    --             DIGITS <= "11111011";
    --             CA <= '0'; CB <= '0'; CC <= '0'; CD <= '0'; CE <= '0'; CF <= '0'; CG <= '0'; DP <= '1';
    --         elsif temp = 5 then
    --             DIGITS <= "11111101";
    --             CA <= '0'; CB <= '1'; CC <= '0'; CD <= '0'; CE <= '1'; CF <= '0'; CG <= '0'; DP <= '1';
    --         end if;
    --         if temp = 5 then
    --             temp := 1;
    --         else
    --             temp := temp + 1;
    --         end if;
    --     end if;
    -- end process Boobs;
end disp_cntrl_arch;
