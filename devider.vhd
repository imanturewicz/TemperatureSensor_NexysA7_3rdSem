library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port (
        CLK_in :  in  STD_LOGIC;
        RST :     in  STD_LOGIC;
        CLK_out : out  STD_LOGIC);
end divider;

architecture Behavioral of divider is
begin
    process(CLK_in, RST)
        variable count: integer;
    begin
        if RST = '1' then
            count := 0;
            CLK_out <= '0';
        elsif rising_edge(CLK_in) then
            if count >= 0 and count < 5000000 then
                CLK_out <= '1';
            elsif count >= 5000000 and count < 10000000 then
                CLK_out <= '0';
            elsif count = 10000000 then
                count := 0;
            end if;
            count := count + 1;
        end if;
    end process;
end Behavioral;
