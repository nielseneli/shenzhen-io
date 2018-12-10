`include "registers.v"

module testRegs();
	reg clk = 1'b0;
	reg[10:0] write_dat = 11'b0;
	reg[2:0] write_addr = 3'b0;
	reg write_en = 1'b0;
	reg[10:0] p0_in = 11'b0;
	reg[10:0] p1_in = 11'b0;
	reg[2:0] read_addr0 = 3'b0;
	reg[2:0] read_addr1 = 3'b0;
	reg[10:0] x0_in = 11'b0;
	reg[10:0] x1_in = 11'b0;
	reg x0_write_in = 1'b0;
	reg x1_write_in = 1'b0;
	reg x0_read_in = 1'b0;
	reg x1_read_in = 1'b0;

	wire[10:0] p0_out, p1_out, dat_out0, dat_out1, x0_out, x1_out;
	wire x0_write_out, x1_write_out, x0_read_out, x1_read_out, increment_pc;

	MC3999regFile dut(
		.write_dat(write_dat),
		.write_addr(write_addr),
		.write_en(write_en),
		.p0_in(p0_in),
		.p1_in(p1_in),
		.read_addr0(read_addr0),
		.read_addr1(read_addr1),
		.x0_in(x0_in),
		.x1_in(x1_in),
		.x0_read_in(x0_read_in),
		.x1_read_in(x1_read_in),
		.x0_write_in(x0_write_in),
		.x1_write_in(x1_write_in),
		.clk(clk),

		.p0_out(p0_out),
		.p1_out(p1_out),
		.dat_out0(dat_out0),
		.dat_out1(dat_out1),
		.x0_out(x0_out),
		.x1_out(x1_out),
		.x0_read_out(x0_read_out),
		.x1_read_out(x1_read_out),
		.x0_write_out(x0_write_out),
		.x1_write_out(x1_write_out),
		.increment_pc(increment_pc));

	always #10 clk = !clk;

	initial begin
		$dumpfile("registers.vcd");
		$dumpvars();
		$display("Starting register tests.");

		#20
		read_addr1 = 3'b010;
		if(dat_out0 != 0 || dat_out1 != 0)
			$display("Error: registers not initialized to 0.");

		#20
		read_addr0 = 0;
		read_addr1 = 0;
		write_dat = 11'd42;
		write_addr = 3'b011;
		write_en = 1;
		#20
		if(p1_out != 11'd42)
			$display("Error: simple I/O not written to.");

		#20
		write_en = 0;
		read_addr1 = 3'b011;
		p1_in = 11'd57;
		#20
		if(dat_out1 != 11'd57)
			$display("Error: simple I/O not reading.");
		if(p1_out != 11'b0)
			$display("Error: simple I/O not clearing after read.");

		#20
		write_en = 1;
		write_dat = 11'd79;
		write_addr = 3'b0;
		read_addr0 = 0;
		read_addr1 = 0;
		#20
		if(dat_out1 != 79 || dat_out0 != 79)
			$display("Error: acc not written to");
		#20
		write_en = 0;
		write_dat = 11'd777;
		#20
		if(dat_out1 != 79 || dat_out0 != 79)
			$display("Write not disabled by write_en");

		#20
		write_en = 1;
		write_dat = 11'd444;
		write_addr = 3'b100; //x0
		x0_read_in = 0;
		#20
		if(x0_write_out != 1)
			$display("XBus write not raising flag");
		if(x0_out != 11'd444)
			$display("XBus write not outputting value");
		if(increment_pc == 1)
			$display("XBus write not halting PC");

		#40
		if(increment_pc == 1 || x0_write_out != 1 || x0_out != 11'd444)
			$display("XBus write doesn't hold state across cycles");
		#20
		x0_read_in = 1;
		#10
		x0_read_in = 0;
		write_en = 0;
		write_dat = 0;
		write_addr = 0;
		#10
		if (increment_pc == 0)
			$display("XBus write doesn't increment PC when read_in goes high");
		if (x0_write_out != 0)
			$display("XBus write flag doesn't go low after writing");
		if(x0_out != 0)
			$display("XBus output doesn't clear after writing");

		#20
		read_addr0 = 3'b101;
		x1_write_in = 0;
		#20
		if (increment_pc == 1)
			$display("XBus read doesn't halt PC");
		if (x1_read_out != 1)
			$display("XBus read doesn't rais read flag");

		#40
		if(increment_pc == 1 || x1_read_out != 1)
			$display("XBus read doesn't hold state across cycles");
		#20
		x1_write_in = 1;
		x1_in = 11'd777;
		#5
		if (dat_out0 != 11'd777)
			$display("XBus read not reading value when written to.");
		#5
		read_addr0 = 0;
		x1_write_in = 0;
		x1_in = 0;
		#10
		if(x0_read_out == 1)
			$display("XBus read not clearing flag after read");

		

		#40

		$display("Ending register tests.\n");
		$finish();

	end // initial

endmodule // testRegs