`define ADDMODULE 4'b1000
`define SUBMODULE 4'b1001
`define MULMODULE 4'b1010
`define NOTMODULE 4'b1011
`define SLTMODULE 4'b1110
`define SGTMODULE 4'b1101

// http://www.ece.lsu.edu/ee3755/2012f/l05.v.html - add/sub overflow detection

module alu (
input signed [10:0]      in0,
                         in1,
input [3:0]              funct,
output reg signed [10:0] out,
output reg               overflow,
output wire              gr_flag,
                         le_flag,
                         eq_flag
);
  wire [10:0] sum, difference, product, not_out;
  // wire add_of = 0;
  // wire sub_of = 0;
  // wire prod_of = 0;
  wire not_of = 0;

  adder add_module(.out(sum),
              .overflow(add_of),
              .a(in0),
              .b(in1));

  subber sub_module(.out(difference),
              .overflow(sub_of),
              .b(in0),
              .a(in1));

  multiplier mul_module(.out(product),
              .overflow(prod_of),
              .a(in0),
              .b(in1));

  // If in0 is all 0s, then out = 127, else out = 0
  assign not_out = ~| in0 ? 11'd127 : 11'b0;

  always @(*) begin
    case (funct)
      `ADDMODULE: begin
        out = sum;
        overflow = add_of;
      end
      `SUBMODULE: begin
        out = difference;
        overflow = sub_of;
      end
      `MULMODULE: begin
        out = product;
        overflow = prod_of;
      end
      `NOTMODULE: begin
        out = not_out;
        overflow = not_of;
      end
      default: begin
        out = 0;
        overflow = 0;
      end
    endcase
  end

  // FLAGS
  // If the difference is all 0s, the inputs were equal
  assign eq_flag = (in0 === in1);
  // If the difference is negative, in0 < in1
  assign le_flag = (in0 < in1);
  // If the difference is positive and not all zeros, in0 > in1
  assign gr_flag = (in0 > in1);
endmodule

module adder(
  output signed [10:0] out,
  output        overflow,
  input signed [10:0] a, b
);
  wire cout, cin;
  wire [9:0] small_sum;
  wire [10:0] small_a, small_b;

  // Find sum with a carryout bit
  assign {cout, out} = {1'b0, a} + {1'b0, b};
  // Find next most significant carryout bit
  assign small_a = {1'b0, a[9:0]};
  assign small_b = {1'b0, b[9:0]};
  assign {cin, small_sum} = small_a + small_b;

  // assign {cin, small_sum} = {a[9], a[9:0]} + {b[9], b[9:0]};
  // If the most and next most significant carryout bits are different, overflow
  assign overflow = cout ^ cin;
endmodule

module subber(
  output signed [10:0] out,
  output        overflow,
  input signed [10:0] a, b
);
  wire cout, cout1;
  wire [9:0] small_sub;

  // Find difference with a carryout bit
  assign {cout, out} = {1'b0, a} - {1'b0, b};
  // Find next most significant carryout bit
  assign {cout1, small_sub} = {1'b0, a[9:0]} - {1'b0, b[9:0]};
  // If the most and next most significant carryout bits are different, overflow
  assign overflow = cout ^ cout1;
endmodule

module multiplier(
  output signed [10:0] out,
  output        overflow,
  input signed [10:0] a, b
);
  wire [10:0] overflow_bits;

  // Find product (of twice the width of inputs)
  assign {overflow_bits, out} = a * b;
  // If any of the first half + 1 of the bits are different, there is overflow
  assign overflow = ~((~| {overflow_bits, out[10]}) || (& {overflow_bits, out[10]}));
endmodule
