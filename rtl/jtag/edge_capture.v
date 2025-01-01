module edge_capture #(parameter bits=8, depth=8) (
	input clk,
	input reset,
	input [bits-1:0] d
);

localparam CMD_STATUS = 8'h0,
	CMD_GO = 8'h1,
	CMD_MASK = 8'h2,
	CMD_INITSTATE = 8'h3,
	CMD_INITMASK = 4'h4,
	CMD_REPORT = 8'hfe,
	CMD_RESET = 8'hff;

reg [31:0] storage [2**depth];
reg [depth-1:0] wrptr;
reg armed;
reg running;

// Timestamp
reg [31:0] timestamp;

always @(posedge clk) begin
	if(jtag_go)
		timestamp<=0;
	else
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

// Trigger logic

reg [bits-1:0] mask;
reg [bits-1:0] initmask;
reg [bits-1:0] initstate;
reg [bits-1:0] prev;

always @(posedge clk) begin
	log_d[31:bits]<=timestamp[31-bits:0];
	log_d[bits-1:0]<=d;
	log_wr<=1'b0;

	prev<=d;

	if (initmask) begin
		if (armed && (|(d^prev)&initmask)) begin
			if ((d&initmask) == (initstate&initmask)) begin
				running <=1'b1;
				log_wr<=1'b1;
			end
		end
	end else begin
		if(armed)
			running <= 1'b1;
	end
	if (!armed)
		running <= 1'b0;
	
	if (running && |((d^prev)&mask))
		log_wr<=1'b1;	
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
		CMD_STATUS: jtag_d <= {31'b0,armed};
		CMD_REPORT: jtag_d <= storage[rdptr];
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

			CMD_STATUS: jtag_report<=1'b1;
			CMD_GO: jtag_go <= 1'b1;
			CMD_MASK: mask <= jtag_q[bits-1:0];
			CMD_INITMASK: initmask <= jtag_q[bits-1:0];
			CMD_INITSTATE: initstate <= jtag_q[bits-1:0];
			CMD_REPORT: jtag_report<=1'b1;

			CMD_RESET: begin 
					jtag_reset<=1'b1; // Command 0xff: reset
					mask<=0;
				end

		endcase
	end
end


// Plumbing

always @(posedge clk) begin
	jtag_req<=!jtag_ack;

	if(jtag_ack && jtag_wr) begin
		case(jtag_cmd)
			CMD_REPORT: begin
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

debug_bridge_jtag #(.id('hED6E)) bridge (
	.clk(clk),
	.reset_n(~reset),
	.d(jtag_d),
	.q(jtag_q),
	.req(jtag_req),
	.wr(jtag_wr),
	.ack(jtag_ack)
);

endmodule

