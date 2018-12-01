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

	wire[10:0] p0_out, p1_out, dat_out0, dat_out1;

	MC3999regFile dut(
		.write_dat(write_dat),
		.write_addr(write_addr),
		.write_en(write_en),
		.p0_in(p0_in),
		.p1_in(p1_in),
		.read_addr0(read_addr0),
		.read_addr1(read_addr1),
		.clk(clk),
		.p0_out(p0_out),
		.p1_out(p1_out),
		.dat_out0(dat_out0),
		.dat_out1(dat_out1));

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

		#40

		$display("Ending register tests.\n");
		$finish();

	end // initial

endmodule // testRegs