module lowerHW(
    output reg [9:0] lhw_out,
    input wire [4:0] hw,
    input wire [9:0] rs
    );

    always @(hw, rs) begin 
        lhw_out [4:0] = hw;
        lhw_out [9:5] = rs [9:5]; 
    end
endmodule

module tb_lowerHW ();
    wire [9:0] lhw_out;
    reg [4:0] hw;
    reg [9:0] rs; 
    
    lowerHW SUT(.lhw_out(lhw_out), .hw(hw), .rs(rs));
    
    parameter PERIOD = 10; 
    
    initial begin 
    
    hw = 5'b01011; rs = 10'b1111100000;    
    
    end

endmodule 