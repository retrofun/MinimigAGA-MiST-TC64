module chipset_log (
	input clk,
	input clk7_en,
	input reset,
	input [8:1] reg_address_in,
	input [15:0] data_in,
	input blit_busy
);

parameter depth=8;
reg [31:0] storage [2**depth];
reg [depth-1:0] wrptr;
reg armed;

// Selectors
reg [255:0] selected;
reg clk7_en_d;

reg [31:0] timestamp;

always @(posedge clk) begin
	if(jtag_go)
		timestamp<=0;
	else if(clk7_en)
		timestamp<=timestamp+1;
end

reg [31:0] log_d;
reg log_wr;

always @(posedge clk) begin
	if(log_wr) begin
		storage[wrptr]<=log_d;
		wrptr<=wrptr+8'd1;
	end
	if(jtag_go)
		wrptr<=0;
end

always @(posedge clk) begin
	clk7_en_d <= clk7_en;
	log_wr<=1'b0;

	if(clk7_en && armed) begin
		if(selected[reg_address_in]) begin
			log_d<={blit_busy,7'b0,reg_address_in,data_in};
			log_wr<=1'b1;
		end
	end
	if(clk7_en_d && armed) begin
		if(selected[reg_address_in]) begin
			log_d<={timestamp};
			log_wr<=1'b1;
		end
	end
end

always @(posedge clk) begin
	if(&wrptr || reset || jtag_reset)
		armed <= 1'b0;
	if(jtag_go)
		armed <= 1'b1;
end

// Virtual JTAG remote interface:

reg [7:0] jtag_cmd;

reg [depth-1:0] rdptr;
reg [31:0] jtag_d;

always @(posedge clk) begin
	case(jtag_cmd)
		8'h00: jtag_d <= {31'b0,armed};
		8'h04: jtag_d <= storage[rdptr];
		default: ;
	endcase
end


// Data received from the host computer

reg jtag_reset;
reg jtag_report;
reg jtag_go;

reg jtag_req;
reg jtag_ack;
reg jtag_wr;
wire [31:0] jtag_q;

always @(posedge clk) begin
	jtag_reset<=1'b0;
	jtag_go<=1'b0;
	jtag_report<=1'b0;
	
	if(jtag_ack && !jtag_wr) begin
		jtag_cmd <= jtag_q[31:24];
		case(jtag_q[31:24]) // Interpret the highest 8 bits as a command byte

			8'h00: jtag_report<=1'b1;
			8'h01: jtag_go <= 1'b1;
			8'h02: selected[jtag_q[7:0]]<=1'b1;
			8'h03: selected[jtag_q[7:0]]<=1'b0;
			8'h04: jtag_report<=1'b1;

			8'hff: begin 
					jtag_reset<=1'b1; // Command 0xff: reset
					selected<=0;
				end

		endcase
	end
end


// Plumbing

always @(posedge clk) begin
	jtag_req<=!jtag_ack;

	if(jtag_ack && jtag_wr) begin
		case(jtag_cmd)
			8'h04: begin
				rdptr<=rdptr+8'd1;
				jtag_wr <= ~(&rdptr);
			end
			default: jtag_wr<=1'b0;
		endcase
	end

	if(jtag_report) begin
		rdptr<=0;
		jtag_wr<=1'b1;
	end

	if(reset)
		rdptr<={depth{1'b1}};
end


// This bridge is borrowed from the EightThirtyTwo debug interface

debug_bridge_jtag #(.id('h8371)) bridge (
	.clk(clk),
	.reset_n(~reset),
	.d(jtag_d),
	.q(jtag_q),
	.req(jtag_req),
	.wr(jtag_wr),
	.ack(jtag_ack)
);

endmodule

