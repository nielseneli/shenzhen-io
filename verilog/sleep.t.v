`include "sleep.v"

module testSleep();

	reg clk = 1'b1;
	reg posedge_big_clk = 1'b0;
	reg[10:0] sleep_val = 11'b00000000000;
	reg input_flag = 1'b0;

	wire output_flag;

	sleep dut(
		.clk(clk),
		.posedge_big_clk(posedge_big_clk),
		.sleep_val(sleep_val[10:0]),
		.input_flag(input_flag),
		.output_flag(output_flag));

	always #10 clk = !clk;

	initial begin
		$dumpfile("sleep.vcd");
		$dumpvars();
		$display("Starting sleep tests");
		
		#100;
		if (output_flag)
			$display("Error: starts sleeping when input_flag is low");

		#100;
		sleep_val = 11'd1;
		input_flag = 1'b1;
		#20;
		if (~output_flag)
			$display("Error: doesn't start sleeping when input_flag high");

		#100;
		posedge_big_clk = 1'b1;
		input_flag = 1'b0;
		#20;
		posedge_big_clk = 1'b0;
		if (output_flag)
			$display("Error: doesn't stop sleeping");
		#100;

		$display("Ending sleep tests \n")
		$finish();


	end // initial
endmodule // testSleep