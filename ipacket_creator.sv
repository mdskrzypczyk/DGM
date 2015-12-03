import lc3b_types::*;

module ipacket_creator
(
	input lc3b_word inst,
	input lc3b_word pc,
	
	output lc3b_ipacket ipacket
);

always_comb
begin

	/* Default Assignments */
	/* Instruction */
	ipacket.opcode = inst[15:12];
	ipacket.pc = pc+16'h2;
	ipacket.inst = inst;
	ipacket.dr_sr = inst[11:9];
	ipacket.sr1 = inst[8:6];
	ipacket.sr2 = inst[2:0];
	ipacket.nzp = inst[11:9];
	
	/* Forwarding */
	ipacket.forward = 0;
	ipacket.opA = 0;
	ipacket.opB = 0;
	
	/* IF */
	
	/* ID */
	ipacket.sr2_mux_sel = 1'b0;
	ipacket.drmux_sel = 1'b0;
	
	/* EXE*/
	ipacket.aluop = alu_pass;
	ipacket.braddmux_sel = 2'b0;
	ipacket.alumux_sel = 1'b0;
	ipacket.alu_res_sel = 4'b0000;
	ipacket.load_alg_reg = 0;
	ipacket.op_x_bits = 3'b000;
	
	/* MEM */
	ipacket.wdatamux_sel = 1'b0;
	ipacket.addrmux_sel = 1'b0;
	ipacket.mem_write = 1'b0;
	ipacket.mem_read = 1'b0;
	ipacket.byte_op = 1'b0;
	ipacket.datamux_sel = 1'b0;
	
	/* WB */
	ipacket.pcmux_sel = 2'b0;
	ipacket.regfile_mux_sel = 1'b0;
	ipacket.load_cc = 1'b0;
	ipacket.cc_mux_sel =  2'b0;
	ipacket.load_regfile = 1'b0;
	
	/* Assign ipacket based on opcode */
	case(inst[15:12])
		op_add : begin
			ipacket.aluop = alu_add;
			ipacket.alumux_sel = inst[5];
			ipacket.load_cc = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.load_regfile = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
			if(inst[5] == 1'b0)
			begin
				ipacket.opB = 1'b1;
			end
		end
		
		op_and : begin
			ipacket.aluop = alu_and;
			ipacket.alumux_sel = inst[5];
			ipacket.load_cc = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.load_regfile = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
			if(inst[5] == 1'b0)
			begin
				ipacket.opB = 1'b1;
			end

		end
		
		op_jmp : begin
			ipacket.pcmux_sel = 2'b01;
			ipacket.opA = 1'b1;
		end
		
		op_jsr : begin
			ipacket.load_regfile = 1'b1;
			ipacket.dr_sr = 3'b111;
			ipacket.regfile_mux_sel = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.pcmux_sel = 2'b01;
			ipacket.opA = 1'b1;
			ipacket.forward = 1'b1; 
			
			if(inst[11])
			begin
				ipacket.pcmux_sel = 2'b10;
				ipacket.cc_mux_sel = 2'b10;
			end
		end
		
		op_ldb : begin
			ipacket.byte_op = 1'b1;
			ipacket.load_cc = 1'b1;
			ipacket.alumux_sel = 1'b1;
			ipacket.load_regfile = 1'b1;
			ipacket.cc_mux_sel = 2'b01;
			ipacket.aluop = alu_add;
			ipacket.mem_read = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
		end
		
		op_ldi : begin
			ipacket.load_cc = 1'b1;
			ipacket.alumux_sel = 1'b1;
			ipacket.load_regfile = 1'b1;
			ipacket.cc_mux_sel = 2'b01;
			ipacket.aluop = alu_add;
			ipacket.mem_read = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
		end
		
		op_ldr : begin
			ipacket.load_cc = 1'b1;
			ipacket.alumux_sel = 1'b1;
			ipacket.load_regfile = 1'b1;
			ipacket.cc_mux_sel = 2'b01;
			ipacket.aluop = alu_add;
			ipacket.mem_read = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
		end
		
		op_lea : begin
			ipacket.load_regfile = 1'b1;
			ipacket.wdatamux_sel = 1'b1;
			ipacket.cc_mux_sel = 2'b10;
			ipacket.load_cc = 1'b1;
			ipacket.forward = 1'b1;
		end
		
		op_not : begin
			ipacket.aluop = alu_not;
			ipacket.load_cc = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.load_regfile = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
			ipacket.opB = 1'b1;
			case(inst[5:3])
				3'b000: ipacket.aluop = alu_nor;
				3'b001: ipacket.aluop = alu_nand;
				3'b010: ipacket.aluop = alu_xnor;
				default : ;
			endcase
		end
		
		op_shf : begin
			ipacket.load_cc = 1'b1;
			ipacket.load_regfile = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.alumux_sel = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
			case(inst[5:4])
				2'b00 :
					ipacket.aluop = alu_sll;
				2'b10 : 
					ipacket.aluop = alu_sll;
				2'b01 :
					ipacket.aluop = alu_srl;
				2'b11 :
					ipacket.aluop = alu_sra;
			endcase
		end
		
		op_stb : begin
			ipacket.byte_op = 1'b1;
			ipacket.alumux_sel = 1'b1;
			ipacket.aluop = alu_add;
			ipacket.mem_write = 1'b1;
			ipacket.datamux_sel = 1'b1;
			ipacket.sr2_mux_sel = 1'b1;
			ipacket.opA = 1'b1;
		
		end
		op_sti : begin
			ipacket.alumux_sel = 1'b1;
			ipacket.aluop = alu_add;
			ipacket.mem_write = 1'b1;
			ipacket.datamux_sel = 1'b1;		
		   ipacket.sr2_mux_sel = 1'b1;
			ipacket.opA = 1'b1;
		end
		
		op_str:begin 
			ipacket.alumux_sel = 1'b1;
			ipacket.aluop = alu_add;
			ipacket.mem_write=1'b1;
			ipacket.datamux_sel = 1'b1;
			ipacket.sr2_mux_sel = 1'b1;
			ipacket.opA = 1'b1;
		end 
		
		op_trap : begin
			ipacket.wdatamux_sel = 1'b1;
			ipacket.braddmux_sel = 2'b11;
			ipacket.load_regfile = 1'b1;
			ipacket.regfile_mux_sel = 1'b1;
			ipacket.cc_mux_sel = 2'b01;
			ipacket.pcmux_sel = 2'b01;
			ipacket.mem_read = 1'b1;		
		   ipacket.drmux_sel = 1'b1;	
			ipacket.dr_sr = 3'b111;
			ipacket.forward = 1'b1;
		end
		
		op_x : begin
			ipacket.load_cc = 1'b1;
			ipacket.cc_mux_sel = 2'b0;
			ipacket.load_regfile = 1'b1;
			ipacket.forward = 1'b1;
			ipacket.opA = 1'b1;
			ipacket.opB = 1'b1;
			case(inst[5:3])
				op_sub : ipacket.aluop = alu_sub;
				op_or : ipacket.aluop = alu_or;
				op_xor : ipacket.aluop = alu_xor;
				op_mul : begin
					ipacket.alu_res_sel = 4'b1001;
					ipacket.load_alg_reg = 1;
					ipacket.op_x_bits = inst[5:3];
				end
				op_hi_mul: ipacket.alu_res_sel = 4'b1010;
				op_div : begin
					ipacket.alu_res_sel = 4'b1001;
					ipacket.load_alg_reg = 1;
					ipacket.op_x_bits = inst[5:3];
				end
				op_rem : ipacket.alu_res_sel = 4'b1010;
				op_count : ipacket.alu_res_sel = {1'b0, {inst[2:0]}}; 
				default : ;
			endcase
		end
		
		default: begin 
		
		end
	endcase
end
endmodule : ipacket_creator