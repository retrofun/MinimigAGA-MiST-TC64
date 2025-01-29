library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.minimig_virtual_pkg.all;

-- -----------------------------------------------------------------------

entity uareloaded_top is
	port
	(
		CLOCK_50		:	 IN STD_LOGIC;
		LED		   :	 OUT STD_LOGIC;
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
		
		VGA_HS          :        OUT STD_LOGIC;
		VGA_VS          :        OUT STD_LOGIC;
		VGA_R           :        OUT UNSIGNED(7 DOWNTO 0);
		VGA_G           :        OUT UNSIGNED(7 DOWNTO 0);
		VGA_B           :        OUT UNSIGNED(7 DOWNTO 0);
		VGA_BLANK:   OUT STD_LOGIC;
		VGA_CLOCK:   OUT STD_LOGIC;
		-- PS2
		PS2_KEYBOARD_CLK            :    IN STD_LOGIC;
		PS2_KEYBOARD_DAT            :    IN STD_LOGIC;
		PS2_MOUSE_CLK               :    INOUT STD_LOGIC;
		PS2_MOUSE_DAT               :    INOUT STD_LOGIC;
		 -- UART
		AUDIO_IN                    : IN STD_LOGIC;
-- STM
		STM_RST                     : out std_logic     := 'Z';
-- I2S
		SCLK                        : out std_logic;
		SDIN                        : out std_logic;
		MCLK                        : out std_logic := 'Z';
		LRCLK                       : out std_logic;

-- Joystick
      JOYSTICK1                   : in std_logic_vector (5 downto 0);
		JOYSTICK2                   : in std_logic_vector (5 downto 0);
		JOY_SELECT                  : out std_logic :='1';
-- SD Card
		SD_CS                       : out   std_logic := '1';
		SD_SCK                      : out   std_logic := '0';
		SD_MOSI                     : out   std_logic := '0';
		SD_MISO                     : in    std_logic;

		I2C_SCL							 : OUT STD_LOGIC;
		I2C_SDA		                : INOUT STD_LOGIC;
		ESP_RX                      : IN STD_LOGIC;
      ESP_TX                      : OUT STD_LOGIC := '1'

		);
END entity;

architecture RTL of uareloaded_top is
   constant reset_cycles : integer := 131071;
	
-- System clocks

	signal sysclk : std_logic;


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
--	signal vga_pixel : std_logic;
	signal vga_red: std_logic_vector(7 downto 0);
	signal vga_green: std_logic_vector(7 downto 0);
	signal vga_blue: std_logic_vector(7 downto 0);
	signal vga_window : std_logic;
--	signal vga_selcsync : std_logic;
--	signal vga_csync : std_logic;
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	signal vbl : std_logic;
	signal osd_window : std_logic;
	signal osd_pixel : std_logic;
	

	signal red_dithered :unsigned(7 downto 0);
	signal grn_dithered :unsigned(7 downto 0);
	signal blu_dithered :unsigned(7 downto 0);
	signal hsync_n_dithered : std_logic;
	signal vsync_n_dithered : std_logic;
	
	
	signal VGA_HS_i : STD_LOGIC;
	signal VGA_VS_i : STD_LOGIC;
	signal VGA_R_i : UNSIGNED(7 DOWNTO 0);
	signal VGA_G_i : UNSIGNED(7 DOWNTO 0);
	signal VGA_B_i : UNSIGNED(7 DOWNTO 0);
	
-- RS232 serial
	signal rs232_rxd : std_logic;
	signal rs232_txd : std_logic;


	signal audio_l : std_logic_vector(23 downto 0);
	signal audio_r : std_logic_vector(23 downto 0);
	
-- IO

	signal joya : std_logic_vector(6 downto 0);
	signal joyb : std_logic_vector(6 downto 0);
	signal joyc : std_logic_vector(6 downto 0);
	signal joyd : std_logic_vector(6 downto 0);

signal amiga_rxd : std_logic;
signal amiga_txd : std_logic;

signal iecserial : std_logic;
signal reconfig : std_logic;

begin


-- SPI



vga_window<='1';

ps2_mouse_dat_in<=ps2_mouse_dat;
ps2_mouse_dat <= '0' when ps2_mouse_dat_out='0' else 'Z';
ps2_mouse_clk_in<=ps2_mouse_clk;
ps2_mouse_clk <= '0' when ps2_mouse_clk_out='0' else 'Z';

ps2_keyboard_dat_in <=ps2_keyboard_dat;
ps2_keyboard_clk_in<=ps2_keyboard_clk;


virtual_top : COMPONENT minimig_virtual_top
generic map
	(
		debug => 0,
		havertg => 1,
		haveaudio => 1,
		havec2p => 1,
		havecart => 1,
		ram_64meg => 0,
		haveiec => 0,
		havereconfig => 0,
		vga_width => 8
	)
PORT map
	(
		CLK_IN => CLOCK_50,
		CLK_114 => sysclk,
		RESET_N => '1',
		LED_POWER => open,
		LED_DISK => LED,
		MENU_BUTTON => '1',
		CTRL_TX => rs232_txd,
		CTRL_RX => rs232_rxd,
		AMIGA_TX => ESP_TX,
		AMIGA_RX => ESP_RX,
--		VGA_PIXEL => vga_pixel,
--		VGA_SELCS => vga_selcsync,
--		VGA_CS => vga_csync,
		VGA_HS => vga_hsync,
		VGA_VS => vga_vsync,
		VGA_R	=> vga_red,
		VGA_G	=> vga_green,
		VGA_B	=> vga_blue,
	
		SDRAM_DQ	=> DRAM_DQ,
		SDRAM_A => DRAM_ADDR,
		SDRAM_DQML => DRAM_LDQM,
		SDRAM_DQMH => DRAM_UDQM,
		SDRAM_nWE => DRAM_WE_N,
		SDRAM_nCAS => DRAM_CAS_N,
		SDRAM_nRAS => DRAM_RAS_N,
		SDRAM_nCS => DRAM_CS_N,
		SDRAM_BA => DRAM_BA,
		SDRAM_CLK => DRAM_CLK,
		SDRAM_CKE => DRAM_CKE,

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

		
joya<='1' & JOYSTICK2(5) & JOYSTICK2(4) & JOYSTICK2(3) & JOYSTICK2(2) & JOYSTICK2(1) &JOYSTICK2(0);
joyb<='1' & JOYSTICK1(5) & JOYSTICK1(4) & JOYSTICK1(3) & JOYSTICK1(2) & JOYSTICK1(1) &JOYSTICK1(0);
joyc<=(others=>'1');
joyd<=(others=>'1');

STM_RST <= '0';

--	mydither : entity work.video_vga_dither
--	generic map(
--		outbits => 5
--	)
--	port map(
--		clk=>sysclk,
--		pixel=>vga_pixel,
----			invertSync=>'1',
--		iSelcsync=>vga_selcsync,
--		iCsync=>vga_csync,
--		iHsync=>vga_hsync,
--		iVsync=>vga_vsync,
--		vidEna=>vga_window,
--		iRed => unsigned(vga_red),
--		iGreen => unsigned(vga_green),
--		iBlue => unsigned(vga_blue),
--		oHsync=>hsync_n_dithered,
--		oVsync=>vsync_n_dithered,
--		oRed(7 downto 0) => red_dithered,
--		oGreen(7 downto 0) => grn_dithered,
--		oBlue(7 downto 0) => blu_dithered
--	);
--	
--process(sysclk)
--begin
--	if rising_edge(sysclk) then
--		VGA_R<=red_dithered;
--		VGA_G<=grn_dithered;
--		VGA_B<=blu_dithered;
--		VGA_HS<=not hsync_n_dithered;
--		VGA_VS<=not vsync_n_dithered;
--	end if;
--end process;

process(sysclk)
begin
	if rising_edge(sysclk) then
		VGA_R<=unsigned(vga_red);
		VGA_G<=unsigned(vga_green);
		VGA_B<=unsigned(vga_blue);
		VGA_HS<=vga_hsync;
		VGA_VS<=vga_vsync;
	end if;
end process;
VGA_CLOCK<=sysclk;
VGA_BLANK<='1';
---- I2S out

i2s : entity work.audio_top
port map(
     clk_50MHz => clock_50,
          dac_MCLK  => MCLK,
          dac_SCLK  => SCLK,
          dac_SDIN  => SDIN,
          dac_LRCK  => LRCLK,
          L_data    => signed(AUDIO_L(23 downto 8)),
          R_data    => signed(AUDIO_R(23 downto 8))
);


end rtl;

