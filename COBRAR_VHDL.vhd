LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY cobrar_vhdl IS
  PORT (
  ------------------------------------------------------------------------------
    add1, add2, clk, raise_price, reset, enable      : IN  std_logic;                
  ------------------------------------------------------------------------------
    opening        : OUT std_logic   
    );
END cobrar_vhdl;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE TypeArchitecture OF cobrar_vhdl IS

TYPE states IS (waiting, add_2, add_1, check, paid);
SIGNAL current_state, next_state : states := waiting;
SIGNAL money : integer := 0;
BEGIN

PROCESS(clk, reset, enable)
BEGIN
	IF (reset = '1') THEN
	
		current_state <= waiting;
		
	ELSIF (rising_edge(clk) and (enable = '1')) THEN
	
		current_state <= next_state;
		
	END IF;
END PROCESS;

PROCESS (clk, raise_price)
	VARIABLE cost : integer := 5;
BEGIN
	IF (raise_price = '1') THEN
		cost := 7;
	END IF;
	
	IF (rising_edge(clk)) THEN
		CASE current_state IS
			WHEN waiting =>
				IF (add2 = '1') THEN
					next_state <= add_2;
				ELSIF (add1 = '1') THEN
					next_state <= add_1;
				ELSE
					next_state <= waiting;
				END IF;
			WHEN add_2 | add_1 =>
				next_state <= check;
			WHEN check =>
				IF (money >= cost) THEN
					next_state <= paid;
				ELSE
					next_state <= waiting;
				END IF;
			WHEN paid =>
				next_state <= waiting;
			WHEN others =>
				next_state <= waiting;
		END CASE;
	END IF;
END PROCESS;

PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) THEN
		CASE current_state IS
			WHEN waiting =>
				opening <= '0';
			WHEN add_2 =>
				money <= money + 2;
			WHEN add_1 =>
				money <= money + 1;
			WHEN check =>
				null;
			WHEN paid =>
				opening <= '1';
			WHEN others =>
				opening <= '0';
				money <= 0;
		END CASE;
	END IF;
END PROCESS;

END TypeArchitecture;
