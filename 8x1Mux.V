module mux8x1( 

    output reg [9:0] O, 

    input wire [9:0] A,B,C,D,E,F,G,H,

    input wire [2:0] sw 

    ); 

   always @(A, B, C, D, E, F, G, H, sw) begin 

    case (sw) 

        3'b000: O [9:0] = A[9:0]; 
        3'b001: O [9:0] = B[9:0]; 
        3'b010: O [9:0] = C[9:0];
        3'b011: O [9:0] = D[9:0];    
        3'b100: O [9:0] = E[9:0];
        3'b101: O [9:0] = F[9:0];
        3'b110: O [9:0] = G[9:0];
        3'b111: O [9:0] = H[9:0];
        default:O=10'b0; 

        endcase 

    end 

endmodule 

 

module tb_mux8x1 (); 

    wire [9:0] O; 

    reg [9:0] A, B, C, D, E, F, G, H;  

    reg [2:0] sw; 

    mux8x1 SUT(.O(O), .A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .sw(sw)); 

    parameter PERIOD = 10; 

     

    initial begin  

        A = 10'b1;  B = 10'b111; C = 10'b10; D = 10'b11; 
        E = 10'b111; F = 10'b1111; G = 10'b1010; H = 10'b0101;

        sw = 3'b0; #PERIOD; //select A  

        sw = 3'b1; #PERIOD; //select B  

        sw = 3'b10; #PERIOD; //Select C 

        sw = 3'b11; #PERIOD; //Select D 
        
        sw = 3'b100; #PERIOD; //select E 

        sw = 3'b101; #PERIOD; //select F  

        sw = 3'b110; #PERIOD; //Select G

        sw = 3'b111; #PERIOD; //Select H 

    end 

endmodule 
