
//// module ////
module chipset_tb(
  input  wire           clk_28,
  input  wire           reset,
  input  wire           clk7en_rd,
  input  wire           clk7en_wr,
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
  input  wire           cpu_reset_in,
  output wire [15:0]    ram_data,
  input  wire [15:0]    ram_data_in,
  output wire [22:0]    ram_address,
  output wire           hsync,
  output wire           vsync,
  output wire           blank
);

/* verilator lint_off PINMISSING */

wire hsync_i;
wire vsync_i;
wire blank_i;

reg [2:0] cck_ctr;

always @(posedge clk_28)
	cck_ctr<=cck_ctr+1;
	
wire clk7_en=&cck_ctr[1:0];
wire cck=cck_ctr[2];
wire [8:0] htotal;

agnus_beamcounter beamcounter
(
	.clk(clk_28),					// bus clock
	.clk7_en(clk7_en),
	.reset(~reset),					// reset
	.rd(1'b0),	// Import read signal so we can guard against phantom writes to RTG
	.cck(cck),					// CCK clock
	.ntsc(1'b0),					// NTSC mode switch
	.aga(1'b0),
	.ecs(1'b1),					// ECS enable switch
	.a1k(1'b0),					// enable A1000 VBL interrupt timing
	.data_in(cpu_data_in),			// bus data in
	.data_out(cpu_data),	// bus data out
	.reg_address_in(cpu_address[8:1]),	// register address inputs
	.hpos(),			// horizontal beam counter (140ns)
	.vpos(),		// vertical beam counter
	._hsync(hsync_i),				// horizontal sync
	.hsyncpol(),			// horizontal sync polarity
	._vsync(vsync_i),				// vertical sync
	.vsyncpol(),			// vertical sync polarity
	._csync(),					// composite sync
	.blank(blank_i),				// video blanking
	.vbl(),					// vertical blanking
	.vblend(),					// last line of vertical blanking
	.eol(),					// end of video line
	.eof(),					// end of video frame
	.vbl_int(),			// vertical interrupt request (for Paula)
	.htotal_out(htotal),			// video line length
	.harddis_out(),
	.varbeamen_out(),
	.rtg_ena(),
	.rtg_linecompare(),
	.hblank_out()
);

amber scandoubler
(
	.clk(clk_28),            // 28MHz clock
  // config
	.dblscan(1'b1),        // enable VGA output (enable scandoubler)
	.varbeamen(1'b0),      // variable beam enabled
	.lr_filter(2'b00),      // interpolation filter settings for low resolution
	.hr_filter(2'b00),      // interpolation filter settings for high resolution
	.scanline(2'b00),       // scanline effect enable
	.dither(2'b00),         // dither enable (00 = off, 01 = temporal, 10 = random, 11 = temporal + random)
	// control
	.htotal(htotal),         // video line length
	.hires(1'b1),          // display is in hires mode (from bplcon0)
	// osd
	.osd_blank(1'b0),      // OSD overlay enable (blank normal video)
	.osd_pixel(1'b0),      // OSD pixel(video) data
	// input
	.red_in(8'h00),         // red componenent video in
	.green_in(8'h00),       // green component video in
	.blue_in(8'h00),        // blue component video in
	._csync_in(1'b0),      // composite sync in
	._hsync_in(hsync_i),      // horizontal synchronisation in
	._vsync_in(vsync_i),      // vertical synchronisation in
	.blank_in(blank_i),
	// output
	.red_out(),      // red componenent video out
	.green_out(),    // green component video out
	.blue_out(),     // blue component video out
	._hsync_out(hsync),   // horizontal synchronisation out
	._vsync_out(vsync),   // vertical synchronisation out
	._csync_out(),
	.blank_out(blank),
	.selcsync(),
	.osd_blank_out(),
	.osd_pixel_out()
);



/* verilator lint_on PINMISSING */

endmodule

