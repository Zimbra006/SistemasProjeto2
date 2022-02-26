library ieee;
use ieee.std_logic_1164.all;

entity tb_main_vhdl is
end tb_main_vhdl;

architecture tb of tb_main_vhdl is

    component main_vhdl
        port (CLK_MAIN         : in std_logic;
              IS_GUEST         : in std_logic;
              PASSWORD_MAIN    : in std_logic_vector (3 downto 0);
              ADD_1_MAIN       : in std_logic;
              ADD_2_MAIN       : in std_logic;
              FT_SENSOR        : in std_logic;
              BK_SENSOR        : in std_logic;
              LED_ETAPA_SENHA  : out std_logic;
              LED_ETAPA_COBRAR : out std_logic;
              LED_SENHA_ACEITA : out std_logic;
              LED_SENHA_NEGADA : out std_logic;
              ABERTO           : out std_logic);
    end component;

    signal CLK_MAIN         : std_logic;
    signal IS_GUEST         : std_logic;
    signal PASSWORD_MAIN    : std_logic_vector (3 downto 0);
    signal ADD_1_MAIN       : std_logic;
    signal ADD_2_MAIN       : std_logic;
    signal FT_SENSOR        : std_logic;
    signal BK_SENSOR        : std_logic;
    signal LED_ETAPA_SENHA  : std_logic;
    signal LED_ETAPA_COBRAR : std_logic;
    signal LED_SENHA_ACEITA : std_logic;
    signal LED_SENHA_NEGADA : std_logic;
    signal ABERTO           : std_logic;

    constant TbPeriod       : time := 1000 ns; 
    signal TbClock          : std_logic := '0';
    signal TbSimEnded       : std_logic := '0';

begin

    dut : main_vhdl
    port map (CLK_MAIN         => CLK_MAIN,
              IS_GUEST         => IS_GUEST,
              PASSWORD_MAIN    => PASSWORD_MAIN,
              ADD_1_MAIN       => ADD_1_MAIN,
              ADD_2_MAIN       => ADD_2_MAIN,
              FT_SENSOR        => FT_SENSOR,
              BK_SENSOR        => BK_SENSOR,
              LED_ETAPA_SENHA  => LED_ETAPA_SENHA,
              LED_ETAPA_COBRAR => LED_ETAPA_COBRAR,
              LED_SENHA_ACEITA => LED_SENHA_ACEITA,
              LED_SENHA_NEGADA => LED_SENHA_NEGADA,
              ABERTO           => ABERTO);

    
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';


    CLK_MAIN <= TbClock;

    stimuli : process
    begin

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '0';
        FT_SENSOR <= '0';
        BK_SENSOR <= '0';


        wait for 100 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '0';
        FT_SENSOR <= '1';
        BK_SENSOR <= '0';

        wait for 100 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= 0110 (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '0';
        FT_SENSOR <= '0';
        BK_SENSOR <= '0';

        wait for 400 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '1';
        FT_SENSOR <= '0';
        BK_SENSOR <= '0';

        wait for 100 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '1';
        FT_SENSOR <= '0';
        BK_SENSOR <= '0';

        wait for 100 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '1';
        ADD_2_MAIN <= '0';
        FT_SENSOR <= '0';
        BK_SENSOR <= '0';

        wait for 200 * TbPeriod;

        IS_GUEST <= '0';
        PASSWORD_MAIN <= (others => '0');
        ADD_1_MAIN <= '0';
        ADD_2_MAIN <= '0';
        FT_SENSOR <= '0';
        BK_SENSOR <= '1';

  
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
