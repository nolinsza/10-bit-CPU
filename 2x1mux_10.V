module mux2x1_10(
    output reg [9:0] mout,      
    input wire [9:0] A, B,      //A when sel 0
    input wire SW
    );

    always @(*) begin
    case (SW)
        1'b0:mout [9:0] = A[9:0];
        1'b1: mout [9:0] = B[9:0];
        default:mout=10'bx;
        endcase
    end
  
endmodule

module tb_2x1mux_10 ();
    wire [9:0] mout;
    reg[9:0] A, B;
    reg SW;
    
    mux2x1_10 SUT(.mout(mout), .A(A), .B(B), .SW(SW));
    
    parameter PERIOD = 10;
    
    
    initial begin 
        A = 10'b111111111;   B= 10'b0; SW = 1'b0;     #PERIOD;
        A = 10'b0;    B= 10'b111111111; SW = 1'b1;     #PERIOD;
        A = 10'b11111111;    B= 10'b11; #PERIOD;
                              #PERIOD;
     end  
endmodule    
    