`include "verilog/MC9999.v"

module designB(
input         clk,
input         posedge_big_clk,
input  [10:0] input_signal,
output [10:0] output_signal
);
  // Put any wires for connection here

  // Devices
  MC9999 dut2(.clk(clk),
        .posedge_big_clk(posedge_big_clk),
        .p0_in(),
        .p1_in(),
        .x0_in(),
        .x1_in(),
        .x0_write_in(),
        .x1_write_in(),
        .x0_read_in(),
        .x1_read_in(),

        .x0_out(),
        .x1_out(),
        .x0_write_out(),
        .x1_write_out(),
        .x0_read_out(),
        .x1_read_out(),
        .p0_out(output_signal),
        .p1_out());

endmodule

module designA(
input         clk,
input         posedge_big_clk,
input  [10:0] input_signal,
output [10:0] output_signal
);
  // Put any wires for connection here
  wire [10:0] dut0_x0_to_dut1_x0, dut1_x0_to_dut0_x0;
  wire dut0_x0_read_to_dut1_x0_read, dut0_x0_write_to_dut1_x0_write;
  wire dut1_x0_read_to_dut0_x0_read, dut1_x0_write_to_dut0_x0_write;

  // Devices
  MC9999 dut0(.clk(clk),
        .posedge_big_clk(posedge_big_clk),
        .p0_in(),
        .p1_in(),
        .x0_in(dut1_x0_to_dut0_x0),
        .x1_in(),
        .x0_write_in(dut1_x0_write_to_dut0_x0_write),
        .x1_write_in(),
        .x0_read_in(dut1_x0_read_to_dut0_x0_read),
        .x1_read_in(),

        .x0_out(dut0_x0_to_dut1_x0),
        .x1_out(),
        .x0_write_out(dut0_x0_write_to_dut1_x0_write),
        .x1_write_out(),
        .x0_read_out(dut0_x0_read_to_dut1_x0_read),
        .x1_read_out(),
        .p0_out(),
        .p1_out());

  MC9999 dut1(.clk(clk),
        .posedge_big_clk(posedge_big_clk),
        .p0_in(),
        .p1_in(),
        .x0_in(dut0_x0_to_dut1_x0),
        .x1_in(),
        .x0_write_in(dut0_x0_write_to_dut1_x0_write),
        .x1_write_in(),
        .x0_read_in(dut0_x0_read_to_dut1_x0_read),
        .x1_read_in(),

        .x0_out(dut1_x0_to_dut0_x0),
        .x1_out(),
        .x0_write_out(dut1_x0_write_to_dut0_x0_write),
        .x1_write_out(),
        .x0_read_out(dut1_x0_read_to_dut0_x0_read),
        .x1_read_out(),
        .p0_out(output_signal),
        .p1_out());

endmodule
