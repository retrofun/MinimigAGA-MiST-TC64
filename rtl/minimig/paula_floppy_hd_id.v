// HD floppy drive ID 0xaaaaaaaa
// Amiga Hardware Reference Manual 3rd Edition, Appendix H

module paula_floppy_hd_id
(
  input clk,
  input clk7_en,
  input reset,
  input motor_on,
  input _motor,
  input _sel,
  input _sel_del,

  output _hd_id
);

assign _hd_id = _hd_id_bit;

localparam HD_ID_WAIT_MOTOR_ON = 2'd0;
localparam HD_ID_WAIT_MOTOR_OFF = 2'd1;
localparam HD_ID_ENABLE = 2'd2;

reg[1:0] hd_id_state;
reg _hd_id_bit;
reg[4:0] hd_id_cnt;

always @(posedge clk) begin
  if (clk7_en) begin
    if (reset) begin
      hd_id_state <= HD_ID_WAIT_MOTOR_ON;
      _hd_id_bit <= 1'b1;
      hd_id_cnt <= 5'd0;
    end else begin
      case (hd_id_state)
        HD_ID_WAIT_MOTOR_ON:
          begin
            if (motor_on)
              hd_id_state <= HD_ID_WAIT_MOTOR_OFF;
            _hd_id_bit <= _sel;
          end

        HD_ID_WAIT_MOTOR_OFF:
          begin
            if (!motor_on) begin
              hd_id_state <= HD_ID_ENABLE;
              hd_id_cnt <= 5'd0;
            end
            _hd_id_bit <= _sel;
          end

        HD_ID_ENABLE:
          if (!_motor) begin
            hd_id_state <= HD_ID_WAIT_MOTOR_ON;
            _hd_id_bit <= 1'b1;
          end else if (!_sel && _sel_del)
            _hd_id_bit <= hd_id_cnt;
          else if (_sel && !_sel_del) begin
            if (hd_id_cnt == 5'd31)
              hd_id_state <= HD_ID_WAIT_MOTOR_ON;
            else
              hd_id_cnt <= hd_id_cnt + 5'd1;
            _hd_id_bit <= 1'b1;
          end
      endcase
    end
  end
end

endmodule
