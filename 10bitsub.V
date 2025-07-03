module sub10bit (
    output wire[9:0] dif, 
    output wire bout,
    input wire [9:0] A, B,
    input wire bin);
    
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
    
    fullsub S1(dif[0], w1, A[0], B[0], bin);
    fullsub S2(dif[1], w2, A[1], B[1], w1);
    fullsub S3(dif[2], w3, A[2], B[2], w2);
    fullsub S4(dif[3], w4, A[3], B[3], w3);
    fullsub S5(dif[4], w5, A[4], B[4], w4);
    fullsub S6(dif[5], w6, A[5], B[5], w5);
    fullsub S7(dif[6], w7, A[6], B[6], w6);
    fullsub S8(dif[7], w8, A[7], B[7], w7);
    fullsub S9(dif[8], w9, A[8], B[8], w8);
    fullsub S10(dif[9], bout, A[9], B[9], w9);
    
endmodule

module tb_sub10bit();
    wire [9:0] dif;
    wire bout;
    reg [9:0] A, B;
    reg bin;
    
    sub10bit SUT(.dif(dif), .bout(bout), .A(A),.B(B),.bin(bin));
    
    parameter PERIOD = 10;
    
    initial begin
        bin=1'B0; A=10'b100; B=10'b100; #PERIOD;
        bin=1'B0; A=10'b10; B=10'b100; #PERIOD;
        bin=1'b0; A=10'b10000;  B=10'b01; #PERIOD;
    end
endmodule