// Reused code from Coleman and Paige's Lab 4

module mux
#(
	parameter data_width = 32
)
(
output[data_width-1:0]  out,
input         sel,
input[data_width-1:0]   input0, input1
);

  wire[data_width-1:0] mux[1:0];			// Create a 2D array of wires
  assign mux[0]  = input0;		// Connect the sources of the array
  assign mux[1]  = input1;
  assign out = mux[sel];	// Connect the output of the array
endmodule
