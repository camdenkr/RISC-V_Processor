// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Final Project ALU

module ALU (
  input [5:0]  ALU_Control,
  input branch_op,
  input [31:0] operand_A,
  input [31:0] operand_B,
  output [31:0] ALU_result,
  output branch
);

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
reg [31:0] ALU_output;
reg branch_temp;
//assign ALU_result = ALU_output;
//assign branch = branch_temp;

assign ALU_result =  ALU_Control == 6'b000000 ? (operand_A + operand_B) :
                     ALU_Control == 6'b000001 ? (operand_A << operand_B) :
                     ALU_Control == 6'b000010 ? ($signed(operand_A) < $signed(operand_B)) :
                     ALU_Control == 6'b000011 ? (operand_A < operand_B) :
                     ALU_Control == 6'b000100 ? (operand_A ^ operand_B) :
                     ALU_Control == 6'b000101 ? (operand_A >> operand_B) :
                     ALU_Control == 6'b000110 ? (operand_A | operand_B) :
                     ALU_Control == 6'b000111 ? (operand_A & operand_B) :
                     ALU_Control == 6'b001000 ? (operand_A - operand_B) :
                     ALU_Control == 6'b001101 ? (operand_A >>> operand_B) :
                     ALU_Control == 6'b111111 ? (operand_A) :
                     ALU_Control == 6'b011111 ? (operand_A) :
                     operand_A;
                     
assign branch = ALU_Control == 6'b010111 ? ((operand_A >= operand_B) ? 1 : 0) :
                ALU_Control == 6'b010101 ? (($signed(operand_A) >= $signed(operand_B)) ? 1 : 0) :
                ALU_Control == 6'b010100 ? (($signed(operand_A) < $signed(operand_B)) ? 1 : 0) :
                ALU_Control == 6'b010110 ? ((operand_A < operand_B) ? 1 : 0) :
                ALU_Control == 6'b010001 ? ((operand_A != operand_B) ? 1 : 0) :
                ALU_Control == 6'b010000 ? ((operand_A == operand_B) ? 1 : 0):
                0;

endmodule
	
	
	