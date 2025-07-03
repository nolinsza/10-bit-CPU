module upperHW(
    output reg [9:0] uhw_out,
    input wire [4:0] hw,
    input wire [9:0] rs
    );

    always @(hw, rs) begin 
        uhw_out [9:5] = hw;
        uhw_out [4:0] = rs [4:0]; 
    end
endmodule

module tb_upperHW ();
    wire [9:0] uhw_out;
    reg [4:0] hw;
    reg [9:0] rs; 
    
    upperHW SUT(.uhw_out(uhw_out), .hw(hw), .rs(rs));
    
    parameter PERIOD = 10; 
    
    initial begin 
    
    hw = 5'b01011; rs = 10'b0000011111;    
    
    end

endmodule 