library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_control is
    Port (
        CLK_in: in std_logic;
        RST_in: in std_logic;
        F_in: in std_logic;
        temperatura_in: in integer range 0 to 2000;
        th_out: out integer range 0 to 10;
        rd_out: out integer range 0 to 9;
        nd_out: out integer range 0 to 9;
        st_out: out integer range 0 to 9
    );
end display_control;

architecture disp_cntrl_arch of display_control is
begin
    Control: process(CLK_in, RST_in)
        variable temp: integer;
    begin
        if RST_in = '1' then
            --Do we do anything???????????????????????????????????
        elsif rising_edge(CLK_in) then
            if F_in = '0' then
                th_out <= 10;
                rd_out <= temperatura_in / 100;
                temp := (temperatura_in - (100 * (temperatura_in/100)) );
                nd_out <= temp / 10;
                st_out <= (temp - (10 * (temp/10)) );
            end if;
        end if;
    end process Control;

    -- Boobs: process(CLK_in)
    --     variable temp: integer := 1;
    -- begin
    --     if rising_edge(CLK_in) then
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
