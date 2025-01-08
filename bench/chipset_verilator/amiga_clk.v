
module amiga_clk (
  input  wire           reset_n,        // asynhronous reset input
  input  wire           clk_28,     // 28MHz output clock ( 28.375160MHz)
  output wire           clk7_en,    // 7MHz output clock enable (on 28MHz clock domain)
  output wire           clk7n_en,   // 7MHz negedge output clock enable (on 28MHz clock domain)
  output wire           c1,         // clk28m clock domain signal synchronous with clk signal
  output wire           c3,         // clk28m clock domain signal synchronous with clk signal delayed by 90 degrees
  output wire           cck,        // colour clock output (3.54 MHz)
  output wire [ 10-1:0] eclk       // 0.709379 MHz clock enable output (clk domain pulse)
);

//// generated clocks ////

// 7MHz
reg [2-1:0] clk7_cnt = 2'b10;
reg         clk7_en_reg = 1'b1;
reg         clk7n_en_reg = 1'b1;
always @ (posedge clk_28, negedge reset_n) begin
  if (!reset_n) begin
    clk7_cnt     <= 2'b10;
    clk7_en_reg  <= #1 1'b1;
    clk7n_en_reg <= #1 1'b1;
  end else begin
    clk7_cnt     <= clk7_cnt + 2'b01;
    clk7_en_reg  <= #1 (clk7_cnt == 2'b00);
    clk7n_en_reg <= #1 (clk7_cnt == 2'b10);
  end
end

wire clk_7 = clk7_cnt[1];
assign clk7_en = clk7_en_reg;
assign clk7n_en = clk7n_en_reg;

// amiga clocks & clock enables
//            __    __    __    __    __
// clk_28  __/  \__/  \__/  \__/  \__/  
//            ___________             __
// clk_7   __/           \___________/  
//            ___________             __
// c1      __/           \___________/   <- clk28m domain
//                  ___________
// c3      ________/           \________ <- clk28m domain
//

// clk_28 clock domain signal synchronous with clk signal delayed by 90 degrees
reg c3_r = 1'b0;
always @(posedge clk_28) begin
  c3_r <= clk_7;
end
assign c3 = c3_r;

// clk28m clock domain signal synchronous with clk signal
reg c1_r = 1'b0;
always @(posedge clk_28) begin
  c1_r <= ~c3_r;
end
assign c1 = c1_r;

// counter used to generate e clock enable
reg [3:0] e_cnt = 4'b0000;
always @(posedge clk_28) begin
  if (clk7_cnt == 2'b01) begin
    if (e_cnt[3] && e_cnt[0])
      e_cnt[3:0] <= 4'd0;
    else
      e_cnt[3:0] <= e_cnt[3:0] + 4'd1;
  end
end

// CCK clock output
assign cck = ~e_cnt[0];

// 0.709379 MHz clock enable output (clk domain pulse)
assign eclk[0] = ~e_cnt[3] & ~e_cnt[2] & ~e_cnt[1] & ~e_cnt[0]; // e_cnt == 0
assign eclk[1] = ~e_cnt[3] & ~e_cnt[2] & ~e_cnt[1] &  e_cnt[0]; // e_cnt == 1
assign eclk[2] = ~e_cnt[3] & ~e_cnt[2] &  e_cnt[1] & ~e_cnt[0]; // e_cnt == 2
assign eclk[3] = ~e_cnt[3] & ~e_cnt[2] &  e_cnt[1] &  e_cnt[0]; // e_cnt == 3
assign eclk[4] = ~e_cnt[3] &  e_cnt[2] & ~e_cnt[1] & ~e_cnt[0]; // e_cnt == 4
assign eclk[5] = ~e_cnt[3] &  e_cnt[2] & ~e_cnt[1] &  e_cnt[0]; // e_cnt == 5
assign eclk[6] = ~e_cnt[3] &  e_cnt[2] &  e_cnt[1] & ~e_cnt[0]; // e_cnt == 6
assign eclk[7] = ~e_cnt[3] &  e_cnt[2] &  e_cnt[1] &  e_cnt[0]; // e_cnt == 7
assign eclk[8] =  e_cnt[3] & ~e_cnt[2] & ~e_cnt[1] & ~e_cnt[0]; // e_cnt == 8
assign eclk[9] =  e_cnt[3] & ~e_cnt[2] & ~e_cnt[1] &  e_cnt[0]; // e_cnt == 9


endmodule


