`define ADDMODULE 3'd0
`define SUBMODULE 3'd1
`define MULMODULE 3'd2
`define NOTMODULE 3'd3
`define SLTMODULE 3'd4
`define SGTMODULE 3'd5

// http://www.ece.lsu.edu/ee3755/2012f/l05.v.html - add/sub overflow detection

module alu (
input [10:0]      in0,
                  in1,
input [3:0]       funct,
output reg [10:0] out,
output reg        overflow,
output wire       gr_flag,
                  le_flag,
                  eq_flag
);
  wire [10:0] sum, difference, product, not_out;
  wire [5:0] overflows = 0;
  // Module code here
  adder add_module(.out(sum),
              .overflow(overflows[0]),
              .a(in0),
              .b(in1));

  subber sub_module(.out(difference),
              .overflow(overflows[1]),
              .a(in0),
              .b(in1));

  multiplier mul_module(.out(product),
              .overflow(overflows[2]),
              .a(in0),
              .b(in1));

  // If in0 is all 0s, then out = 127, else out = 0
  assign not_out = (~&(in0)) ? 11'd127 : 11'b0;

  always @(funct) begin
    case (funct)
      `ADDMODULE: begin
        out = sum;
        overflow = overflows[0];
      end
      `SUBMODULE: begin
        out = difference;
        overflow = overflows[1];
      end
      `MULMODULE: begin
        out = product;
        overflow = overflows[2];
      end
      `NOTMODULE: begin
        out = not_out;
        overflow = overflows[3];
      end
    endcase
  end

  // FLAGS
  // If the difference is all 0s, the inputs were equal
  assign eq_flag = ~&(difference);
  // If the difference is negative, in0 < in1
  assign le_flag = difference[10];
  // If the difference is positive and not all zeros, in0 > in1
  assign gr_flag = difference[10] ~& eq_flag;
endmodule

module adder(
  output [10:0] out,
  output        overflow,
  input  [10:0] a, b
);
  wire cout, cout1;
  wire [9:0] small_sum;

  // Find sum with a carryout bit
  assign {cout, out} = a + b;
  // Find next most significant carryout bit
  assign {cout1, small_sum} = a[9:0] + b[9:0];
  // If the most and next most significant carryout bits are different, overflow
  assign overflow = cout ^ cout1;
endmodule

module subber(
  output [10:0] out,
  output        overflow,
  input  [10:0] a, b
);
  wire cout, cout1;
  wire [9:0] small_sub;

  // Find difference with a carryout bit
  assign {cout, out} = a - b;
  // Find next most significant carryout bit
  assign {cout1, small_sub} = a[9:0] - b[9:0];
  // If the most and next most significant carryout bits are different, overflow
  assign overflow = cout ^ cout1;
endmodule

module multiplier(
  output [10:0] out,
  output        overflow,
  input  [10:0] a, b
);
  wire [10:0] overflow_bits;

  // Find product (of twice the width of inputs)
  assign {overflow_bits, out} = a * b;
  // If any of the first half + 1 of the bits are different, there is overflow
  assign overflow = ^ {overflow_bits, out[10]};
endmodule
