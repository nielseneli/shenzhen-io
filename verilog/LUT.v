`define NOP   7'b0000000
`define MOVRR 7'b0001110
`define MOVRI 7'b0001111
`define JMPI  7'b0010001
`define SLPR  7'b0011010
`define SLPI  7'b0011001
`define ADDR  7'b1000010
`define ADDI  7'b1000001
`define SUBR  7'b1001010
`define SUBI  7'b1001001
`define MULR  7'b1010010
`define MULI  7'b1010001
`define NOT   7'b1011000

module LUT (
	input[31:0] instr,
	output reg wr_en,
	output reg is_slp,
	output reg is_mov,
	output reg is_jmp,
	output reg Aa,
	output reg Aw,
	output reg Da_or_Imm0,
	output reg Db_or_Imm1
	);

always @(instr)
	wr_en = 0;
	is_slp = 0;
	is_mov = 0;
	is_jmp = 0;
	Aa = instr[9:11];
	Aw = instr[9:11];
	Da_or_Imm0 = 0;
	Db_or_Imm1 = 0;

	case (instr[2:8]) begin
		NOP: begin
		end

		MOVRR: begin
			wr_en = 1;
			is_mov = 1;
			Aw = instr[12:14];
		end

		MOVRI: begin
			wr_en = 1;
			is_mov = 1;
			Da_or_Imm0 = 1;
		end

		JMPI: begin
			is_jmp = 1;
		end

		SLPR: begin
			is_slp = 1;
		end

		SLPI: begin
			is_slp = 1;
			Da_or_Imm0 = 1;
		end

		ADDR: begin
			wr_en = 1;
		end

		ADDI: begin
			wr_en = 1;
			Da_or_Imm0 = 1;
		end

		SUBR: begin
			wr_en = 1;
		end

		SUBI: begin
			wr_en = 1;
			Da_or_Imm0 = 1;
		end

		MULR: begin
			wr_en = 1;
		end

		MULI: begin
			wr_en = 1;
			Da_or_Imm0 = 1;
		end

		NOT: begin
			wr_en = 1;
		end


	endcase // instr[2:8]
end

endmodule