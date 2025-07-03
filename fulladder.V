module fulladder(
    output sum, cout,
    input A, B, cin);
    
    wire w1, w2, w3;
    xor(w1, A, B);
    xor (sum, w1, cin); 
    and (w2, A, B);
    and (w3, w1, cin);
    or (cout, w2, w3);
    
endmodule

module tb_fulladder();
    wire sum, cout;
    reg A, B, cin;
    
    fulladder SUT(.sum(sum), .cout(cout), .A(A), .B(B), .cin(cin));
    
    parameter PERIOD=10;
    
    initial begin
        cin=1'B0; A=1'b0; B=1'b0; #PERIOD;
        cin=1'B0; A=1'b1; B=1'b0; #PERIOD;
        cin=1'B0; A=1'b0; B=1'b1; #PERIOD;
        cin=1'B0; A=1'b1; B=1'b1; #PERIOD;
    end
endmodule
