library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;

entity switch is
    Port (
        CLK_in: in std_logic;
        SW_in: in std_logic;
        F_out: out std_logic
    );
end switch;

architecture switch_arch of switch is
begin
    CzyFarenhait: process(Clk_in)
    begin
        if rising_edge(Clk_in) then
            if SW_in = '0' then
                F_out <= '0';
            else
                F_out <= '1';
            end if;
        end if;
    end process CzyFarenhait;
end switch_arch;
