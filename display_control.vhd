library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_control is
    Port (
        CLK_in: in std_logic;
        F_in: in std_logic;
        temperatura_in: in integer range 0 to 10000;
        th_out: out integer range 0 to 9;        --digits to display (4th, 3rd, 2nd, 1st)
        rd_out: out integer range 0 to 9;
        nd_out: out integer range 0 to 9;
        st_out: out integer range 0 to 9
    );
end display_control;

architecture disp_cntrl_arch of display_control is
    signal temperaturef: integer range 0 to 10000;
begin
    TempChange: process(Clk_in)
    begin
        if rising_edge(Clk_in) then
            temperaturef <= temperatura_in * 9 / 5 + 3200;        --changing the temperature to degrees of Fahrenhait multiplied by 100
        end if;
    end process TempChange;

    Control: process(CLK_in)
        variable temp1: integer;
        variable temp2: integer;
    begin
        if rising_edge(CLK_in) then        --parsing the tens, units, tenth and hundredth parts
            if F_in = '0' then
                th_out <= temperatura_in / 1000;
                temp1 := temperatura_in - (1000 * (temperatura_in/1000));
                rd_out <= temp1 / 100;
                temp2 := temp1 - (100 * (temp1/100));
                nd_out <= temp2 / 10;
                st_out <= temp2 - (10 * (temp2/10));
            else
                th_out <= temperaturef / 1000;
                temp1 := temperaturef - (1000 * (temperaturef/1000));
                rd_out <= temp1 / 100;
                temp2 := temp1 - (100 * (temp1/100));
                nd_out <= temp2 / 10;
                st_out <= temp2 - (10 * (temp2/10));
            end if;
        end if;
    end process Control;
end disp_cntrl_arch;
--The Display Controller entity is responsible for manipulating the results obtained from the temperature sensor.
--It takes the temperature reading (in degrees of Celsius multiplied by one hundred) as an input.
--It outputs four decimal digits to be shown on the display. The scale in which the result is passed depends on the switch.
