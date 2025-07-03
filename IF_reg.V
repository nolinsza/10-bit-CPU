module IF_reg(
 output reg [9:0] instruction_out, PC_out,
 input wire clk, reset, cache_Ready,
 input wire [9:0] instruction_in, PC_in);

 always @(negedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        instruction_out <= 10'b0000000000; //output is 0 if reset bit is high
        PC_out  <= 10'b0;
        
        
     end
     else if (cache_Ready == 1)  begin
        instruction_out <= instruction_in; //when enabled output=input
        PC_out <= PC_in; 
        
     end
  end
endmodule

module tb_IF_reg();
     wire [9:0] instruction_out, PC_out;
     reg clk, reset, cache_Ready;
     reg [9:0] instruction_in, PC_in;
    
     IF_reg SUT(.instruction_out(instruction_out), .PC_out(PC_out), .clk(clk), .reset(reset), .cache_Ready(cache_Ready), .instruction_in(instruction_in), .PC_in(PC_in));
    
     parameter PERIOD = 10;
    
     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
    
     initial begin
         cache_Ready = 1'b1;
         reset = 1'b1; #PERIOD; //test reset
         reset = 1'b0; instruction_in = 10'b1111; #PERIOD;
         PC_in = 10'b0;
         instruction_in = 10'b0111;    #PERIOD;
         PC_in = 10'b1;
         instruction_in = 10'b0011;    #PERIOD;
         PC_in = 10'b10;
         cache_Ready = 1'b0;
         instruction_in = 10'b0001;    #PERIOD;
         PC_in = 10'b10;
         instruction_in = 10'b0001;    #PERIOD;
         PC_in = 10'b10;
         instruction_in = 10'b0001;    #PERIOD;
         PC_in = 10'b11;
         cache_Ready = 1'b1;
         instruction_in = 10'b0;       #PERIOD; 
         PC_in = 10'b100;
         instruction_in = 10'b0101;    #PERIOD; 
     end
endmodule