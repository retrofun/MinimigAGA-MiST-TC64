module AudioMix
  (input  clk,
   input  reset_n,
   input  swap_channels,
   input  [15:0] audio_in_l1,
   input  [15:0] audio_in_r1,
   input  [7:0] audio_vol1,
   input  [15:0] audio_in_l2,
   input  [15:0] audio_in_r2,
   input  [7:0] audio_vol2,
   input  [15:0] audio_in_r3,
   input  [15:0] audio_in_l3,
   input  [7:0] audio_vol3,
   input  [15:0] audio_in_l4,
   input  [15:0] audio_in_r4,
   input  [7:0] audio_vol4,
   input  [15:0] audio_in_l5,
   input  [15:0] audio_in_r5,
   input  [7:0] audio_vol5,
   output [23:0] audio_l,
   output [23:0] audio_r,
   output audio_overflow);
  reg [3:0] inmux_sel;
  wire [16:0] inmux;
  wire [9:0] volmux;
  wire [26:0] scaled_in;
  wire [26:0] accumulator;
  wire [3:0] headroom;
  wire overflow;
  wire [23:0] clipped;
  wire [23:0] clamped;
  wire [3:0] n8_o;
  wire n12_o;
  wire n14_o;
  wire n16_o;
  wire n18_o;
  wire n20_o;
  wire n22_o;
  wire n24_o;
  wire n26_o;
  wire n28_o;
  wire [8:0] n29_o;
  reg [15:0] n30_o;
  wire n31_o;
  wire [2:0] n32_o;
  wire n34_o;
  wire n36_o;
  wire n38_o;
  wire n40_o;
  wire [3:0] n41_o;
  reg [7:0] n42_o;
  wire [26:0] n48_o;
  wire [26:0] n49_o;
  wire [26:0] n50_o;
  wire [26:0] n51_o;
  wire [2:0] n52_o;
  wire n54_o;
  wire [26:0] n56_o;
  wire [3:0] n60_o;
  wire n63_o;
  wire n64_o;
  wire n67_o;
  wire n68_o;
  wire n70_o;
  wire n71_o;
  wire n72_o;
  wire n73_o;
  wire n74_o;
  wire n75_o;
  wire n76_o;
  wire n77_o;
  wire n78_o;
  wire n79_o;
  wire n80_o;
  wire n81_o;
  wire n82_o;
  wire n83_o;
  wire n84_o;
  wire n85_o;
  wire n86_o;
  wire n87_o;
  wire n88_o;
  wire n89_o;
  wire n90_o;
  wire n91_o;
  wire n92_o;
  wire n93_o;
  wire n94_o;
  wire n95_o;
  wire n96_o;
  wire n97_o;
  wire n98_o;
  wire n99_o;
  wire n100_o;
  wire n101_o;
  wire n102_o;
  wire n103_o;
  wire n104_o;
  wire n105_o;
  wire n106_o;
  wire n107_o;
  wire n108_o;
  wire n109_o;
  wire n110_o;
  wire n111_o;
  wire n112_o;
  wire n113_o;
  wire n114_o;
  wire n115_o;
  wire n116_o;
  wire [3:0] n117_o;
  wire [3:0] n118_o;
  wire [3:0] n119_o;
  wire [3:0] n120_o;
  wire [3:0] n121_o;
  wire [2:0] n122_o;
  wire [15:0] n123_o;
  wire [6:0] n124_o;
  wire [22:0] n125_o;
  wire [23:0] n126_o;
  wire n127_o;
  wire [23:0] n128_o;
  wire n132_o;
  wire [3:0] n134_o;
  wire n135_o;
  wire [3:0] n138_o;
  wire n139_o;
  reg [3:0] n145_q;
  wire [16:0] n146_o;
  wire [9:0] n147_o;
  reg [26:0] n148_q;
  reg [26:0] n149_q;
  wire [23:0] n151_o;
  wire [23:0] n152_o;
  reg [23:0] n153_q;
  wire [23:0] n154_o;
  reg [23:0] n155_q;
  reg n156_q;
  assign audio_l = n153_q;
  assign audio_r = n155_q;
  assign audio_overflow = n156_q;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:128:37  */
  always @*
    inmux_sel = n145_q; // (isignal)
  initial
    inmux_sel = 4'b0000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:47:8  */
  assign inmux = n146_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:48:8  */
  assign volmux = n147_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:49:8  */
  assign scaled_in = n148_q; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:50:8  */
  assign accumulator = n149_q; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:51:8  */
  assign headroom = n60_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:54:8  */
  assign overflow = n64_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:129:49  */
  assign clipped = n128_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:56:8  */
  assign clamped = n151_o; // (signal)
  /* ../../rtl/minimig/../audio/AudioMix.vhd:61:45  */
  assign n8_o = inmux_sel + 4'b0001;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:67:29  */
  assign n12_o = inmux_sel == 4'b0000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:68:29  */
  assign n14_o = inmux_sel == 4'b0001;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:69:29  */
  assign n16_o = inmux_sel == 4'b0010;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:70:29  */
  assign n18_o = inmux_sel == 4'b0011;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:71:29  */
  assign n20_o = inmux_sel == 4'b0100;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:72:29  */
  assign n22_o = inmux_sel == 4'b1000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:73:29  */
  assign n24_o = inmux_sel == 4'b1001;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:74:29  */
  assign n26_o = inmux_sel == 4'b1010;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:75:29  */
  assign n28_o = inmux_sel == 4'b1011;
  assign n29_o = {n28_o, n26_o, n24_o, n22_o, n20_o, n18_o, n16_o, n14_o, n12_o};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:66:9  */
  always @*
    case (n29_o)
      9'b100000000: n30_o = audio_in_r4;
      9'b010000000: n30_o = audio_in_r3;
      9'b001000000: n30_o = audio_in_r2;
      9'b000100000: n30_o = audio_in_r1;
      9'b000010000: n30_o = audio_in_l5;
      9'b000001000: n30_o = audio_in_l4;
      9'b000000100: n30_o = audio_in_l3;
      9'b000000010: n30_o = audio_in_l2;
      9'b000000001: n30_o = audio_in_l1;
      default: n30_o = audio_in_r5;
    endcase
  /* ../../rtl/minimig/../audio/AudioMix.vhd:78:36  */
  assign n31_o = inmux[15];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:81:23  */
  assign n32_o = inmux_sel[2:0];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:82:36  */
  assign n34_o = n32_o == 3'b000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:83:36  */
  assign n36_o = n32_o == 3'b001;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:84:36  */
  assign n38_o = n32_o == 3'b010;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:85:36  */
  assign n40_o = n32_o == 3'b011;
  assign n41_o = {n40_o, n38_o, n36_o, n34_o};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:81:9  */
  always @*
    case (n41_o)
      4'b1000: n42_o = audio_vol4;
      4'b0100: n42_o = audio_vol3;
      4'b0010: n42_o = audio_vol2;
      4'b0001: n42_o = audio_vol1;
      default: n42_o = audio_vol5;
    endcase
  /* ../../rtl/minimig/../audio/AudioMix.vhd:96:44  */
  assign n48_o = {{10{inmux[16]}}, inmux}; // sext
  /* ../../rtl/minimig/../audio/AudioMix.vhd:96:44  */
  assign n49_o = {{17{volmux[9]}}, volmux}; // sext
  /* ../../rtl/minimig/../audio/AudioMix.vhd:96:44  */
  assign n50_o = n48_o * n49_o; // smul
  /* ../../rtl/minimig/../audio/AudioMix.vhd:97:52  */
  assign n51_o = accumulator + scaled_in;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:99:37  */
  assign n52_o = inmux_sel[2:0];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:99:49  */
  assign n54_o = n52_o == 3'b000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:99:25  */
  assign n56_o = n54_o ? 27'b000000000000000000000000000 : n51_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:108:32  */
  assign n60_o = accumulator[26:23];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:110:35  */
  assign n63_o = headroom == 4'b0000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:110:21  */
  assign n64_o = n63_o ? 1'b0 : n68_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:111:35  */
  assign n67_o = headroom == 4'b1111;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:110:44  */
  assign n68_o = n67_o ? 1'b0 : 1'b1;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:113:56  */
  assign n70_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n71_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n72_o = ~n71_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n73_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n74_o = ~n73_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n75_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n76_o = ~n75_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n77_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n78_o = ~n77_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n79_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n80_o = ~n79_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n81_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n82_o = ~n81_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n83_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n84_o = ~n83_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n85_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n86_o = ~n85_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n87_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n88_o = ~n87_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n89_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n90_o = ~n89_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n91_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n92_o = ~n91_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n93_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n94_o = ~n93_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n95_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n96_o = ~n95_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n97_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n98_o = ~n97_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n99_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n100_o = ~n99_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n101_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n102_o = ~n101_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n103_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n104_o = ~n103_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n105_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n106_o = ~n105_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n107_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n108_o = ~n107_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n109_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n110_o = ~n109_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n111_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n112_o = ~n111_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n113_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n114_o = ~n113_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:82  */
  assign n115_o = accumulator[26];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:114:67  */
  assign n116_o = ~n115_o;
  assign n117_o = {n72_o, n74_o, n76_o, n78_o};
  assign n118_o = {n80_o, n82_o, n84_o, n86_o};
  assign n119_o = {n88_o, n90_o, n92_o, n94_o};
  assign n120_o = {n96_o, n98_o, n100_o, n102_o};
  assign n121_o = {n104_o, n106_o, n108_o, n110_o};
  assign n122_o = {n112_o, n114_o, n116_o};
  assign n123_o = {n117_o, n118_o, n119_o, n120_o};
  assign n124_o = {n121_o, n122_o};
  assign n125_o = {n123_o, n124_o};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:115:31  */
  assign n126_o = accumulator[23:0];
  /* ../../rtl/minimig/../audio/AudioMix.vhd:115:81  */
  assign n127_o = ~overflow;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:115:68  */
  assign n128_o = n127_o ? n126_o : clamped;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:124:53  */
  assign n132_o = ~swap_channels;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:124:72  */
  assign n134_o = {n132_o, 3'b110};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:124:50  */
  assign n135_o = inmux_sel == n134_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:128:65  */
  assign n138_o = {swap_channels, 3'b110};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:128:50  */
  assign n139_o = inmux_sel == n138_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:60:17  */
  always @(posedge clk)
    n145_q <= n8_o;
  initial
    n145_q = 4'b0000;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:60:17  */
  assign n146_o = {n31_o, n30_o};
  assign n147_o = {1'b0, n42_o, 1'b0};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:95:17  */
  always @(posedge clk)
    n148_q <= n50_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:95:17  */
  always @(posedge clk)
    n149_q <= n56_o;
  assign n151_o = {n70_o, n125_o};
  /* ../../rtl/minimig/../audio/AudioMix.vhd:121:17  */
  assign n152_o = n135_o ? clipped : n153_q;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:121:17  */
  always @(posedge clk)
    n153_q <= n152_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:121:17  */
  assign n154_o = n139_o ? clipped : n155_q;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:121:17  */
  always @(posedge clk)
    n155_q <= n154_o;
  /* ../../rtl/minimig/../audio/AudioMix.vhd:121:17  */
  always @(posedge clk)
    n156_q <= overflow;
endmodule

