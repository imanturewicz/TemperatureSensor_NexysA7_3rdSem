LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY temp_sensor IS
  GENERIC(
    sys_clk_freq     : INTEGER := 50_000_000;                      -- System clock frequency in Hz
    temp_sensor_addr : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1001011"  -- I2C address of the temperature sensor
  );
  PORT(
    clk         : IN    STD_LOGIC;                                 -- System clock
    rst_n       : IN    STD_LOGIC;                                 -- Active-low reset
    scl         : INOUT STD_LOGIC;                                 -- I2C serial clock
    sda         : INOUT STD_LOGIC;                                 -- I2C serial data
    --i2c_ack_err : OUT   STD_LOGIC;                                 -- I2C acknowledge error flag (small change with Alvin's)
    temp        : OUT   integer range 0 to 10000                  -- Temperature value (small change with Alvin's)
  );
END temp_sensor;

ARCHITECTURE behavior OF temp_sensor IS
  -- Define the states of the state machine
  TYPE machine IS (startstate, setresolution, pausestate, read_data, output_result);
  SIGNAL state           : machine;                       -- State machine signal
  SIGNAL i2cena          : STD_LOGIC;                     -- I2C enable signal
  SIGNAL i2caddr         : STD_LOGIC_VECTOR(6 DOWNTO 0);  -- I2C target address
  SIGNAL i2crw           : STD_LOGIC;                     -- I2C read/write command
  SIGNAL i2cdatawr       : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- I2C write data
  SIGNAL i2cdatard       : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- I2C read data
  SIGNAL i2cbusy         : STD_LOGIC;                     -- I2C busy signal
  SIGNAL busyprev        : STD_LOGIC;                     -- Previous value of I2C busy signal
  SIGNAL tempdata        : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Buffer for raw temperature data
  SIGNAL temperatureraw  : UNSIGNED(12 DOWNTO 0);         -- Raw temperature after processing
  SIGNAL temperaturescaled : UNSIGNED(15 DOWNTO 0);       -- Scaled temperature value
  signal i2c_ack_err :    STD_LOGIC;   --small change with Alvin's

  -- I2C Master component declaration
  COMPONENT i2c_master IS
    GENERIC(
      input_clk : INTEGER;  -- Input clock frequency in Hz
      bus_clk   : INTEGER   -- I2C bus clock frequency in Hz
    );
    PORT(
      clk       : IN    STD_LOGIC;                      -- System clock
      rst_n     : IN    STD_LOGIC;                      -- Active-low reset
      ena       : IN    STD_LOGIC;                      -- Enable transaction
      addr      : IN    STD_LOGIC_VECTOR(6 DOWNTO 0);   -- Target slave address
      rw        : IN    STD_LOGIC;                      -- Read/Write control ('0' for write, '1' for read)
      data_wr   : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Data to write
      busy      : OUT   STD_LOGIC;                      -- Indicates ongoing transaction
      data_rd   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Data read from slave
      ack_error : BUFFER STD_LOGIC;                     -- Acknowledge error flag
      sda       : INOUT STD_LOGIC;                      -- I2C data line
      scl       : INOUT STD_LOGIC                       -- I2C clock line
    );
  END COMPONENT;

BEGIN
  -- Instantiate the I2C Master
  i2c_master_0: i2c_master
    GENERIC MAP(input_clk => sys_clk_freq, bus_clk => 400_000)
    PORT MAP(
      clk => clk, rst_n => rst_n, ena => i2cena, addr => i2caddr,
      rw => i2crw, data_wr => i2cdatawr, busy => i2cbusy,
      data_rd => i2cdatard, ack_error => i2c_ack_err, sda => sda, scl => scl
    );

  PROCESS(clk, rst_n)
    VARIABLE busycnt : INTEGER RANGE 0 TO 3 := 0;        -- Counts I2C busy transitions
    VARIABLE counter : INTEGER RANGE 0 TO sys_clk_freq/10 := 0; -- 100ms delay counter
  BEGIN
    IF (rst_n = '0') THEN
      -- Reset logic
      counter := 0;
      i2cena  <= '0';
      busycnt := 0;
      --temp <= (OTHERS => '0');            small change with Alvin's
    temp <= 0;                            --small change with Alvin's
      state <= startstate;
    ELSIF (clk'EVENT AND clk = '1') THEN
      -- State machine logic
      CASE state IS
        WHEN startstate =>
          -- Wait 100ms before starting communication
          IF (counter < sys_clk_freq/10) THEN
            counter := counter + 1;
          ELSE
            counter := 0;
            state <= setresolution;
          END IF;

        WHEN setresolution =>
          -- Configure the temperature sensor
          busyprev <= i2cbusy;
          IF (busyprev = '0' AND i2cbusy = '1') THEN
            busycnt := busycnt + 1;
          END IF;
          CASE busycnt IS
            WHEN 0 =>
              i2cena <= '1';
              i2caddr <= temp_sensor_addr;
              i2crw <= '0';
              i2cdatawr <= "00000011"; -- Address of Configuration Register
            WHEN 1 =>
              i2cdatawr <= "10000000"; -- Set 16-bit resolution
            WHEN 2 =>
              i2cena <= '0';
              IF (i2cbusy = '0') THEN
                busycnt := 0;
                state <= pausestate;
              END IF;
            WHEN OTHERS => NULL;
          END CASE;

        WHEN pausestate =>
          -- Pause between transactions
          IF (counter < sys_clk_freq/769_000) THEN
            counter := counter + 1;
          ELSE
            counter := 0;
            state <= read_data;
          END IF;

        WHEN read_data =>
          -- Read temperature data
          busyprev <= i2cbusy;
          IF (busyprev = '0' AND i2cbusy = '1') THEN
            busycnt := busycnt + 1;
          END IF;
          CASE busycnt IS
            WHEN 0 =>
              i2cena <= '1';
              i2caddr <= temp_sensor_addr;
              i2crw <= '0';
              i2cdatawr <= "00000000"; -- Address of Temperature Value MSB Register
            WHEN 1 =>
              i2crw <= '1';
            WHEN 2 =>
              IF (i2cbusy = '0') THEN
                tempdata(15 DOWNTO 8) <= i2cdatard; -- MSB data
              END IF;
            WHEN 3 =>
              i2cena <= '0';
              IF (i2cbusy = '0') THEN
                tempdata(7 DOWNTO 0) <= i2cdatard; -- LSB data
                busycnt := 0;
                state <= output_result;
              END IF;
            WHEN OTHERS => NULL;
          END CASE;

        WHEN output_result =>
          -- Process and output temperature data
          temperatureraw <= unsigned(tempdata(15 DOWNTO 3));
          temperaturescaled <= resize((temperatureraw * 625) / 100, 16);
          temp <= to_integer(signed(std_logic_vector(temperaturescaled)));              --small change with Alvin's
          state <= pausestate;

        WHEN OTHERS =>
          state <= startstate;
      END CASE;
    END IF;
  END PROCESS;
END behavior;
