LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY i2c_master IS
  GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    rst_n     : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END i2c_master;

ARCHITECTURE logic OF i2c_master IS
  CONSTANT divider  :  INTEGER := (input_clk/bus_clk)/4; --number of clocks in 1/4 cycle of scl
  TYPE machine IS(readystate, startstate, command, slv_ack1, write, read, slv_ack2, mstr_ack, stopstate); --needed states
  SIGNAL state         : machine;                        --state machine
  SIGNAL dataclk      : STD_LOGIC;                      --data clock for sda
  SIGNAL dataclkprev : STD_LOGIC;                      --data clock during previous system clock
  SIGNAL scl_clk       : STD_LOGIC;                      --constantly running internal scl
  SIGNAL scl_ena       : STD_LOGIC := '0';               --enables internal scl to output
  SIGNAL sda_int       : STD_LOGIC := '1';               --internal sda
  SIGNAL sda_ena_n     : STD_LOGIC;                      --enables internal sda to output
  SIGNAL addrrw       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --latched in address and read/write
  SIGNAL datatx       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --latched in data to write to slave
  SIGNAL datarx       : STD_LOGIC_VECTOR(7 DOWNTO 0);   --data received from slave
  SIGNAL bit_cnt       : INTEGER RANGE 0 TO 7 := 7;      --tracks bit number in transaction
  SIGNAL stretch       : STD_LOGIC := '0';               --identifies if slave is stretching scl
BEGIN

  --generate the timing for the bus clock (scl_clk) and the data clock
  PROCESS(clk, rst_n)
    VARIABLE count  :  INTEGER RANGE 0 TO divider*4;  --timing for clock generation
  BEGIN
    IF(rst_n = '0') THEN                --reset asserted
      stretch <= '0';
      count := 0;
    ELSIF(clk'EVENT AND clk = '1') THEN
      dataclkprev <= dataclk;          --store previous value of data clock
      IF(count = divider*4-1) THEN        --end of timing cycle
        count := 0;                       --reset timer
      ELSIF(stretch = '0') THEN           --clock stretching from slave not detected
        count := count + 1;               --continue clock generation timing
      END IF;
      CASE count IS
        WHEN 0 TO divider-1 =>            --first 1/4 cycle of clocking
          scl_clk <= '0';
          dataclk <= '0';
        WHEN divider TO divider*2-1 =>    --second 1/4 cycle of clocking
          scl_clk <= '0';
          dataclk  <= '1';
        WHEN divider*2 TO divider*3-1 =>  --third 1/4 cycle of clocking
          scl_clk <= '1';                 --release scl
          IF(scl = '0') THEN              --detect if slave is stretching clock
            stretch <= '1';
          ELSE
            stretch <= '0';
          END IF;
          dataclk  <= '1';
        WHEN OTHERS =>                    --last 1/4 cycle of clocking
          scl_clk <= '1';
          dataclk  <= '0';
      END CASE;
    END IF;
  END PROCESS;

  --state machine and writing to sda during scl low (data_clk rising edge)
  PROCESS(clk, rst_n)
  BEGIN
    IF(rst_n = '0') THEN                 --reset asserted
      state <= readystate;                      --return to initial state
      busy <= '1';                         --indicate not available
      scl_ena <= '0';                      --sets scl high impedance
      sda_int <= '1';                      --sets sda high impedance
      ack_error <= '0';                    --clear acknowledge error flag
      bit_cnt <= 7;                        --restarts data bit counter
      data_rd <= "00000000";               --clear data read port
    ELSIF(clk'EVENT AND clk = '1') THEN
      IF(dataclk = '1' AND dataclkprev = '0') THEN  --data clock rising edge
        CASE state IS
          WHEN readystate =>                      --idle state
            IF(ena = '1') THEN               --transaction requested
              busy <= '1';                   --flag busy
              addrrw <= addr & rw;          --collect requested slave address and command
              datatx <= data_wr;            --collect requested data to write
              state <= startstate;               
            ELSE                             
              busy <= '0';                   
              state <= readystate;               
            END IF;
          WHEN startstate =>                      --start bit of transaction
            busy <= '1';                     --resume busy if continuous mode
            sda_int <= addrrw(bit_cnt);     --set first address bit to bus
            state <= command;                
          WHEN command =>                    --address and command byte of transaction
            IF(bit_cnt = 0) THEN             --command transmit finished
              sda_int <= '1';                --release sda for slave acknowledge
              bit_cnt <= 7;                  --reset bit counter for "byte" states
              state <= slv_ack1;             --go to slave acknowledge (command)
            ELSE                             --next clock cycle of command state
              bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
              sda_int <= addrrw(bit_cnt-1); --write address/command bit to bus
              state <= command;              
            END IF;
          WHEN slv_ack1 =>                   --slave acknowledge bit (command)
            IF(addrrw(0) = '0') THEN       
              sda_int <= datatx(bit_cnt);   --write first bit of data
              state <= write;                  
            ELSE                             --read command
              sda_int <= '1';                --release sda from incoming data
              state <= read;                   
            END IF;
          WHEN write =>                         --write byte of transaction
            busy <= '1';                     --resume busy if continuous mode
            IF(bit_cnt = 0) THEN             --write byte transmit finished
              sda_int <= '1';                --release sda for slave acknowledge
              bit_cnt <= 7;                  --reset bit counter for "byte" states
              state <= slv_ack2;             --go to slave acknowledge (write)
            ELSE                             --next clock cycle of write state
              bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
              sda_int <= datatx(bit_cnt-1); --write next bit to bus
              state <= write;                  
            END IF;
          WHEN read =>                         --read byte of transaction
            busy <= '1';                     --resume busy if continuous mode
            IF(bit_cnt = 0) THEN             --read byte receive finished
              IF(ena = '1' AND addrrw = addr & rw) THEN  --continuing with another read at same address
                sda_int <= '0';              --acknowledge the byte has been received
              ELSE                           --stopping or continuing with a write
                sda_int <= '1';              --send a no-acknowledge (before stop or repeated start)
              END IF;
              bit_cnt <= 7;                  --reset bit counter for "byte" states
              data_rd <= datarx;            --output received data
              state <= mstr_ack;             --go to master acknowledge
            ELSE                             --next clock cycle of read state
              bit_cnt <= bit_cnt - 1;        --keep track of transaction bits
              state <= read;                 
            END IF;
          WHEN slv_ack2 =>                   --slave acknowledge bit (write)
            IF(ena = '1') THEN               --continue transaction
              busy <= '0';                   --continue is accepted
              addrrw <= addr & rw;          --collect requested slave address and command
              datatx <= data_wr;            --collect requested data to write
              IF(addrrw = addr & rw) THEN   --continue transaction with another write
                sda_int <= data_wr(bit_cnt); --write first bit of data
                state <= write;                 
              ELSE                           --continue transaction with a read or new slave
                state <= startstate;              
              END IF;
            ELSE                             --complete transaction
              state <= stopstate;                
            END IF;
          WHEN mstr_ack =>                   --master acknowledge bit after a read
            IF(ena = '1') THEN               
              busy <= '0';                   --continue is accepted and data received is available on bus
              addrrw <= addr & rw;          --collect requested slave address and command
              datatx <= data_wr;            --collect requested data to write
              IF(addrrw = addr & rw) THEN   --continue transaction with another read
                sda_int <= '1';              --release sda from incoming data
                state <= read;                 
              ELSE                           --continue transaction with a write or new slave
                state <= startstate;              
              END IF;    
            ELSE                             --complete transaction
              state <= stopstate;                
            END IF;
          WHEN stopstate =>                       --stop bit of transaction
            busy <= '0';                     --unflag busy
            state <= readystate;                  
        END CASE;    
      ELSIF(dataclk = '0' AND dataclkprev = '1') THEN  --data clock falling edge
        CASE state IS
          WHEN startstate =>                  
            IF(scl_ena = '0') THEN                  --starting new transaction
              scl_ena <= '1';                       --enable scl output
              ack_error <= '0';                     --reset acknowledge error output
            END IF;
          WHEN slv_ack1 =>                          --receiving slave acknowledge (command)
            IF(sda /= '0' OR ack_error = '1') THEN  --no-acknowledge or previous no-acknowledge
              ack_error <= '1';                     --set error output if no-acknowledge
            END IF;
          WHEN read =>                                --receiving slave data
            datarx(bit_cnt) <= sda;                --receive current slave data bit
          WHEN slv_ack2 =>                          --receiving slave acknowledge (write)
            IF(sda /= '0' OR ack_error = '1') THEN  --no-acknowledge or previous no-acknowledge
              ack_error <= '1';                     --set error output if no-acknowledge
            END IF;
          WHEN stopstate =>
            scl_ena <= '0';                         --disable scl
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;  

  --set sda output
  WITH state SELECT
    sda_ena_n <= dataclkprev WHEN startstate,     --generate start condition
                 NOT dataclkprev WHEN stopstate,  --generate stop condition
                 sda_int WHEN OTHERS;          --set to internal sda signal    
      
  --set scl and sda outputs
  scl <= '0' WHEN (scl_ena = '1' AND scl_clk = '0') ELSE 'Z';
  sda <= '0' WHEN sda_ena_n = '0' ELSE 'Z';
  
END logic;