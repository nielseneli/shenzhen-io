module MC3999regFile(
	input[10:0] write_dat,
	input[2:0] write_addr,
	input write_en,
	input[10:0] p0_in,
	input[10:0] p1_in,
	input[2:0] read_addr0,
	input[2:0] read_addr1,
	input clk,

	output reg[10:0] p0_out,
	output reg[10:0] p1_out,
	output reg[10:0] dat_out0,
	output reg[10:0] dat_out1);

reg[10:0] acc = 11'b0;
initial begin
	p0_out = 11'b0;
	p1_out = 11'b0;
end

always @(posedge clk) begin
	if (write_en) begin
		case (write_addr)
			3'b000: acc = write_dat;
			3'b010: p0_out = write_dat;
			3'b011: p1_out = write_dat;
		endcase // write_addr

		case (read_addr0)
			3'b010: p0_out = 3'b0;
			3'b011: p1_out = 3'b0;
		endcase

		case (read_addr1)
			3'b010: p0_out = 3'b0;
			3'b011: p1_out = 3'b0;
		endcase

	end // if (write_en)
end

always @(*) begin
	case (read_addr0)
		3'b000: dat_out0 = acc;
		3'b010: begin dat_out0 = p0_in; end //When you read a simple input
		3'b011: begin dat_out0 = p1_in; end //Clear the corresponding output
		default: dat_out0 = 11'b0;
	endcase

	case (read_addr1)
		3'b000: dat_out1 = acc;
		3'b010: begin dat_out1 = p0_in; end
		3'b011: begin dat_out1 = p1_in; end
		default: dat_out1 = 11'b0;
	endcase

end



endmodule