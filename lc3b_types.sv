package lc3b_types;

typedef logic [15:0] lc3b_word;
typedef logic  [7:0] lc3b_byte;

typedef logic  [8:0] lc3b_offset9;
typedef logic  [5:0] lc3b_offset6;
typedef logic  [10:0] lc3b_offset11;
typedef logic  [4:0] lc3b_imm5;
typedef logic  [3:0] lc3b_imm4;
typedef logic  [7:0] lc3b_vect8;

//types for cache 
typedef logic [127:0]lc3b_burst;
typedef logic [11:0] lc3b_tag; 

typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;

typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [3:0] {
    alu_pass,
    alu_add,
    alu_and,
    alu_not,
    alu_sll,
    alu_srl,
    alu_sra
} lc3b_aluop;

typedef struct packed {
	/* Instruction */
	logic[3:0] opcode;
	lc3b_word pc;
	lc3b_word inst;
	lc3b_reg dr_sr;
	lc3b_reg sr1;
	lc3b_reg sr2;
	lc3b_nzp nzp;
	
	/* IF */
	
	/* ID */
	logic sr2_mux_sel;
	logic drmux_sel;
	
	/* EXE*/
	lc3b_aluop aluop;
	logic [1:0] braddmux_sel;
	logic alumux_sel;
	
	/* MEM */
	logic wdatamux_sel;
	logic addrmux_sel;
	logic mem_write;
	logic mem_read;
	logic byte_op;
	logic datamux_sel;
	
	/* WB */
	logic [1:0] pcmux_sel;
	logic regfile_mux_sel;
	logic load_cc;
	logic[1:0] cc_mux_sel;
	logic load_regfile;
} lc3b_ipacket;

endpackage : lc3b_types