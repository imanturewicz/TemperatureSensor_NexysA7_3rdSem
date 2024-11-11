library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;

entity display is
    Port (
        CLK_in: in std_logic;
        Rst_in: in std_logic;
        th_in: in integer range 0 to 10;
        rd_in: in integer range 0 to 9;
        nd_in: in integer range 0 to 9;
        st_in: in integer range 0 to 9;
        F_in: in std_logic;
        DIGITS_out: out std_logic_vector (7 downto 0) := "00000000";
        DP_out: out std_logic;
        CA_out: out std_logic;
        CB_out: out std_logic;
        CC_out: out std_logic;
        CD_out: out std_logic;
        CE_out: out std_logic;
        CF_out: out std_logic;
        CG_out: out std_logic
    );
end display;

architecture display_arch of display is
begin
    Display: process(Clk_in, Rst_in)
        variable temp: integer range 1 to 5 := 5;
    begin
        if Rst_in = '1' then
            DIGITS_out <= "11111111";
        elsif rising_edge(Clk_in) then
            if temp = 5 then
                DIGITS_out <= "01111111";
                if F_in = '0' then CA_out <= '0'; CB_out <= '1'; CC_out <= '1'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '1'; DP_out <= '1';
                else CA_out <= '0'; CB_out <= '1'; CC_out <= '1'; CD_out <= '1'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                end if;
            elsif temp = 4 then
                DIGITS_out <= "11110111";
                if th_in = 10 then
                    DIGITS_out <= "11111111";
                elsif th_in = 9 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 8 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 7 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                elsif th_in = 6 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 5 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 4 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 3 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 2 then CA_out <= '0'; CB_out <= '0'; CC_out <= '1'; CD_out <= '0'; CE_out <= '0'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif th_in = 1 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                else  CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '1'; DP_out <= '1';
                end if;
            elsif temp = 3 then
                DIGITS_out <= "11111011";
                if rd_in = 9 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 8 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 7 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                elsif rd_in = 6 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 5 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 4 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 3 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 2 then CA_out <= '0'; CB_out <= '0'; CC_out <= '1'; CD_out <= '0'; CE_out <= '0'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif rd_in = 1 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                else  CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '1'; DP_out <= '1';
                end if;
            elsif temp = 2 then
                DIGITS_out <= "11111101";
                if nd_in = 9 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 8 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 7 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '0';
                elsif nd_in = 6 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 5 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 4 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 3 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '1'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 2 then CA_out <= '0'; CB_out <= '0'; CC_out <= '1'; CD_out <= '0'; CE_out <= '0'; CF_out <= '1'; CG_out <= '0'; DP_out <= '0';
                elsif nd_in = 1 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '0';
                else  CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '1'; DP_out <= '1';
                end if;
            elsif temp = 1 then
                DIGITS_out <= "11111110";
                if st_in = 9 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 8 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 7 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                elsif st_in = 6 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 5 then CA_out <= '0'; CB_out <= '1'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 4 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '0'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 3 then CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '1'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 2 then CA_out <= '0'; CB_out <= '0'; CC_out <= '1'; CD_out <= '0'; CE_out <= '0'; CF_out <= '1'; CG_out <= '0'; DP_out <= '1';
                elsif st_in = 1 then CA_out <= '1'; CB_out <= '0'; CC_out <= '0'; CD_out <= '1'; CE_out <= '1'; CF_out <= '1'; CG_out <= '1'; DP_out <= '1';
                else  CA_out <= '0'; CB_out <= '0'; CC_out <= '0'; CD_out <= '0'; CE_out <= '0'; CF_out <= '0'; CG_out <= '1'; DP_out <= '1';
                end if;
            end if;
            if temp = 1 then temp := 5;
            else temp := temp - 1;
            end if;
        end if;
    end process Display;
end display_arch;