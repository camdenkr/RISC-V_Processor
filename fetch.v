// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Project Fetch

module fetch #(
  parameter ADDRESS_BITS = 16
) (
  input  clock,
  input  reset,
  input  next_PC_select,
  input  [ADDRESS_BITS-1:0] target_PC,
  output [ADDRESS_BITS-1:0] PC
);

reg [ADDRESS_BITS-1:0] PC_reg;

assign PC = PC_reg;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
always@(posedge reset)
begin
    PC_reg <= 0;
end

always@(posedge clock)
begin
    if(next_PC_select == 0)
        PC_reg = PC_reg+4;
    else
        PC_reg = target_PC;
end



endmodule