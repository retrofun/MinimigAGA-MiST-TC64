// dpram_inf_256x32.v
// 2015, rok.krajnc@gmail.com
// inferrable dual-port memory

module dpram_inf_256x32 (
  input  wire           clock,
  input  wire           wren_a,
  input  wire [  8-1:0] address_a,
  input  wire [ 32-1:0] data_a,
  output [ 32-1:0] q_a,
  input  wire           wren_b,
  input  wire [  8-1:0] address_b,
  input  wire [ 32-1:0] data_b,
  output [ 32-1:0] q_b
);

// memory
reg [32-1:0] mem [0:256-1];

reg [32-1:0] q_a_i;
reg [32-1:0] q_b_i;

// port a
always @ (posedge clock) begin
  if (wren_a) mem[address_a] <= #1 data_a;
  q_a_i <= #1 mem[address_a];
end
assign q_a = q_a_i;

// port b
always @ (posedge clock) begin
  if (wren_b) mem[address_b] <= #1 data_b;
  q_b_i <= #1 mem[address_b];
end
assign q_b = q_b_i;

endmodule

