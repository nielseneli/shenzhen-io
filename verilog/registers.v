module MC3999regFile(
	input[10:0] write_dat,
	input[2:0] write_addr,
	input write_en,
	input[10:0] p0_in,
	input[10:0] p1_in,
	input[2:0] read_addr0,
	input[2:0] read_addr1,
	input[10:0] x0_in,
	input[10:0] x1_in,
	input x0_read_in,
	input x1_read_in,
	input x0_write_in,
	input x1_write_in,
	input clk,

	output reg[10:0] p0_out,
	output reg[10:0] p1_out,
	output reg[10:0] dat_out0,
	output reg[10:0] dat_out1,
	output reg[10:0] x0_out,
	output reg[10:0] x1_out,
	output reg x0_read_out,
	output reg x1_read_out,
	output reg x0_write_out,
	output reg x1_write_out,
	output reg increment_pc);

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
			3'b100: begin //x0
				// If you're writing to an xbus, but haven't pushed your data yet
				// Push data, update output write state
				if (x0_write_out == 0) begin
					x0_write_out = 1;
					x0_out = write_dat;
				end
				else begin
					// If you're writing and HAVE pushed data
					// If you're being read, clear outputs
					if (x0_read_in == 1) begin
						x0_out = 0;
						x0_write_out = 0;
					end // if (x0_read_in == 1)
					//If you're not being read, don't change anything about your outputs
					//The PC won't increment
				end
			end // x0

			3'b101: begin  //x1
				if (x1_write_out == 0) begin
					x1_write_out = 1;
					x1_out = write_dat;
				end // if (x1_write_out == 0)
				else begin
					if (x1_read_in == 1) begin
						x1_out = 0;
						x1_write_out = 0;
					end // if (x1_read_in == 1)
				end
			end // x0
		endcase // write_addr

		// If a simple input was read, clear its output
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

		3'b100:	x0_read_out = 1; //x0
		3'b101: x1_read_out = 1; //x1
		default: dat_out0 = 11'b0;
	endcase

	case (read_addr1)
		3'b000: dat_out1 = acc;
		3'b010: begin dat_out1 = p0_in; end
		3'b011: begin dat_out1 = p1_in; end

		3'b100:	x0_read_out = 1; //x0
		3'b101: x1_read_out = 1; //x1
		default: dat_out1 = 11'b0;
	endcase

	// If neither port is reading an xbus input, clear its read_out
	if (read_addr0 != 3'b100 && read_addr1 != 3'b100)
		x0_read_out = 0;
	if (read_addr0 != 3'b101 && read_addr1 != 3'b101)
		x1_read_out = 0;

	//if we're reading or writing an xbus
	if (write_addr == 3'b100 || write_addr == 3'b101 || read_addr0 == 3'b100 || read_addr0 == 3'b101 || read_addr1 == 3'b100 || read_addr1 == 3'b101) begin
		// If you're writing, but haven't pushed the output yet, don't increment pc
		if (x0_write_out == 0 || x1_write_out == 0)
			increment_pc = 0;
		// If you're writing and HAVE pushed the output, but it's not been read yet, don't increment pc
		else if ((x0_write_out == 1 && x0_read_in == 0) || (x1_write_out == 1 && x0_read_in == 0))
			increment_pc = 0;
		// If you're reading, but haven't been written to, don't increment pc
		else if ((x0_read_out == 1 && x0_write_in == 0) || (x1_read_out == 1 && x0_write_in == 0))
			increment_pc = 0;
		else
			increment_pc = 1;
	end

end



endmodule