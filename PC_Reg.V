module PC_reg (
 output reg [9:0] dout,
 input wire clk, reset, en,
 input wire [9:0] din);

 always @(posedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        dout <= 10'b0; //output is 0 if reset bit is high
     end
     else if (en == 1'b1) begin
        dout <= din; //when enabled output=input
     end
  end
endmodule