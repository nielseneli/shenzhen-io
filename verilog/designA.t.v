`include "verilog/design.v"

module designA_tests();
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
	designA dut(.clk(clk),
				.posedge_big_clk(posedge_big_clk),
				.input_signal(),
				.output_signal(output_signal));

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
		$readmemb(mem_text_fn1, dut.dut0.instructionMemory.memory, 0);
		$readmemb(mem_text_fn2, dut.dut1.instructionMemory.memory, 0);

		// Dump waveforms to file
		// Note: arrays (e.g. memory) are not dumped by default
		$dumpfile(dump_fn);
		$dumpvars();


		// Display a few cycles just for quick checking
		// $display("Time | PC       | Instruction");
		// repeat(3) begin
	  //       $display("DUT0 | %4t | %h | %h", $time, dut.dut0.program_counter, dut.dut0.final_instruction);
	  //       $display("DUT1 | %4t | %h | %h", $time, dut.dut1.program_counter, dut.dut1.final_instruction); #20 ;
	  //       end
		// $display("... more execution (see waveform)");

		// End execution after some time delay
		#5000
		$finish();
	end

endmodule
