// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Final Project Decode

module decode #(
  parameter ADDRESS_BITS = 16
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC,
  input [31:0] instruction,

  // Inputs from Execute/ALU
  input [ADDRESS_BITS-1:0] JALR_target,
  input branch,

  // Outputs to Fetch
  output next_PC_select,
  output [ADDRESS_BITS-1:0] target_PC,

  // Outputs to Reg File
  output [4:0] read_sel1,
  output [4:0] read_sel2,
  output [4:0] write_sel,
  output wEn,

  // Outputs to Execute/ALU
  output branch_op, // Tells ALU if this is a branch instruction
  output [31:0] imm32,
  output [1:0] op_A_sel,
  output op_B_sel,
  output [5:0] ALU_Control,

  // Outputs to Memory
  output mem_wEn,

  // Outputs to Writeback
  output wb_sel

);

localparam [6:0]R_TYPE  = 7'b0110011,
                I_TYPE  = 7'b0010011,
                STORE   = 7'b0100011,
                LOAD    = 7'b0000011,
                BRANCH  = 7'b1100011,
                JALR    = 7'b1100111,
                JAL     = 7'b1101111,
                AUIPC   = 7'b0010111,
                LUI     = 7'b0110111;


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.
wire[6:0]  s_imm_msb;
wire[4:0]  s_imm_lsb;
wire[19:0] u_imm;
wire[11:0] i_imm_orig;
wire[19:0] uj_imm;
wire[11:0] s_imm_orig;
wire[12:0] sb_imm_orig;

wire[31:0] sb_imm_32;
wire[31:0] u_imm_32;
wire[31:0] i_imm_32;
wire[31:0] s_imm_32;
wire[31:0] uj_imm_32;

wire [4:0] shamt;
wire[31:0] shamt32;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target;
wire [ADDRESS_BITS-1:0] JAL_target;


// Read registers
assign read_sel2  = instruction[24:20];
assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
assign i_imm_orig = instruction[31:20];
assign i_imm_32 = {{20{i_imm_orig[11]}}, i_imm_orig};
assign shamt = i_imm_orig[4:0];
assign shamt32 = {{27{1'b0}},shamt};

assign u_imm = instruction[31:12];
assign u_imm_32 = {u_imm, 12'b0};
assign uj_imm = {instruction[31],instruction[19:12],instruction[20],instruction[30:21]};
assign uj_imm_32 = {{11{uj_imm[19]}}, uj_imm , 1'b0};

assign s_imm_lsb = instruction[11:7];
assign s_imm_msb = instruction[31:25];
assign s_imm_orig = {s_imm_msb,s_imm_lsb};
assign s_imm_32 = {{20{s_imm_orig[11]}}, s_imm_orig};
assign sb_imm_orig = {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
assign sb_imm_32 = {{19{sb_imm_orig[12]}}, sb_imm_orig};

assign branch_target = PC + {{3{sb_imm_orig[12]}},sb_imm_orig};
assign JAL_target = PC + uj_imm_32[15:0];

assign ALU_Control =  (opcode == R_TYPE && funct3 == 3'b001) ? 6'b000001 :
                   (opcode == R_TYPE && funct3 == 3'b010) ? 6'b000010 :
                   (opcode == R_TYPE && funct3 == 3'b011) ? 6'b000010 :
                   (opcode == R_TYPE && funct3 == 3'b100) ? 6'b000100 :
                   (opcode == R_TYPE && funct3 == 3'b110) ? 6'b000110 :
                   (opcode == R_TYPE && funct3 == 3'b111) ? 6'b000111 :
                   (opcode == R_TYPE && funct3 == 3'b000 && funct7 == 7'b0000000) ? 6'b000000 :
                   (opcode == R_TYPE && funct3 == 3'b000 && funct7 == 7'b0100000) ? 6'b001000 :
                   (opcode == R_TYPE && funct3 == 3'b101 && funct7 == 7'b0100000) ? 6'b001101 :
                   (opcode == R_TYPE && funct3 == 3'b101 && funct7 == 7'b0000000) ? 6'b000101 :
                   
                    (opcode == JALR) ? 6'b111111 :
                    (opcode == JAL) ? 6'b011111 :
                    (opcode == AUIPC) ? 6'b000000 :
                    (opcode == LUI) ? 6'b000000 :
                    (opcode == STORE) ? 6'b000000 :
                    (opcode == LOAD) ? 6'b000000 :
                   
                    (opcode == I_TYPE && funct3 ==  3'b000) ? 6'b000000 :
                    (opcode == I_TYPE && funct3 ==  3'b010) ? 6'b000011 :
                    (opcode == I_TYPE && funct3 ==  3'b011) ? 6'b000011 :
                    (opcode == I_TYPE && funct3 ==  3'b100) ? 6'b000100 :
                    (opcode == I_TYPE && funct3 ==  3'b110) ? 6'b000110 :
                    (opcode == I_TYPE && funct3 ==  3'b111) ? 6'b000111 :
                    (opcode == I_TYPE && funct3 ==  3'b001) ? 6'b000001 :
                    (opcode == I_TYPE && funct3 ==  3'b101 && funct7 == 7'b0000000) ? 6'b000101 :
                    (opcode == I_TYPE && funct3 ==  3'b101 && funct7 == 7'b0100000) ? 6'b001101 :
                   
                    (opcode == BRANCH && funct3 == 3'b000) ? 6'b010000 :
                    (opcode == BRANCH && funct3 == 3'b001) ? 6'b010001 :
                    (opcode == BRANCH && funct3 == 3'b100) ? 6'b010100 :
                    (opcode == BRANCH && funct3 == 3'b101) ? 6'b010101 :
                    (opcode == BRANCH && funct3 == 3'b110) ? 6'b010110 :
                    (opcode == BRANCH && funct3 == 3'b111) ? 6'b010111 :
                    6'b111111;
                                                             
        assign imm32 = (opcode == I_TYPE) && (funct3 == 3'b001 || funct3 == 3'b101) ? shamt32 :
                       (opcode == I_TYPE || opcode == LOAD || opcode == JALR) ? i_imm_32 :
                       (opcode == AUIPC || opcode == LUI) ? u_imm_32 :
                       (opcode == BRANCH) ? sb_imm_32 :
                       (opcode == STORE) ? s_imm_32 :
                        uj_imm_32;                                                                                                       
                       
       
       assign next_PC_select = (opcode == R_TYPE) ? 1'b0 :
                               (opcode == I_TYPE) ? 1'b0 :
                               (opcode == STORE ) ? 1'b0 :
                               (opcode == LOAD) ? 1'b0 :
                               (branch == 1'b1) ? 1'b1 :
                               (opcode == JALR) ? 1'b1:
                               (opcode == JAL) ? 1'b1 :
                               (opcode == AUIPC) ? 1'b0 :
                               (opcode == LUI) ? 1'b0 :
                               1'b0;
                                 
  
        
       assign target_PC = (opcode == R_TYPE) ? branch_target :
                        (opcode == I_TYPE) ? branch_target :
                        (opcode == STORE ) ? branch_target :
                        (opcode == LOAD) ? branch_target :
                        (opcode == BRANCH) ? branch_target :
                        (opcode == JAL) ? JAL_target :
                        (opcode == JALR) ? JALR_target : 
                        (opcode == AUIPC) ? branch_target :
                        (opcode == LUI) ? branch_target :
                         branch_target;
                                
       assign read_sel1 = instruction[19:15];
       assign read_sel2 = instruction[24:20];
       assign write_sel = instruction[11:7];
       
       assign wEn = (opcode == R_TYPE) ? 1'b1 :
                   (opcode == I_TYPE) ? 1'b1 :
                   (opcode == STORE ) ? 1'b0 :
                   (opcode == LOAD) ? 1'b1 :
                   (opcode == BRANCH) ? 1'b0:
                   (opcode == JALR) ? 1'b1:
                   (opcode == JAL) ? 1'b1 :
                   (opcode == AUIPC) ? 1'b1 :
                   (opcode == LUI) ? 1'b1 :
                    1'b1;
        
       assign branch_op = (opcode == R_TYPE) ? 1'b0 :
                           (opcode == I_TYPE) ? 1'b0 :
                           (opcode == STORE ) ? 1'b0 :
                           (opcode == LOAD) ? 1'b0 :
                           (opcode == BRANCH) ? 1'b1:
                           (opcode == JALR) ? 1'b0:
                           (opcode == JAL) ? 1'b0 :
                           (opcode == AUIPC) ? 1'b0 :
                           (opcode == LUI) ? 1'b0 :
                            1'b0;
       
       assign mem_wEn = (opcode == R_TYPE) ? 1'b0 :
                        (opcode == I_TYPE) ? 1'b0 :
                        (opcode == STORE ) ? 1'b1 :
                        (opcode == LOAD) ? 1'b0 :
                        (opcode == BRANCH) ? 1'b0:
                        (opcode == JALR) ? 1'b0:
                        (opcode == JAL) ? 1'b0 :
                        (opcode == AUIPC) ? 1'b0:
                        (opcode == LUI) ? 1'b0:
                        1'b0;
       
                                             
         assign op_A_sel = (opcode == R_TYPE) ? 2'b00 :
                           (opcode == I_TYPE) ? 2'b00 :
                           (opcode == STORE ) ? 2'b00 :
                           (opcode == LOAD) ? 2'b00 :
                           (opcode == BRANCH) ? 2'b00:
                           (opcode == JALR) ? 2'b10:
                           (opcode == JAL) ? 2'b10 :
                           (opcode == AUIPC) ? 2'b01 :
                           (opcode == LUI) ? 2'b11 :
                            2'b00;
                                          
        assign op_B_sel = (opcode == R_TYPE) ? 1'b0 :
                          (opcode == I_TYPE) ? 1'b1 :
                          (opcode == STORE ) ? 1'b1 :
                          (opcode == LOAD) ? 1'b1 :
                          (opcode == BRANCH) ? 1'b0:
                          (opcode == JALR) ? 1'b1:
                          (opcode == JAL) ? 1'b1 :
                          (opcode == AUIPC) ? 1'b1 :
                          (opcode == LUI) ? 1'b1 :
                          1'b1;
                         
      assign wb_sel = (opcode == R_TYPE) ? 1'b0 :
                       (opcode == I_TYPE) ? 1'b0 :
                       (opcode == STORE ) ? 1'b0 :
                       (opcode == LOAD) ? 1'b1 :
                       (opcode == BRANCH) ? 1'b0:
                       (opcode == JALR) ? 1'b0:
                       (opcode == JAL) ? 1'b0 :
                       (opcode == AUIPC) ? 1'b0:
                       (opcode == LUI) ? 1'b0:
                       1'b0;
                                       

endmodule