`include "alu.v"

module testALU();
  // ALU inputs and outputs
  reg [10:0] a, b;
  reg [3:0] control;

  wire [10:0] out;
  wire overflow, gr_flag, le_flag, eq_flag;

  reg dutpassed;

  // DUT
  alu dut(
    .in0(a),
    .in1(b),
    .funct(control),
    .out(out),
    .overflow(overflow),
    .gr_flag(gr_flag),
    .le_flag(le_flag),
    .eq_flag(eq_flag));

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars();

    dutpassed = 1;

    // a = 200, b = 4
    // Test ADD 2+, MUL 2+, gr_flag
    #20
    a = 11'd200; b = 11'd4;
    #10
    control = `ADDMODULE;
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,0);
    end

    #20
    control = `MULMODULE;
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 0) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,0);
    end


  end
endmodule
