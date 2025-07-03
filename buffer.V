module buffer (
    output reg [9:0] data,
    input wire MemtoReg,
    input wire [9:0] rs
);

    

    always @(MemtoReg, rs) begin 
        if (MemtoReg == 1) begin
            data = 10'bz;
        end
        
        else begin
            data = rs;
        end
    end
endmodule