`timescale 1ns/1ps

module adder10 (
    output wire[9:0] sum, 
    output wire cout,
    input wire [9:0] A, B,
    input wire cin);
    
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
    
    fulladder A1(sum[0], w1, A[0], B[0], cin);
    fulladder A2(sum[1], w2, A[1], B[1], w1);
    fulladder A3(sum[2], w3, A[2], B[2], w2);
    fulladder A4(sum[3], w4, A[3], B[3], w3);
    fulladder A5(sum[4], w5, A[4], B[4], w4);
    fulladder A6(sum[5], w6, A[5], B[5], w5);
    fulladder A7(sum[6], w7, A[6], B[6], w6);
    fulladder A8(sum[7], w8, A[7], B[7], w7);
    fulladder A9(sum[8], w9, A[8], B[8], w8);
    fulladder A10(sum[9], cout, A[9], B[9], w9);
    
endmodule

module tb_adder10();
    wire [9:0] sum;
    wire cout;
    reg [9:0] A, B;
    reg cin;
    
    adder10 SUT(.sum(sum), .cout(cout), .A(A),.B(B),.cin(cin));
    
    parameter PERIOD = 10;
    
    initial begin
        cin=1'B0; A=10'b100; B=10'b100; #PERIOD;
        A = 10'b111; B = 10'b1; #PERIOD;
        cin=1'B1; A=10'b100; B=10'b100; #PERIOD;
    end
endmodule