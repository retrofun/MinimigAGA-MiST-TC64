
//// module ////
module chipset_tb(
  input  wire           clk_28,
  output wire           clk7_en,
  output wire           clk7n_en,
  input  wire           reset_n,
  output wire           cpu_reset,
  input  wire [23:0]    cpu_address,
  output wire [15:0]    cpu_data,
  output wire [15:0]    cpu_data2,
  input  wire [15:0]    cpu_data_in,
  input  wire           cpu_as,
  input  wire           cpu_uds,
  input  wire           cpu_uds2,
  input  wire           cpu_lds,
  input  wire           cpu_lds2,
  input  wire           cpu_r_w,
  output wire           cpu_dtack,
  output wire [15:0]    ram_data,
  input  wire [15:0]    ram_data_in,
  output wire [22:0]    ram_address,
  output wire [7:0]     red,
  output wire [7:0]     green,
  output wire [7:0]     blue,
  output wire           hsync,
  output wire           vsync,
  
  input wire            spi_clk,
  input wire [2:0]      spi_cs,
  input wire            spi_mosi,
  output wire           spi_miso
);

/* verilator lint_off PINMISSING */

wire hsync_i,vsync_i,csync_i;
wire hsyncpol,vsyncpol,selcsync;

assign hsync = hsync_i ^ hsyncpol;
assign vsync = vsync_i ^ vsyncpol;
assign selcsync=1'b0;

wire clk7_en_i,clk7n_en_i,c1,c3,cck;
wire [9:0] eclk;

amiga_clk clocks (
  .reset_n(reset_n),
  .clk_28(clk_28),
  .clk7_en(clk7_en_i),
  .clk7n_en(clk7n_en_i),
  .c1(c1),
  .c3(c3),
  .cck(cck),
  .eclk(eclk)
);

assign clk7_en = clk7_en_i;
assign clk7n_en = clk7n_en_i;

minimig mm
(
	.cpu_address(cpu_address[23:1]),
	.cpu_data(cpu_data),
	.cpu_data2(cpu_data2),
	.cpudata_in(cpu_data_in),
	._cpu_ipl(),
	.fast_rd(1'b0),
	.fast_rd_ena(),
	._cpu_as(cpu_as),
	._cpu_uds(cpu_uds),
	._cpu_lds(cpu_lds),
	._cpu_uds2(cpu_uds2),
	._cpu_lds2(cpu_lds2),
	.cpu_r_w(cpu_r_w),
	._cpu_dtack(cpu_dtack),
	._cpu_reset(cpu_reset),
	._cpu_reset_in(reset_n),
	.cpu_vbr(32'h0),
	.ovr(),
	.ram_data(ram_data),
	.ramdata_in(ram_data_in),
	.ram_address(ram_address[22:1]),
/*	
	output	_ram_bhe,			//sram upper byte select
	output	_ram_ble,			//sram lower byte select
	output	_ram_bhe2,		//sram upper byte select 2nd word
	output	_ram_ble2,		//sram lower byte select 2nd word
	output	_ram_we,			//sram write enable
	output	_ram_oe,			//sram output enable
  input [48-1:0] chip48,         // big chipram read
	//system	pins
*/
	.rst_ext(~reset_n),      // reset from ctrl block
  	.rst_out(),     // minimig reset status
	.clk(clk_28),				// 28.37516 MHz clock
  	.clk7_en(clk7_en_i),      // 7MHz clock enable
	.clk7n_en(clk7n_en_i), // 7MHz negedge clock enable
	.c1(c1),			// clock enable signal
	.c3(c3),			// clock enable signal
	.cck(cck),			// colour clock enable
	.eclk(eclk),			// ECLK enable (1/10th of CLK)
	
	.kbd_reset_n(1'b1),
/*
	//rs232 pins
	input   midi_rx,
	output  midi_tx,
	input	rxd,				//rs232 receive
	output	txd,				//rs232 send
	input	cts,				//rs232 clear to send
	output	rts,				//rs232 request to send
	//I/O
	input	[15:0]_joy1,		//joystick 1 [fire7:fire,up,down,left,right] (default mouse port)
	input	[15:0]_joy2,		//joystick 2 [fire7:fire,up,down,left,right] (default joystick port)
	input	[15:0]_joy3,		//joystick 3 [fire7:fire,up,down,left,right]
	input	[15:0]_joy4,		//joystick 4 [fire7:fire,up,down,left,right]
	input	[15:0] joy_ana,
  input [2:0] mouse0_btn, // mouse buttons
  input [2:0] mouse1_btn, // mouse buttons
  input mouse_idx,       // mouse buttons
  input kbd_reset_n,
  input kbd_mouse_strobe,
  input kms_level,
  input [1:0] kbd_mouse_type,
  input [7:0] kbd_mouse_data,
	input	_15khz,				//scandoubler disable
	input [63:0] rtc,
	output pwr_led,				//power led
	output disk_led,				//fdd led
	input		msdat_i,				//PS2 mouse data
	input		msclk_i,				//PS2 mouse clk
	input		kbddat_i,				//PS2 keyboard data
	input		kbdclk_i,				//PS2 keyboard clk
   output	msdat_o,				//PS2 mouse data
	output	msclk_o,				//PS2 mouse clk
	output	kbddat_o,				//PS2 keyboard data
	output	kbdclk_o,				//PS2 keyboard clk
	//host controller interface (SPI)
	input	[2:0]_scs,			//SPI chip select
	input	direct_sdi,			//SD Card direct in
	input	sdi,				//SPI data input
	inout	sdo,				//SPI data output
	input	sck,				//SPI clock

	input qcs,            //QSPI cs
	input qsck,           //QSPI clock
	input [3:0] qdat,     //QSPI data input
	//video
*/
	._scs(spi_cs),
	.sdi(spi_mosi),
	.sdo(spi_miso),
	.sck(spi_clk),

	._hsync(hsync_i),				//horizontal sync
	.hsyncpol(hsyncpol),
	._vsync(vsync_i),				//vertical sync
	.vsyncpol(vsyncpol),
	._csync(csync_i),				//composite sync (for _15khz mode)
	.selcsync(selcsync),
	.red(red),			//red
	.green(green),		//green
	.blue(blue)			//blue
/*
	//audio
	output	[23:0]ldata,			//left DAC data
	output	[23:0]rdata, 			//right DAC data
    input   [15:0]aux_left_1,		// Auxiliary audio channels
    input   [15:0]aux_right_1,		// Auxiliary audio channels
    input   [15:0]aux_left_2,		// Auxiliary audio channels
    input   [15:0]aux_right_2,		// Auxiliary audio channels
	//user i/o
  output  [3:0] cpu_config,
  output  [5:0] board_configured,
  output  turbochipram,
  output  turbokick,
  output  [1:0] slow_config,
  output  aga,
  output  init_b,       // vertical sync for MCU (sync OSD update)
  output wire fifo_full,
  // fifo / track display
	output  [7:0]trackdisp,
	output  [13:0]secdisp,
  output  floppy_fwr,
  output  floppy_frd,
  output  hd_fwr,
  output  hd_frd,
  output  hblank_out,
  output  vblank_out,
  output  blank_out,
  output  osd_blank_out,	// Let the toplevel dither module handle drawing the OSD.
  output  osd_pixel_out,
  output  rtg_ena,
  output  rtg_linecompare,
  output reg ntsc = NTSC, //PAL/NTSC video mode selection
  input   ext_int2,	// External interrupt for Akiko
  input   ext_int6,	// External interrupt for AHI audio
  input [1:0] ram_64meg,
  output  insert_sound,
  output  eject_sound,
  output  motor_sound,
  output  step_sound,
  output  hdd_sound
  */
);

/* verilator lint_on PINMISSING */

endmodule

