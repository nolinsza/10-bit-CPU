module mux4x1(
    output reg [9:0] O,
    input wire [9:0] A,B,C,D,
    input wire [1:0] sw
    );
    
   always @(*) begin
    case (sw)
        2'b00: O [9:0] = A[9:0];
        2'b01: O [9:0] = B[9:0];
        2'b10: O [9:0] = C[9:0];
        2'b11: O [9:0] = D[9:0];
        default:O=10'b0;
        endcase
    end
endmodule

module tb_mux4x1 ();
    wire [9:0] O;
    reg [9:0] A, B, C, D; 
    reg [1:0] sw;
    
    mux4x1 SUT(.O(O), .A(A), .B(B), .C(C), .D(D), .sw(sw)); 
    
    parameter PERIOD = 10;
    
    initial begin 
        A = 10'b1;  B = 10'b111; C = 10'b10; D = 10'b11;
        sw = 2'b0; #PERIOD; //select A 
        sw = 2'b1; #PERIOD; //select B 
        sw = 2'b10; #PERIOD; //Select C
        sw = 2'b11; #PERIOD; //Select D
    end
endmodule
