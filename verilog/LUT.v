`define NOP   7'b0000000
`define MOVRR 7'b1100001
`define MOVRI 7'b1110001
`define JMPI  7'b0010010
`define SLPR  7'b0100011
`define SLPI  7'b0010011
`define ADDR  7'b0101000
`define ADDI  7'b0011000
`define SUBR  7'b0101001
`define SUBI  7'b0011001
`define MULR  7'b0101010
`define MULI  7'b0011010
`define NOT   7'b0001011

`define TEQ 4'b1100
`define TGT 4'b1101
`define TLT 4'b1110

`define RR 3'b110
`define RI 3'b111
`define II 3'b101

module LUT (
	input[30:0] instr,
	output reg wr_en,
	output reg is_slp,
	output reg is_mov,
	output reg is_jmp,
	output reg[2:0] Aa,
	output reg[2:0] Ab,
	output reg[2:0] Aw,
	output reg Da_or_Imm0,
	output reg Db_or_Imm,
	output reg Imm0_or_Imm1,
	output reg is_cond,
	output reg instr_cond
	);

always @(instr) begin

	case (instr[28:22])
		`NOP: begin
			wr_en = 0;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`MOVRR: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 1;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = instr[18:16];
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`MOVRI: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 1;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = instr[21:19];
			Da_or_Imm0 = 1;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`JMPI: begin
			wr_en = 0;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 1;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`SLPR: begin
			wr_en = 0;
			is_slp = 1;
			is_mov = 0;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`SLPI: begin
			wr_en = 0;
			is_slp = 1;
			is_mov = 0;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 1;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`ADDR: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`ADDI: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 1;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`SUBR: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`SUBI: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 1;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`MULR: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`MULI: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = 3'b000;
			Aw = 3'b0;
			Da_or_Imm0 = 1;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end

		`NOT: begin
			wr_en = 1;
			is_slp = 0;
			is_mov = 0;
			is_jmp = 0;
			Aa = instr[21:19];
			Aw = 3'b0;
			Da_or_Imm0 = 0;
			Db_or_Imm = 0;
			Ab = 3'b000;
			Imm0_or_Imm1 = 0;
			is_cond = 0;
		end
	endcase // instr[2:8]

	if (instr[25:22] == `TEQ || instr[25:22] == `TLT || instr[25:22] == `TGT) begin
		case(instr[28:26])

			`RR: begin
				wr_en = 0;
				is_slp = 0;
				is_mov = 0;
				is_jmp = 0;
				Aa = instr[21:19];
				Aw = 3'b0;
				Da_or_Imm0 = 0;
				Db_or_Imm = 0;
				Ab = instr[18:16];
				Imm0_or_Imm1 = 0;
				is_cond = 1;
			end

			`RI: begin
				wr_en = 0;
				is_slp = 0;
				is_mov = 0;
				is_jmp = 0;
				Aa = instr[21:19];
				Aw = 3'b0;
				Da_or_Imm0 = 0;
				Db_or_Imm = 1;
				Ab = instr[18:16];
				Imm0_or_Imm1 = 0;
				is_cond = 1;
			end

			`II: begin
				wr_en = 0;
				is_slp = 0;
				is_mov = 0;
				is_jmp = 0;
				Aa = 3'b000;
				Aw = 3'b0;
				Da_or_Imm0 = 1;
				Db_or_Imm = 0;
				Ab = instr[18:16];
				Imm0_or_Imm1 = 1;
				is_cond = 1;
			end
		endcase
	end
end

endmodule