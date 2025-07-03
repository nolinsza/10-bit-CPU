module stage5(
    output wire [9:0] MemOrALU_MUX_out,
    output reg [9:0] FinalResult,
    input wire [9:0] memory_res_in, ALU_result_in,
    input wire  MemtoReg_in, clk, PC_en_out
    );
     
    mux2x1_10 MemOrALU_MUX(.mout(MemOrALU_MUX_out), .A(ALU_result_in), .B(memory_res_in), .SW(MemtoReg_in));
    
    always @(negedge clk) begin 
    
        if (PC_en_out == 1) begin 
            FinalResult = MemOrALU_MUX_out;
        end
    
    end
    
endmodule

module tb_stage5();
   wire [9:0] MemOrALU_MUX_out;
   reg [9:0] memory_res_in, ALU_result_in;
   reg MemtoReg_in;

    stage5 SUT (.MemOrALU_MUX_out(MemOrALU_MUX_out), .memory_res_in(memory_res_in), .ALU_result_in(ALU_result_in), .MemtoReg_in(MemtoReg_in));

   parameter PERIOD = 10;
   
   initial begin 
      memory_res_in=10'b0000000000; ALU_result_in=10'b0000000001; MemtoReg_in=1'b0; #PERIOD;
      MemtoReg_in=1'b1;                                                             #PERIOD;
   end
    


endmodule
