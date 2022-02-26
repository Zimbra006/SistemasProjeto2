LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY main_vhdl IS
  PORT (
 
          SW   : IN  std_logic_vector(17 downto 0); 
  
                          --- CLK_MAIN         SW(0)                   
                         --- IS_GUEST         SW(1)
                          --- PASSWORD_MAIN    SW(5 downto 2)
                         --- ADD_1_MAIN       SW(6)
                         --- ADD_2_MAIN       SW(7)
                         --- FT_SENSOR        SW(8)
                         --- BK_SENSOR        SW(9)
  ----------------------------- 
          LEDG              : OUT std_logic_vector(8 downto 0);            
         LEDR              : OUT std_logic_vector(17 downto 0)  
  -----------------------------
                          --- LED_ETAPA_SENHA   LEDR(2)
                          --- LED_ETAPA_COBRAR  LEDR(1)
                          --- LED_SENHA_ACEITA LEDG(1)
                          --- LED_SENHA_NEGADA LEDR(0)
                          --- ABERTO LEDG(0)    
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
CLK => SW(0), 
FRONT_SENSOR => SW(8), 
BACK_SENSOR => SW(9),
COMP => comparacao,
DONE_SENHA => dn_senha,
-- Sinais de controle do sistema ----
RESET_SENHA => rs_senha, 
RESET_PRICE => rs_price, 
ENABLE_SENHA => en_senha, 
ENABLE_PRICE => en_price, 
ABRINDO => LEDG(0),
LED_SENHA => LEDR(2), 
LED_COBRAR => LEDR(1));

u2 : SENHA_VHDL
PORT MAP(
-- Inputs --
clk => SW(0), 
reset => rs_senha, 
enable => en_senha, 
isGuest => SW(1),
password => SW(5 downto 2),
-- Outputs --
Green_led => LEDG(1), 
red_led => visitante, 
done_senha => dn_senha);

LEDR(0) <= visitante;

u3 : COBRAR_VHDL
PORT MAP(
-- Inputs -- 
add1 => SW(6), 
add2 => SW(7), 
clk => SW(0), 
raise_price => visitante, 
reset => rs_price, 
enable => en_price,
-- Output --
opening => comparacao);


END TypeArchitecture;
