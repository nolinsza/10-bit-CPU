module zeroregister (
 output reg [9:0] dout,
 input wire clk
 );

 always @(posedge clk) begin //triggered by clock rising edge
     dout=10'b0;
  end
endmodule