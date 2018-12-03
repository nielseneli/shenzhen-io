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
    a = 11'd200; b = 11'd4;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 1 || le_flag !== 0 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = -14, b = -30
    // Test ADD 2-, MUL 2-
    a = -11'd14; b = -11'd30;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 1 || le_flag !== 0 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = 500, b = 550
    // Test SUB 2+, ADD + of, MUL + of
    a = 11'd500; b = 11'd550;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 0 || le_flag !== 1 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = -300, b = -700
    // Test SUB 2-, ADD - of, MUL - of
    a = -11'd300; b = -11'd700;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 1 || le_flag !== 0 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = 20, b = -3
    // Test SUB +/-, MUL +/-
    a = 11'd20; b = -11'd3;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 1 || le_flag !== 0 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = 600, b = -450
    // Test SUB + of
    a = 11'd600; b = -11'd450;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 1 || le_flag !== 0 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    // a = -350, b = 900
    // Test SUB - of, ADD +/-
    a = -11'd350; b = 11'd900;
    #20
    control = `ADDMODULE;
    #10
    if (out !== a + b) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed adding:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    control = `SUBMODULE;
    #10
    if (out !== a - b) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a-b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed subtracting:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `MULMODULE;
    #10
    if (out !== a * b) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,a+b);
    end
    if (overflow !== 1'b1) begin
      dutpassed = 0;
      $display("Failed multiplying:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b1);
    end

    control = `NOTMODULE;
    #10
    if (out !== 11'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   result = %b  expected %b", a,b,out,11'b0);
    end
    if (overflow !== 1'b0) begin
      dutpassed = 0;
      $display("Failed not:");
      $display("a = %b  b = %b   overflow = %b  expected %b", a,b,overflow,1'b0);
    end

    // flags
    if (gr_flag !== 0 || le_flag !== 1 || eq_flag !== 0) begin
      dutpassed = 0;
      $display("Failed comparison flags:");
      $display("a = %b  b = %b  > %b  < %b  = %b", a,b,gr_flag,le_flag,eq_flag);
    end

    $display("DUT passed: %b", dutpassed);


  end
endmodule
