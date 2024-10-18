library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- -----------------------------------------------------------------------
entity neptuno_top is
	port
	(
		CLOCK_50	:	 IN STD_LOGIC;
		LED         :   OUT STD_LOGIC;
		DRAM_CLK		:	 OUT STD_LOGIC;
		DRAM_CKE		:	 OUT STD_LOGIC;
		DRAM_ADDR		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_LDQM		:	 OUT STD_LOGIC;
		DRAM_UDQM		:	 OUT STD_LOGIC;
		DRAM_CS_N		:	 OUT STD_LOGIC;
		DRAM_WE_N		:	 OUT STD_LOGIC;
		DRAM_CAS_N		:	 OUT STD_LOGIC;
		DRAM_RAS_N		:	 OUT STD_LOGIC;
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		VGA_G		:	 OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		VGA_B		:	 OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		-- AUDIO
		SIGMA_R                     : OUT STD_LOGIC;
		SIGMA_L                     : OUT STD_LOGIC;
				-- I2S audio		
		I2S_BCLK				: out   std_logic								:= '0';
		I2S_LRCLK			: out   std_logic								:= '0';
		I2S_DATA				: out   std_logic								:= '0';		
      
		-- JOYSTICK 
		JOY_CLK				: out   std_logic;
		JOY_LOAD 			: out   std_logic;
		JOY_DATA 			: in    std_logic;
		
		-- PS2
		PS2_KEYBOARD_CLK            :    INOUT STD_LOGIC;
		PS2_KEYBOARD_DAT            :    INOUT STD_LOGIC;
		PS2_MOUSE_CLK               :    INOUT STD_LOGIC;
		PS2_MOUSE_DAT               :    INOUT STD_LOGIC;
		-- UART
		AUDIO_INPUT                 : IN STD_LOGIC;
		--STM32
      STM_RST           : out std_logic     := 'Z'; -- '0' to hold the microcontroller reset line, to free the SD card

		-- SD Card
		SD_CS                       : out   std_logic := '1';
		SD_SCK                      : out   std_logic := '0';
		SD_MOSI                     : out   std_logic := '0';
		SD_MISO                     : in    std_logic
	
	);
END entity;


architecture RTL of neptuno_top is
   constant reset_cycles : integer := 131071;
	
-- System clocks

	signal sysclk : std_logic;

--	signal slowclk : std_logic;
--	signal fastclk : std_logic;
--	signal pll_locked : std_logic;

-- SPI signals

	signal diskled :std_logic;
	signal floppyled : std_logic;
	signal powerled : unsigned(1 downto 0);


	

-- PS/2 Keyboard socket - used for second mouse

	signal ps2_keyboard_clk_in : std_logic;
	signal ps2_keyboard_dat_in : std_logic;
	signal ps2_keyboard_clk_out : std_logic;
	signal ps2_keyboard_dat_out : std_logic;

-- PS/2 Mouse

	signal ps2_mouse_clk_in: std_logic;
	signal ps2_mouse_dat_in: std_logic;
	signal ps2_mouse_clk_out: std_logic;
	signal ps2_mouse_dat_out: std_logic;

	
-- Video
	signal vga_pixel : std_logic;
	signal vga_red: std_logic_vector(7 downto 0);
	signal vga_green: std_logic_vector(7 downto 0);
	signal vga_blue: std_logic_vector(7 downto 0);
	signal vga_window : std_logic;
	signal vga_selcsync : std_logic;
	signal vga_csync : std_logic;
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	signal vbl : std_logic;
	signal osd_window : std_logic;
	signal osd_pixel : std_logic;
	
	signal VGA_HS_i : STD_LOGIC;
	signal VGA_VS_i : STD_LOGIC;
	signal VGA_R_i : UNSIGNED(5 DOWNTO 0);
	signal VGA_G_i : UNSIGNED(5 DOWNTO 0);
	signal VGA_B_i : UNSIGNED(5 DOWNTO 0);
	
-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;


	signal audio_l : std_logic_vector(15 downto 0);
	signal audio_r : std_logic_vector(15 downto 0);
	
-- IO

	signal joya : std_logic_vector(6 downto 0);
	signal joyb : std_logic_vector(6 downto 0);
	signal joyc : std_logic_vector(6 downto 0);
	signal joyd : std_logic_vector(6 downto 0);

-- LED
	signal TMPLED : std_logic;
	
	COMPONENT minimig_virtual_top
	generic
	( debug : boolean := false;
		havertg : boolean := true;
		haveaudio : boolean := true;
		havec2p : boolean := true;
		ram_64meg : boolean := false;
		haveiec : boolean := false;
		havereconfig : boolean := false;
		vga_width : integer := 6
	);
	PORT
	(
		CLK_IN		:	 IN STD_LOGIC;
		CLK_28		:	 OUT STD_LOGIC;
		CLK_114		:	 OUT STD_LOGIC;
		RESET_N     :   IN STD_LOGIC;
		LED_POWER	:	 OUT STD_LOGIC;
		LED_DISK    :   OUT STD_LOGIC;
		MENU_BUTTON :   IN STD_LOGIC;
		CTRL_TX		:	 OUT STD_LOGIC;
		CTRL_RX		:	 IN STD_LOGIC;
		AMIGA_TX		:	 OUT STD_LOGIC;
		AMIGA_RX		:	 IN STD_LOGIC;
		VGA_HS		:	 OUT STD_LOGIC;
		VGA_VS		:	 OUT STD_LOGIC;
		VGA_R		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_G		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		VGA_B		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		SDRAM_DQ		:	 INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SDRAM_A		:	 OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		SDRAM_DQML		:	 OUT STD_LOGIC;
		SDRAM_DQMH		:	 OUT STD_LOGIC;
		SDRAM_nWE		:	 OUT STD_LOGIC;
		SDRAM_nCAS		:	 OUT STD_LOGIC;
		SDRAM_nRAS		:	 OUT STD_LOGIC;
		SDRAM_nCS		:	 OUT STD_LOGIC;
		SDRAM_BA		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		SDRAM_CLK		:	 OUT STD_LOGIC;
		SDRAM_CKE		:	 OUT STD_LOGIC;
		AUDIO_L		:	 OUT STD_LOGIC_VECTOR(15 downto 0);
		AUDIO_R		:	 OUT STD_LOGIC_VECTOR(15 downto 0);
		PS2_DAT_I		:	 INOUT STD_LOGIC;
		PS2_CLK_I		:	 INOUT STD_LOGIC;
		PS2_MDAT_I	:	 INOUT STD_LOGIC;
		PS2_MCLK_I		:	 INOUT STD_LOGIC;
		PS2_DAT_O		:	 INOUT STD_LOGIC;
		PS2_CLK_O		:	 INOUT STD_LOGIC;
		PS2_MDAT_O		:	 INOUT STD_LOGIC;
		PS2_MCLK_O		:	 INOUT STD_LOGIC;
		AMIGA_RESET_N : IN STD_LOGIC;
		AMIGA_KEY	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		AMIGA_KEY_STB : IN STD_LOGIC;
		C64_KEYS	:	IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		JOYA		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		JOYB		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		JOYC		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		JOYD		:	 IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		SD_MISO	:	 IN STD_LOGIC;
		SD_MOSI	:	 OUT STD_LOGIC;
		SD_CLK	:	 OUT STD_LOGIC;
		SD_CS		:	 OUT STD_LOGIC;
		SD_ACK	:	 IN STD_LOGIC;
		RECONFIG	:	 OUT STD_LOGIC;
		IECSERIAL:	 OUT STD_LOGIC			
	);
	END COMPONENT;

signal amiga_rxd : std_logic;
signal amiga_txd : std_logic;

signal iecserial : std_logic;
signal reconfig : std_logic;


component joydecoder is
Port ( 	
		clk 			: in std_logic; 
		joy_data    : in std_logic;
		joy_clk		: out std_logic;
		joy_load_n	: out std_logic;
		joy1up		: out std_logic;
		joy1down		: out std_logic;
		joy1left		: out std_logic;
		joy1right	: out std_logic;
		joy1fire1	: out std_logic;
		joy1fire2	: out std_logic;
		joy2up		: out std_logic;
		joy2down		: out std_logic;
		joy2left		: out std_logic;
		joy2right	: out std_logic;
		joy2fire1	: out std_logic;
		joy2fire2	: out std_logic
);
end component;

-- JOYSTICKS
	signal joy1up			: std_logic								:= '1';
	signal joy1down		: std_logic								:= '1';
	signal joy1left		: std_logic								:= '1';
	signal joy1right		: std_logic								:= '1';
	signal joy1fire1		: std_logic								:= '1';
	signal joy1fire2		: std_logic								:= '1';
	signal joy2up			: std_logic								:= '1';
	signal joy2down		: std_logic								:= '1';
	signal joy2left		: std_logic								:= '1';
	signal joy2right		: std_logic								:= '1';
	signal joy2fire1		: std_logic								:= '1';
	signal joy2fire2		: std_logic								:= '1';
	signal clk_sys_out   : std_logic;
	-- i2s 
	signal i2s_mclk		    : std_logic;
	
begin

-- SPI


vga_window<='1';

ps2_mouse_dat_in<=ps2_mouse_dat;
ps2_mouse_dat <= '0' when ps2_mouse_dat_out='0' else 'Z';
ps2_mouse_clk_in<=ps2_mouse_clk;
ps2_mouse_clk <= '0' when ps2_mouse_clk_out='0' else 'Z';

ps2_keyboard_dat_in <=ps2_keyboard_dat;
ps2_keyboard_dat <= '0' when ps2_keyboard_dat_out='0' else 'Z';
ps2_keyboard_clk_in<=ps2_keyboard_clk;
ps2_keyboard_clk <= '0' when ps2_keyboard_clk_out='0' else 'Z';


virtual_top : COMPONENT minimig_virtual_top
generic map
	(
		debug => false,
		havertg => true,
		haveaudio => true,
		havec2p => true,
		ram_64meg => false,
		haveiec => false,
		havereconfig => false,
		vga_width => 6
	)
PORT map
	(
		CLK_IN => CLOCK_50,
		CLK_114 => sysclk,
		RESET_N => '1',
		LED_POWER => open,
		LED_DISK => TMPLED,
		MENU_BUTTON => '1',
		CTRL_TX => open,
		CTRL_RX => '1',
		AMIGA_TX => amiga_txd,
		AMIGA_RX => amiga_rxd,
		VGA_HS => VGA_HS,
		VGA_VS => VGA_VS,
		VGA_R	=> VGA_R,
		VGA_G	=> VGA_G,
		VGA_B	=> VGA_B,
	
		SDRAM_DQ	=> DRAM_DQ,
		SDRAM_A => DRAM_ADDR,
		SDRAM_DQML => DRAM_LDQM,
		SDRAM_DQMH => DRAM_UDQM,
		SDRAM_nWE => DRAM_WE_N,
		SDRAM_nCAS => DRAM_CAS_N,
		SDRAM_nRAS => DRAM_RAS_N,
--		SDRAM_nCS => DRAM_CS_N,
		SDRAM_BA => DRAM_BA,
		SDRAM_CLK => DRAM_CLK,
--		SDRAM_CKE => DRAM_CKE,

		AUDIO_L => audio_l,
		AUDIO_R => audio_r,
		
		PS2_DAT_I => ps2_keyboard_dat_in,
		PS2_CLK_I => ps2_keyboard_clk_in,
		PS2_MDAT_I => ps2_mouse_dat_in,
		PS2_MCLK_I => ps2_mouse_clk_in,

		PS2_DAT_O => ps2_keyboard_dat_out,
		PS2_CLK_O => ps2_keyboard_clk_out,
		PS2_MDAT_O => ps2_mouse_dat_out,
		PS2_MCLK_O => ps2_mouse_clk_out,
		
		AMIGA_RESET_N => '1',
		AMIGA_KEY => (others=>'-'),
		AMIGA_KEY_STB => '0',
		C64_KEYS => X"FEDCBA9876543210",
		
		JOYA => joya,
		JOYB => joyb,
		JOYC => joyc,
		JOYD => joyd,
		
		SD_MISO => sd_miso,
		SD_MOSI => sd_mosi,
		SD_CLK => sd_sck,
		SD_CS => sd_cs,
		SD_ACK => '1',
		RECONFIG => reconfig,
		IECSERIAL => iecserial
	);

DRAM_CS_N <= '0';
DRAM_CKE  <= '1'; 
STM_RST <= '0';
	
joya<="1" & joy1fire2 & joy1fire1 & joy1up & joy1down & joy1left & joy1right;
joyb<="1" & joy2fire2 & joy2fire1 & joy2up & joy2down & joy2left & joy2right;		

joyc<=(others=>'1');
joyd<=(others=>'1');

joy: joydecoder
	  port map (
		clk				=> CLOCK_50,
		joy_clk			=> JOY_CLK,
		joy_load_n 		=> JOY_LOAD,
		joy_data			=> JOY_DATA,		
		joy1up  			=> joy1up,
		joy1down			=> joy1down,
		joy1left			=> joy1left,
		joy1right		=> joy1right,
		joy1fire1		=> joy1fire1,
		joy1fire2		=> joy1fire2,
		joy2up  			=> joy2up,
		joy2down			=> joy2down,
		joy2left			=> joy2left,
		joy2right		=> joy2right,
		joy2fire1		=> joy2fire1,
		joy2fire2		=> joy2fire2
	);


LED <= VGA_HS_i;

---- I2S out


audio_i2s: entity work.audio_top
port map(
	clk_50MHz => clock_50,
	dac_MCLK  => I2S_MCLK,
	dac_LRCK  => I2S_LRCLK,
	dac_SCLK  => I2S_BCLK,
	dac_SDIN  => I2S_DATA,
	L_data    => signed(AUDIO_L),
	R_data    => signed(AUDIO_R)
);

dac_l: entity work.dac_dsm2v  
generic map
	(
	  nbits_g => 16
	)
port map
(	
   clock_i  => sysclk,
   reset_i  => '0',
   dac_i    => signed(AUDIO_L),
   dac_o    => SIGMA_L
);

dac_r: entity work.dac_dsm2v  
generic map
	(
	  nbits_g => 16
	)
port map
(	
   clock_i  => sysclk,
   reset_i  => '0',
   dac_i    => signed(AUDIO_R),
   dac_o    => SIGMA_R
);

end rtl;

