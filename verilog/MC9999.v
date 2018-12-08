`include "mux.v"
`include "sleep.v"
`include "datamemory.v"
`include "LUT.v"
`include "registers.v"
`include "alu.v"

module MC9999 (
	input clk,
	input posedge_big_clk,
	input[10:0] p0_in,
	input[10:0] p1_in,

	output[10:0] p0_out,
	output[10:0] p1_out
);


//Program counter logic
reg[3:0] program_counter = 0;
wire[3:0] next_program_counter;
wire wr_en, is_slp, is_mov, is_jmp, is_cond, Da_or_Imm0, Db_or_Imm, Imm0_or_Imm1;
wire[2:0] Aa, Ab, Aw;
wire sleep_output;
wire[10:0] Da_or_Imm0_val, Db_or_Imm_val;
wire[10:0] Imm0, Imm1;

always @(posedge clk) begin
	if (~sleep_output) program_counter <= next_program_counter;
end // always @(posedge clk)


mux #(4) nextProgramCounterMux(
	.input0(program_counter + 4'b0001),
	.input1(final_instruction[3:0]),
	.out(next_program_counter),
	.sel(is_jmp)
	);

//Sleep
sleep sleep(
	.sleep_val(Da_or_Imm0_val),
	.input_flag(is_slp),
	.clk(clk),
	.posedge_big_clk(posedge_big_clk),
	.output_flag(sleep_output));


//Instruction Memory
wire[30:0] fetched_instruction, final_instruction;
assign Imm0 = final_instruction[10:0];
assign Imm1 = final_instruction[19:9];
datamemory #(4, 2**4, 31) instructionMemory(
	.clk(clk),
	.dataOut(fetched_instruction),
	.address(program_counter),
	.writeEnable(1'b0),
	.dataIn(31'b0));

reg noop_sel = 0;
reg[1:0] cond = 2'b0;
wire[1:0] instr_cond;
assign instr_cond = fetched_instruction[30:29];
always @(*) begin
	if (sleep_output)
		noop_sel=1;
	else if (instr_cond != 2'b00 && instr_cond != cond)
		noop_sel = 1;
	else
		noop_sel=0;
end
mux #(31) noOPMux(
	.input0(fetched_instruction),
	.input1(31'b0),
	.out(final_instruction),
	.sel(noop_sel));


//LUT
LUT LUT(
	.instr(final_instruction),
	.wr_en(wr_en),
	.is_slp(is_slp),
	.is_mov(is_mov),
	.is_jmp(is_jmp),
	.is_cond(is_cond),
	.Aa(Aa),
	.Ab(Ab),
	.Aw(Aw),
	.Da_or_Imm0(Da_or_Imm0),
	.Db_or_Imm(Db_or_Imm),
	.Imm0_or_Imm1(Imm0_or_Imm1));

//Regfile
wire[10:0] write_dat, Da, Db;
wire[2:0] write_addr;

MC3999regFile regFile(
	.write_dat(write_dat),
	.write_addr(write_addr),
	.write_en(wr_en),
	.p0_in(p0_in),
	.p1_in(p1_in),
	.read_addr0(Aa),
	.read_addr1(Ab), //acc
	.clk(clk),

	.p0_out(p0_out),
	.p1_out(p1_out),
	.dat_out0(Da),
	.dat_out1(Db));

mux #(3) writeAddrMux(
	.input0(3'b000),
	.input1(Aw),
	.out(write_addr),
	.sel(is_mov));


//ALU logic
mux #(11) DaMux(
	.input0(Da),
	.input1(final_instruction[10:0]), //Imm0
	.sel(Da_or_Imm0),
	.out(Da_or_Imm0_val));

wire[10:0] Imm0_or_Imm1_val;
mux #(11) Imm0orImm1Mux(
	.input0(Imm0),
	.input1(Imm1),
	.sel(Imm0_or_Imm1),
	.out(Imm0_or_Imm1_val));

mux #(11) DbMux(
	.input0(Db),
	.input1(Imm0_or_Imm1_val),
	.sel(Db_or_Imm),
	.out(Db_or_Imm_val));

wire overflow;
wire[10:0] alu_result;
wire[1:0] alu_cond_result;
alu ALU(
	.in0(Da_or_Imm0_val),
	.in1(Db_or_Imm_val),
	.funct(final_instruction[25:22]), //funct
	.out(alu_result),
	.overflow(overflow),
	.cond_flag(alu_cond_result));

mux #(11) aluResultMux(
	.input0(alu_result),
	.input1(Da_or_Imm0_val),
	.sel(is_mov),
	.out(write_dat));

always @(posedge clk) begin
	if (is_cond)
		cond = alu_cond_result;
end
endmodule