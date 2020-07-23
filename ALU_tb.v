// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Project ALU Test Bench

module ALU_tb();
reg branch_op;
reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;
wire branch;

ALU dut (
.branch_op(branch_op),
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result),
  .branch(branch)
);

initial begin
  branch_op = 1'b0;
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #10
  $display("ALU Result 4 + 5: %d",result);
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU Result 4 < 5: %d",result);
  #10
  opB = 32'hffffffff;
  #10
  $display("ALU Result 4 < -1: %d",result);

  // Add other test cases here
  //
  //
  //
 
  #10
  ctrl =  6'b000001;
 
  #10
 
  $display("ALU Result 4 shifted left: %d", result);
  #10
 
  ctrl = 6'b111111;
 
  #10
 
  $display("ALU Result 4 (should be 4?): %d", result);
 
  #10
 
  opB = 9;
 
  ctrl = 6'b010110;
  #10
 
  $display("Branch (should be 1): %b", branch);
 
  #10
  ctrl = 6'b000010;
  opB = -5;
  #10
  $display("ALU Result 4 < -5 (should be 0): %d", result);
  #10
  opB = -5;
  ctrl = 6'b000011;
  #10
  $display("ALU Result 4 < -5(should be 1): %d", result);
  #10
    branch_op = 1'b1;
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b010_000; // BEQ
  #10
  $display("ALU Result (BEQ): %d",result);
  $display("Branch (should be 1): %b", branch);
 
  #10

$stop();  
 
 
end

endmodule