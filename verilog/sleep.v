module sleep (
	input[10:0] sleep_val,
	input input_flag,
	input clk,
	input posedge_big_clk,
	output reg output_flag
);

reg is_sleeping = 0; //state
reg[10:0] counter = 11'b0;

always @(posedge clk) begin
	if (input_flag && ~is_sleeping) begin // If we're not sleeping and are told to
		is_sleeping = 1;                  // Start sleeping
		counter = sleep_val;              // Store how long to sleep
	end
	else if (posedge_big_clk && counter != 11'b0 && is_sleeping) // If we're still sleeping
		counter = counter - 1;                                   // Count down
	
	if (posedge_big_clk && counter == 11'b0 && is_sleeping) // If we're done sleeping
		is_sleeping = 0;                                         // Stop sleeping
end

always @(is_sleeping)
	output_flag = is_sleeping;

endmodule