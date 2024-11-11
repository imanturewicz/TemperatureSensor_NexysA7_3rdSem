library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;

entity Temperature_Sensor_tl is
    Port (
        CLK100MHZ :  in  STD_LOGIC;
        RST :  in  STD_LOGIC;
        DIGITS: out std_logic_vector (7 downto 0);
        DP: out std_logic;
        CA: out std_logic;
        CB: out std_logic;
        CC: out std_logic;
        CD: out std_logic;
        CE: out std_logic;
        CF: out std_logic;
        CG: out std_logic
    );
end Temperature_Sensor_tl;

architecture TempSensTL_arch of Temperature_Sensor_tl is
    signal CLK: std_logic;
    signal F: std_logic := '0';
    signal temperatura: integer range 0 to 2000 := 366;
    signal th: integer range 0 to 10;
    signal rd: integer range 0 to 9;
    signal nd: integer range 0 to 9;
    signal st: integer range 0 to 9;

    component divider is
    Port (
        CLK_in :  in  STD_LOGIC;
        RST_in :  in  STD_LOGIC;
        CLK_out : out  STD_LOGIC
    );
    end component;

    component display_control is
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
    end component;
    
    component display is
    Port (
        CLK_in: in std_logic;
        RST_in: in std_logic;
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
    end component;
begin
    divider_1: divider
    port map(
        CLK_in => CLK100MHZ,
        RST_in => RST,
        CLK_out => CLK
    );

    display_control_1: display_control
    port map(
        CLK_in => CLK,
        RST_in => RST,
        F_in => F,
        temperatura_in => temperatura,
        th_out => th,
        rd_out => rd,
        nd_out => nd,
        st_out => st
    );

    display_1: display
    port map(
        CLK_in => CLK,
        RST_in => RST,
        th_in => th,
        rd_in => rd,
        nd_in => nd,
        st_in => st,
        F_in => F,
        DIGITS_out => DIGITS,
        DP_out => DP,
        CA_out => CA,
        CB_out => CB,
        CC_out => CC,
        CD_out => CD,
        CE_out => CE,
        CF_out => CF,
        CG_out => CG
    );

end TempSensTL_arch;