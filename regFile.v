// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Lab 2 Problem 1: reg_file

module regFile (
  input clock,
  input reset,
  input wEn, // Write Enable
  input [31:0] write_data,
  input [4:0] read_sel1,
  input [4:0] read_sel2,
  input [4:0] write_sel,
  output [31:0] read_data1, 
  output [31:0] read_data2
) ;

reg   [31:0] reg_file[0:31];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
    integer i;
    assign read_data1 = reg_file[read_sel1];
	assign read_data2 = reg_file[read_sel2];

always @(posedge clock) begin
	if(reset)
	begin
	   for(i=0; i<32; i = i+1)
	   begin
	       reg_file[i] = 0;
	   end	 
	end
	if(wEn && write_sel != 0)
	begin
		reg_file[write_sel] <= write_data;
	end
	
end

endmodule