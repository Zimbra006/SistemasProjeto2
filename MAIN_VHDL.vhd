LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY main_vhdl IS
  PORT (
 
    CLK_MAIN               : IN  std_logic;                    
	 IS_GUEST               : IN  std_logic;
    PASSWORD_MAIN          : IN  std_logic_vector(3 downto 0);
	 ADD_1_MAIN, ADD_2_MAIN : IN  std_logic;
	 FT_SENSOR, BK_SENSOR   : IN  std_logic;
	 -----------------------------
	 LED_ETAPA_SENHA    : OUT std_logic;
	 LED_ETAPA_COBRAR   : OUT std_logic;
	 LED_SENHA_ACEITA   : OUT std_logic;
	 LED_SENHA_NEGADA   : OUT std_logic;
	 ABERTO             : OUT std_logic
    );
END main_vhdl;

ARCHITECTURE TypeArchitecture OF main_vhdl IS

COMPONENT SENHA_VHDL IS 
	PORT(
		-----------------------------------------------------
		clk, reset, enable, isGuest: in std_logic;
		password: in std_logic_vector(3 downto 0);
		-----------------------------------------------------
		Green_led, red_led, done_senha: out std_logic
		);

END COMPONENT;

COMPONENT COBRAR_VHDL IS

PORT (
  ------------------------------------------------------------------------------
    add1, add2, clk, raise_price, reset, enable      : IN  std_logic;                
  ------------------------------------------------------------------------------
    opening        : OUT std_logic   
    );

END COMPONENT;

COMPONENT CONTROLADOR_VHDL IS

PORT (
 
    CLK          : IN  std_logic;                    
    FRONT_SENSOR : IN  std_logic;
	 BACK_SENSOR  : IN  std_logic;
    COMP         : IN  std_logic;                    
    DONE_SENHA   : IN  std_logic;
	 -----------------------------
    RESET_SENHA  : OUT std_logic;
    RESET_PRICE  : OUT std_logic;
	 ENABLE_SENHA : OUT std_logic;
	 ENABLE_PRICE : OUT std_logic;
    ABRINDO      : OUT std_logic;
	 -----------------------------
	 LED_SENHA    : OUT std_logic;
	 LED_COBRAR   : OUT std_logic
	 
    );

END COMPONENT;
SIGNAL comparacao, dn_senha, rs_senha, rs_price, en_senha, en_price, visitante : std_logic;
BEGIN


u1 : CONTROLADOR_VHDL 
PORT MAP(
-- Sinais de comparação ------
CLK => CLK_MAIN, 
FRONT_SENSOR => FT_SENSOR, 
BACK_SENSOR => BK_SENSOR,
COMP => comparacao,
DONE_SENHA => dn_senha,
-- Sinais de controle do sistema ----
RESET_SENHA => rs_senha, 
RESET_PRICE => rs_price, 
ENABLE_SENHA => en_senha, 
ENABLE_PRICE => en_price, 
ABRINDO => ABERTO,
LED_SENHA => LED_ETAPA_SENHA, 
LED_COBRAR => LED_ETAPA_COBRAR);

u2 : SENHA_VHDL
PORT MAP(
-- Inputs --
clk => CLK_MAIN, 
reset => rs_senha, 
enable => en_senha, 
isGuest => IS_GUEST,
password => PASSWORD_MAIN,
-- Outputs --
Green_led => LED_SENHA_ACEITA, 
red_led => visitante, 
done_senha => dn_senha);

LED_SENHA_NEGADA <= visitante;

u3 : COBRAR_VHDL
PORT MAP(
-- Inputs -- 
add1 => ADD_1_MAIN, 
add2 => ADD_2_MAIN, 
clk => CLK_MAIN, 
raise_price => visitante, 
reset => rs_price, 
enable => en_price,
-- Output --
opening => comparacao);


END TypeArchitecture;
