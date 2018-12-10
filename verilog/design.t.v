`include "design.v"

module design_tests();
	// Input and output to the design
	reg  [10:0] input_signal;
	wire [10:0] output_signal;
	// Clocks and helper vars for clocks
	reg         clk = 0;
	reg         posedge_big_clk = 0;
	reg  [31:0] counter = 0;
	reg  [31:0] big_clk_time = 200;

	// Start the clocks - big_clk is 22 clk cycles
	always begin
		#10
		clk = !clk;
		counter = counter + 10;
		if (counter == big_clk_time)
			posedge_big_clk = 1;
		if (counter == big_clk_time+20) begin
			counter = 0;
			posedge_big_clk = 0;
		end
	end

	// Design under test
	designx dut(.clk(clk),
				.posedge_big_clk(posedge_big_clk),
				.input_signal(),
				.output_signal(output_signal));
	// MC9999 dut(.clk(clk),
	// 	.posedge_big_clk(posedge_big_clk),
	// 	.p0_in(p0_in),
	// 	.p1_in(p1_in),
	// 	.p0_out(p0_out),
	// 	.p1_out(p1_out));

	// Filenames for memory images and VCD dump file
  reg [1023:0] mem_text_fn1, mem_text_fn2;
  reg [1023:0] dump_fn;
  reg init_data = 1;      // Initializing .data segment is optional

  // Test sequence
  initial begin
  	$display("Starting CPU tests.");

		// Get command line arguments for memory image(s) and VCD dump file
		//   http://iverilog.wikia.com/wiki/Simulation
		//   http://www.project-veripage.com/plusarg.php
		if (! $value$plusargs("mem_text_fn1=%s", mem_text_fn1)) begin
	    $display("ERROR: provide +mem_text_fn1=[path to .text memory image] argument");
	    $finish();
    end

		if (! $value$plusargs("mem_text_fn2=%s", mem_text_fn2)) begin
	    $display("ERROR: provide +mem_text_fn2=[path to .text memory image] argument");
	    $finish();
    end

		if (! $value$plusargs("dump_fn=%s", dump_fn)) begin
	    $display("ERROR: provide +dump_fn=[path for VCD dump] argument");
	    $finish();
	  end


    // Load CPU memory from (assembly) dump files
    // Assumes compact memory map, _word_ addressed memory implementation
    //   -> .text segment starts at word address 0
    //   -> .data segment starts at word address 2048 (byte address 0x2000)
		$readmemb(mem_text_fn1, dut.dut1.instructionMemory.memory, 0);
		$readmemb(mem_text_fn2, dut.dut2.instructionMemory.memory, 0);

		// Dump waveforms to file
		// Note: arrays (e.g. memory) are not dumped by default
		$dumpfile(dump_fn);
		$dumpvars();


		// Display a few cycles just for quick checking
		// Note: I'm just dumping instruction bits, but you can do some
		// self-checking test cases based on your CPU and program and
		// automatically report the results.
		$display("Time | PC       | Instruction");
		repeat(3) begin
	        $display("%4t | %h | %h", $time, dut.dut2.program_counter, dut.dut2.final_instruction);
	        $display("%4t | %h | %h", $time, dut.dut1.program_counter, dut.dut1.final_instruction); #20 ;
	        end
		$display("... more execution (see waveform)");

		// End execution after some time delay - adjust to match your program
		// or use a smarter approach like looking for an exit syscall or the
		// PC to be the value of the last instruction in your program.
		#5000
		// if(cpu.register.mux1.input2==32'h3a)
		// 	$display("Fib Test Successful");
		$finish();
	end

endmodule // MC9999_test