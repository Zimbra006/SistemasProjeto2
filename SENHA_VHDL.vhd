Library IEEE;

Use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity senha_vhdl is

Port (
-----------------------------------------------------
clk, reset, front_sensor, back_sensor, enable, isGuest: in std_logic;
password: in std_logic_vector(3 downto 0);
-----------------------------------------------------
Green_led, red_led, done_senha: out std_logic);

End senha_vhdl;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

Architecture TypeArchitecture of senha_vhdl is

TYPE states IS (idle, waiting_password, right_pass, wrong_pass, guest, stop);
SIGNAL current_state, next_state: states;
SIGNAL red_tmp, green_tmp: std_logic;
SIGNAL counter_wait : std_logic_vector (3 downto 0);
SIGNAL sum : std_logic_vector (3 downto 0) := "0001";

BEGIN


PROCESS(clk, reset, enable)
BEGIN
	IF (reset = '1') THEN
	
		current_state <= idle;
		
	ELSIF (rising_edge(clk) and (enable = '1')) THEN
	
		current_state <= next_state;
		
	END IF;
END PROCESS;


PROCESS(current_state, password, front_sensor, back_sensor, isGuest)
BEGIN

	CASE current_state IS
		WHEN idle =>
			IF (front_sensor = '1') THEN

				next_state <= waiting_password;

			ELSE

				next_state <= idle;

			END IF;
			
		WHEN waiting_password =>

			IF (counter_wait >= "0011") THEN
				IF(password = "0110") THEN

					next_state <= right_pass;

				ELSE

					next_state <= wrong_pass;

				END IF;

			ELSIF (isGuest = '1') THEN
				
				next_state <= guest;
			
			ELSE

				next_state <= waiting_password;

			END IF;
			
		WHEN right_pass =>

			IF (back_sensor = '1' and front_sensor='1') THEN

				next_state <= stop;

			ELSIF (back_sensor = '1') THEN

				next_state <= idle;

			ELSE

				next_state <= right_pass;

			END IF;
		
		WHEN wrong_pass =>

			If (password = "0110") then

				next_state <= right_pass;

			ELSIF (isGuest = '1') THEN
				
				next_state <= guest;
			ELSE

				next_state <= wrong_pass;

			End if;
		
		WHEN stop =>

			IF (password = "0110") THEN

				Next_state <= right_pass;

			ELSIF (isGuest = '1') THEN
				
				next_state <= guest;
			ELSE

				Next_state <= stop;

			END IF;
		
		WHEN guest =>
			next_state <= guest;

		END CASE;

END PROCESS;
	
PROCESS(clk, reset)
BEGIN

	IF (reset = '1') THEN

		counter_wait <= (others => '0');

	ELSIF (rising_edge(clk)) THEN

		IF (current_state = waiting_password) THEN

			counter_wait <= std_logic_vector(unsigned(counter_wait) + unsigned(sum));

		ELSE

			counter_wait <= (others => '0');

		END IF;

	END IF;

End PROCESS;

PROCESS (clk)
BEGIN

IF (rising_edge(clk)) THEN

	CASE current_state IS

		WHEN idle =>

			green_tmp <= '0';

			red_tmp <= '1';
			
			done_senha <= '0';
		WHEN waiting_password=>

			green_tmp <= '0';

			red_tmp <= '1';

		WHEN right_pass =>

			green_tmp <= '1';

			red_tmp <= '0';
			
			done_senha <= '1';

		WHEN wrong_pass =>

			green_tmp <= '0';

			red_tmp <= '1';
		
		WHEN guest =>
		
			green_tmp <= '0';

			red_tmp <= '1';
			
			done_senha <= '1';

		WHEN stop =>

			green_tmp <= '0';

			red_tmp <= '1';

		END CASE;

END IF;

END PROCESS;

red_led <= red_tmp;
green_led <= green_tmp;
	
END TypeArchitecture;
