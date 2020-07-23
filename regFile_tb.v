// Name: Camden Kronhaus and Elisabeth Garfield
// BU ID: U79620042 , U80766634
// EC413 Project Register File Test Bench

module regFile_tb();

reg clock, reset;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
reg[4:0] read_sel1,read_sel2, write_sel;
reg wEn;
reg[31:0] write_data;
wire[31:0] read_data1, read_data2;



// Fill in port connections
regFile uut (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


always #5 clock = ~clock;

initial begin
  clock = 1'b1;
  reset = 1'b1;

  #20;
  reset = 1'b0;
  
    write_sel  <= 5'b0110;  
    write_data <= 32'b0010_0100_0000_0100;
    wEn      <= 1'b1;
  
    #20
    
    write_sel  <= 5'b00101;  
    write_data <= 32'b1111_0000_0000_0000;
    wEn      <= 0'b1;
    read_sel1  <= 5'b00111; 
    read_sel2  <= 5'b10111; 
  
    #20
  
    read_sel1  <= 5'b11111; 
    read_sel2  <= 5'b00000; 
  
  
  
    #20
        
    write_sel  <= 5'b00101;  
    write_data <= 32'b1111_0000_0000_0000;
    wEn      <= 0'b1;
    read_sel1  <= 5'b00111; 
    read_sel2  <= 5'b10111; 
    
    
    #20
            
        write_sel  <= 5'b10101;  
        write_data <= 32'b1111_0000_1100_1111;
        wEn      <= 0'b1;
        read_sel1  <= 5'b00000; 
        read_sel2  <= 5'b10000; 

  // Test reads and writes to the register file here
  
  
  
  
  
  
end
endmodule