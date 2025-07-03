module fullsub(
    output dif, bout,
    input A, B, bin
    );
    
    wire w1, w2, w3;
    xor(w1, A, B);
    xor (dif, w1, bin); 
    and (w2, ~w1, bin);
    and (w3, ~A, B);
    or (bout, w2, w3);
    
endmodule

module tb_fullsub();
    wire dif,bout;
    reg A, B, bin;
    
    fullsub SUT(.dif(dif), .bout(bout), .A(A), .B(B), .bin(bin));
    
    parameter PERIOD = 10;
    
    initial begin
        bin=1'b0; A=1; B=0; #PERIOD;
        bin=1'b0; A=0; B=0; #PERIOD;
        bin=1'b0; A=1; B=1; #PERIOD;
        bin=1'b1; A=0; B=1; #PERIOD;
    
    end

endmodule
