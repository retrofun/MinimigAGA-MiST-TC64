module audiofilter
  (input  clk,
   input  filter_ena,
   input  [15:0] audio_in_left,
   input  [15:0] audio_in_right,
   output [15:0] audio_out_left,
   output [15:0] audio_out_right);
  wire [7:0] clkdiv;
  wire [18:0] y_n_left;
  wire [18:0] y_n_right;
  wire [18:0] y_nminus1;
  wire [18:0] y_nminus1_shifted;
  wire [15:0] x_n;
  wire [18:0] x_n_ext;
  wire [18:0] sum;
  wire n2_o;
  wire [15:0] n3_o;
  wire n4_o;
  wire n5_o;
  wire [1:0] n6_o;
  wire n7_o;
  wire [2:0] n8_o;
  wire [18:0] n9_o;
  wire n10_o;
  wire [18:0] n11_o;
  wire n12_o;
  wire n13_o;
  wire [1:0] n14_o;
  wire n15_o;
  wire [2:0] n16_o;
  wire [15:0] n17_o;
  wire [18:0] n18_o;
  wire [15:0] n19_o;
  wire [15:0] n20_o;
  wire [7:0] n25_o;
  wire [18:0] n26_o;
  wire [18:0] n27_o;
  wire n29_o;
  wire n30_o;
  wire n31_o;
  wire [1:0] n32_o;
  wire n34_o;
  wire n35_o;
  wire n36_o;
  wire n38_o;
  wire n39_o;
  wire n40_o;
  wire [1:0] n41_o;
  wire n43_o;
  wire n44_o;
  wire n45_o;
  wire [18:0] n46_o;
  wire [18:0] n47_o;
  reg [7:0] n54_q;
  reg [18:0] n55_q;
  wire [18:0] n56_o;
  reg [18:0] n57_q;
  reg [18:0] n58_q;
  assign audio_out_left = n19_o;
  assign audio_out_right = n20_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:49  */
  assign clkdiv = n54_q; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:26:8  */
  assign y_n_left = n55_q; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:27:8  */
  assign y_n_right = n57_q; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:29:8  */
  assign y_nminus1 = n11_o; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:30:8  */
  assign y_nminus1_shifted = n18_o; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:32:8  */
  assign x_n = n3_o; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:33:8  */
  assign x_n_ext = n9_o; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:35:8  */
  assign sum = n58_q; // (signal)
  /* ../../rtl/minimig/../audio/audiofilter.vhd:40:33  */
  assign n2_o = clkdiv[1];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:40:22  */
  assign n3_o = n2_o ? audio_in_left : audio_in_right;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:15  */
  assign n4_o = x_n[15];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:25  */
  assign n5_o = x_n[15];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:20  */
  assign n6_o = {n4_o, n5_o};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:35  */
  assign n7_o = x_n[15];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:30  */
  assign n8_o = {n6_o, n7_o};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:42:40  */
  assign n9_o = {n8_o, x_n};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:45:34  */
  assign n10_o = clkdiv[1];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:45:23  */
  assign n11_o = n10_o ? y_n_left : y_n_right;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:31  */
  assign n12_o = y_nminus1[18];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:47  */
  assign n13_o = y_nminus1[18];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:36  */
  assign n14_o = {n12_o, n13_o};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:63  */
  assign n15_o = y_nminus1[18];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:52  */
  assign n16_o = {n14_o, n15_o};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:79  */
  assign n17_o = y_nminus1[18:3];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:47:68  */
  assign n18_o = {n16_o, n17_o};
  /* ../../rtl/minimig/../audio/audiofilter.vhd:50:27  */
  assign n19_o = y_n_left[18:3];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:51:29  */
  assign n20_o = y_n_right[18:3];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:56:31  */
  assign n25_o = clkdiv + 8'b00000001;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:61:34  */
  assign n26_o = y_nminus1 + x_n_ext;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:61:44  */
  assign n27_o = n26_o - y_nminus1_shifted;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:58  */
  assign n29_o = clkdiv == 8'b00000001;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:36  */
  assign n30_o = filter_ena & n29_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:85  */
  assign n31_o = ~filter_ena;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:100  */
  assign n32_o = clkdiv[1:0];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:112  */
  assign n34_o = n32_o == 2'b01;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:90  */
  assign n35_o = n31_o & n34_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:71  */
  assign n36_o = n30_o | n35_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:61  */
  assign n38_o = clkdiv == 8'b10000011;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:39  */
  assign n39_o = filter_ena & n38_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:88  */
  assign n40_o = ~filter_ena;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:103  */
  assign n41_o = clkdiv[1:0];
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:115  */
  assign n43_o = n41_o == 2'b11;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:93  */
  assign n44_o = n40_o & n43_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:74  */
  assign n45_o = n39_o | n44_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:65:17  */
  assign n46_o = n45_o ? sum : y_n_left;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:63:17  */
  assign n47_o = n36_o ? y_n_left : n46_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:55:9  */
  always @(posedge clk)
    n54_q <= n25_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:55:9  */
  always @(posedge clk)
    n55_q <= n47_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:55:9  */
  assign n56_o = n36_o ? sum : y_n_right;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:55:9  */
  always @(posedge clk)
    n57_q <= n56_o;
  /* ../../rtl/minimig/../audio/audiofilter.vhd:55:9  */
  always @(posedge clk)
    n58_q <= n27_o;
endmodule

