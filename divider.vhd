library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port (
        CLK_in :  in  STD_LOGIC;
        RST_in :     in  STD_LOGIC;
        CLK_out : out  STD_LOGIC);
end divider;

architecture divider_arch of divider is
begin
    process(CLK_in, RST_in)
        variable count: integer;
    begin
        if RST_in = '1' then
            count := 0;
            CLK_out <= '0';
        elsif rising_edge(CLK_in) then
            if count >= 0 and count < 50000 then
                CLK_out <= '1';
            elsif count >= 50000 and count < 100000 then
                CLK_out <= '0';
            elsif count = 100000 then
                count := 0;
            end if;
            count := count + 1;
        end if;
    end process;
end divider_arch;
