module register10bit (
 output reg [9:0] dout,
 input wire clk, reset, en,
 input wire [9:0] din);

 always @(posedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        dout <= 10'b0000000000; //output is 0 if reset bit is high
     end
     else if (en == 1'b1) begin
        dout <= din; //when enabled output=input
     end
  end
endmodule

module tb_register10bit();
     wire [9:0] dout;
     reg clk, reset, en;
     reg [9:0] din;
    
     register10bit SUT(.dout(dout), .clk(clk), .reset(reset), .en(en), .din(din));
    
     parameter PERIOD = 10;
    
     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
    
     initial begin
         reset = 1'b1; #PERIOD; //test reset
         reset = 1'b0; din = 10'b1111; en = 1'b1; #PERIOD;
         din = 10'b0111;    #PERIOD;
         din = 10'b0011;    #PERIOD;
         din = 10'b0001;    #PERIOD;
         din = 10'b0;       #PERIOD; //test inputs
         din = 10'b0101;    #PERIOD; 
     end
endmodule