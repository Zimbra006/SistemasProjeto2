LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY controlador_vhdl IS
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
END controlador_vhdl;

ARCHITECTURE TypeArchitecture OF controlador_vhdl IS
TYPE states IS (idle, boot, senha, cobrar, abrir);
SIGNAL current_state : states := idle;
BEGIN

PROCESS (CLK)
BEGIN
	IF (rising_edge(CLK)) THEN
		CASE current_state IS
			WHEN idle =>
			-- O controlador espera ter um carro na frente da cancela
			-- para dar start no circuito
				IF (FRONT_SENSOR = '1') THEN
					current_state <= boot;
				ELSE
					current_state <= idle;
				END IF;
			WHEN boot =>
				current_state <= senha;
			WHEN senha =>
			-- Então ele aguarda a conlusão do módulo da senha
				IF (DONE_SENHA = '1') THEN
					current_state <= cobrar;
				ELSE
					current_state <= senha;
				END IF;
			WHEN cobrar =>
			-- E por fim a conclusão do módulo responsável pela cobrança
				IF (comp = '1') THEN
					current_state <= abrir;
				ELSE
					current_state <= cobrar;
				END IF;
			WHEN abrir =>
			-- Então ele permanece no estado onde a cancela está levantada e
			-- fica nele até o sensor que detecta que o carro já passou sinalizar 1
			IF (BACK_SENSOR = '1') THEN
					current_state <= idle;
				ELSE
					current_state <= abrir;
				END IF;
			WHEN others =>
				current_state <= idle;
		END CASE;
	END IF;
END PROCESS;

PROCESS (CLK)
BEGIN
	IF (rising_edge(CLK)) THEN
		CASE current_state IS
			WHEN idle =>
			-- Reinicia todas as variáveis
				ABRINDO <= '0';
				RESET_SENHA <= '0';
				RESET_PRICE <= '0';
				--------------------
				ENABLE_SENHA <= '0';
				ENABLE_PRICE <= '0';
				--------------------
				LED_SENHA <= '0';
				LED_COBRAR <= '0';
			WHEN boot =>
			-- Reseta ambos os módulos
				RESET_SENHA <= '1';
				RESET_PRICE <= '1';
			WHEN senha =>
			-- Da um enable no componente da senha
				RESET_SENHA <= '0';
				ENABLE_SENHA <= '1';
				---------------------
			-- E sinaliza em qual etapa o sistema está
				LED_SENHA <= '1';
				LED_COBRAR <= '0';
			WHEN cobrar =>
			-- Faz o mesmo para o componente da combrança, enquanto desabilita o da senha
				RESET_PRICE <= '0';
				ENABLE_PRICE <= '1';
				ENABLE_SENHA <= '0';
				---------------------
			-- E sinaliza o estado atual
				LED_SENHA <= '0';
				LED_COBRAR <= '1';
			WHEN abrir =>
			-- Por fim, abre a cancela
				ABRINDO <= '1';
			WHEN others =>
				ABRINDO <= '0';
		END CASE;
	END IF;
END PROCESS;


END TypeArchitecture;
