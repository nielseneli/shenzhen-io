`include "MC9999.v"

module designx(
input         clk,
input         posedge_big_clk,
input  [10:0] input_signal,
output [10:0] output_signal
);
  // Put any wires for connection here
  wire [10:0] p1to2, p2to1;

  // Devices
  MC9999 dut1(.clk(clk),
        .posedge_big_clk(posedge_big_clk),
        .p0_in(p2to1),
        .p1_in(),
        .p0_out(p1to2),
        .p1_out());

  MC9999 dut2(.clk(clk),
        .posedge_big_clk(posedge_big_clk),
        .p0_in(p1to2),
        .p1_in(),
        .p0_out(p2to1),
        .p1_out(output_signal));

endmodule
