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
    IfFarenhait: process(Clk_in)
    begin
        if rising_edge(Clk_in) then
            if SW_in = '0' then
                F_out <= '0';
            else
                F_out <= '1';
            end if;
        end if;
    end process IfFarenhait;
end switch_arch;
--The output of the Switch entity depends on the switch’s position.
--It is either 0 or 1: when it is 0, the temperature displayed will be in degrees of Celsius,
--when it is 1, the temperature displayed will be in degrees of Fahrenheit.
