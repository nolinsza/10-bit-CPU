module hazardmux( 

    output reg  reg_write_en_out, RAM_writeEnable_out, MemtoReg_out,
    output reg [1:0] jsel_out,

    input wire  reg_cntrl, RAM_cntrl, MemtoReg_cntrl,  //hazard when switch = 1, cntrl when switch = 0 
    input wire [1:0] jsel_cntrl,
    input wire sw 

    ); 

   always @(*) begin 

        if (sw == 1) begin
            reg_write_en_out = 1'b0;
            RAM_writeEnable_out = 1'b0;
            MemtoReg_out = 1'b0;
            jsel_out = 2'b0;
        end
        else begin
            reg_write_en_out = reg_cntrl;
            RAM_writeEnable_out = RAM_cntrl;
            MemtoReg_out = MemtoReg_cntrl;
            jsel_out = jsel_cntrl;
            
        end
    end 

endmodule 