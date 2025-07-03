`timescale 1ns / 1ps

module shift(
    output reg [9:0] dout, //dout is the output
    input wire [9:0] rt,rs //rs is the destination and data being shifted and rt is the shift amouunt
    );
   
   wire [9:0] neg_rt;
   assign neg_rt =(~rt+1);
   
    always @(*) begin
        if(rt==10'b0) begin
            dout = rs;
        end
        
        else if(rt[9]) begin 
           dout = rs >> neg_rt;
        end
        
        else begin
            dout = rs << rt;
            
        end
    end 
endmodule

module tb_shift();
    wire [9:0] dout;
    reg [9:0] rt,rs;
    
    shift SUT(.dout(dout), .rt(rt), .rs(rs));
    
    parameter PERIOD = 10;
    
    
    initial begin
        rs=10'b0000001110; rt=10'b10; #PERIOD;
        rs=10'b0000001110; rt=10'b1111111111; #PERIOD;
        
    end 
    
endmodule