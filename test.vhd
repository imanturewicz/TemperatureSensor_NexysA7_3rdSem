library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity runninglights is
    Port (
        CLK :  in  STD_LOGIC;
        RST :  in  STD_LOGIC;
        LED : out  STD_LOGIC_VECTOR (15 downto 0);
        DIGITS: out std_logic_vector (7 downto 0) := "11111010";
        DP: out std_logic	 );
end runninglights;

architecture Behavioral of runninglights is
begin
    process(CLK, RST)
        variable temp: std_logic_vector (15 downto 0);
        variable count: std_logic_vector (4 downto 0);
    begin
        if RST = '1' then
            temp := "1000000000000000";
            count := "00000";
        elsif rising_edge(CLK) then
            if count < "01111" then
                temp := temp(0) & temp(15 downto 1);
                --DP <= '1';
            elsif count >= "01111" then
                temp := temp(14 downto 0) & temp(15);
                --DP <= '0';
            end if;
            count := count + '1';
            if count = "11110" then
                count := "00000";
            end if;
        end if;
        LED <= temp;
    end process;
    
    
end Behavioral;
