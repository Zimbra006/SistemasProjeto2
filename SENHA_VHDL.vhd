Library IEEE;

Use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity senha_vhdl is

Port (
-----------------------------------------------------
clk, reset, enable, isGuest: in std_logic;
password: in std_logic_vector(3 downto 0);
-----------------------------------------------------

-- O sinal de done_senha existe para indicar para o controlador que esse componente já
-- terminou sua função
Green_led, red_led, done_senha: out std_logic);

End senha_vhdl;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

Architecture TypeArchitecture of senha_vhdl is

TYPE states IS (idle, waiting_password, right_pass, wrong_pass, guest);
SIGNAL current_state, next_state: states;
SIGNAL red_tmp, green_tmp: std_logic;
SIGNAL counter_wait : std_logic_vector (3 downto 0);
SIGNAL sum : std_logic_vector (3 downto 0) := "0001";

BEGIN


PROCESS(clk, reset, enable)
BEGIN
 IF (reset = '1') THEN
 -- Resetamos o circuito quando um novo carro entra
 
  current_state <= idle;
  
 ELSIF (rising_edge(clk) and (enable = '1')) THEN
 -- Esse componente só começa a rodar quando o controlador da o sinal
  current_state <= next_state;
  
 END IF;
END PROCESS;


PROCESS(current_state, password, isGuest)
BEGIN

 CASE current_state IS
  WHEN idle =>

    next_state <= waiting_password;
   
  WHEN waiting_password =>
   -- Espera alguns sinais de clock antes de começar a checar pela senha
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

   -- Fizemos assim pois dessa forma ele permanece no estado
   -- onde o output que indica se é convidado é constante

    next_state <= right_pass;
  
  WHEN wrong_pass =>

   If (password = "0110") then

    next_state <= right_pass;

   ELSIF (isGuest = '1') THEN
    
    next_state <= guest;
   ELSE

    next_state <= wrong_pass;

   End if;
  
  WHEN guest =>
   -- Fizemos assim pois dessa forma ele permanece no estado
   -- onde o output que indica se é convidado é constante
  
   next_state <= guest;

  END CASE;

END PROCESS;
 
PROCESS(clk, reset)
BEGIN

 IF (reset = '1') THEN

  counter_wait <= (others => '0');

 ELSIF (rising_edge(clk)) THEN

  IF (current_state = waiting_password) THEN
  -- Incrementa o contador para a espera da senha utilizando uma soma
  -- entre vetores unsigned

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

   red_tmp <= '0';
   
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

  END CASE;

END IF;

END PROCESS;

red_led <= red_tmp;
green_led <= green_tmp;
 
END TypeArchitecture;
