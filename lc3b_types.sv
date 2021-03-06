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
typedef logic [7:0] lc3b_tag; 	//change the tag bit into 8 bits to increment the cache size
typedef logic [6:0] lc3b_tag_l2; //the level 2 cache tag only have 7 bits 
typedef logic [11:0] lc3b_pc_tag; //the tag bits for pc, total of 
typedef logic [1:0] lc3b_pc_ways; //the pc set index 2 bits for 4 way 

typedef logic  [3:0]  lc3b_cache_offset;
typedef logic  [3:0]  lc3b_set;	//change the set bit into 4 bits to cover total of 16 sets in the cache
typedef logic  [4:0]  lc3b_set_l2; //total of 5 bits to cover 32 sets in l2 cache
typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;
typedef logic  [11:0] lc3b_tag_vc; //addded for new expanded tag bits in fully associative victim cache

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
    op_x  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [3:0] {
    alu_pass,
    alu_add,
	 alu_sub,
    alu_and,
    alu_not,
	 alu_or,
	 alu_xor,
	 alu_mul,
	 alu_div,
    alu_sll,
    alu_srl,
    alu_sra,
	 alu_nor,
	 alu_nand,
	 alu_xnor
} lc3b_aluop;

typedef enum bit[2:0] {
	op_sub,
	op_or,
	op_xor,
	op_mul,
	op_hi_mul,
	op_div,
	op_rem,
	op_count
} lc3x_op;

typedef struct packed {
	/* Instruction */
	logic[3:0] opcode;
	lc3b_word pc;
	lc3b_word inst;
	lc3b_reg dr_sr;
	lc3b_reg sr1;
	lc3b_reg sr2;
	lc3b_nzp nzp;
	
	/* branch prediction bits */
	logic branch; //1 indicate this is a branch (BR, JSR, JSRR, JMP), 0 indicate other instructions 
	logic btb_miss; //1 indicate btb miss fetch, 0 indicate btb hit 
	logic [1:0] ways; //the way offset for branch prediction use
	logic [15:0] target_pc; //the pc target address 
	logic br_prediction; //the branch prediction bit 
	
	/* Hazard detection */
	logic forward; //the instruction has  a register that it is going to update
	logic opA; //The instruction has an data in sr1 that could have data forwarded to it
	logic opB; //The instruction has an data in sr1 that could have data forwarded to it
	
	/* IF */
	
	/* ID */
	logic sr2_mux_sel;
	logic drmux_sel;
	
	/* EXE*/
	lc3b_aluop aluop;
	logic [1:0] braddmux_sel;
	logic alumux_sel;
	logic [3:0] alu_res_sel;
	logic load_alg_reg;
	logic [2:0] op_x_bits;
	logic [1:0] br_res_bits;
	logic [1:0] pc_addr_sel;
	
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
