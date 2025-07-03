module pipeline (
    output reg done,
    output reg [9:0] result,
    input wire clk, reset
);
    //stage 1 
    wire [9:0] instruction_out, la;
    
    //stage 2 
    wire [9:0] rs_out2, rt_out2, signextendimm_out;
    wire [2:0] reg_writesel_out2, rd_sel1_out2,rd_sel2_out2;
    wire [4:0] half_word_out2;
    wire reg_write_en_out2, RAM_writeEnable_out2, imm_sel_out2, MemtoReg_out2, upper_hw_en_out2, lower_hw_en_out2;
    wire j_cntrl_out, PC_en_out, PC_en_out_reg, hazard, PC_hazard, E, F;
    wire [1:0] ALU_sel_out2;
    
    //Stage3
    wire [9:0] rs_out3, rt_out3, ALU_result_out3;
    wire [2:0] reg_writesel_out3;
    wire [4:0] half_word_out3;
    wire reg_write_en_out3, RAM_writeEnable_out3, MemtoReg_out3, upper_hw_en_out3, lower_hw_en_out3, cache_Ready, PC_en_out3;
   
    
    //Stage4
    wire [9:0] rs_out4, Mem_M, ALU_M;
    wire reg_write_en_M, MemtoReg_M, PC_en_out4;
    wire [2:0] write_sel_M;
    wire [4:0] half_word_out4;
    
    //Stage5
    wire [9:0] rs_write_RF, FinalResult;

    
    //Stage 1 
    stage1 stage1mod(
    //Output
    .instruction_out(instruction_out),
    //Inputs
    .clk(clk),
    .reset(reset),
    .j_cntrl(j_cntrl_out),
    .pc_en(PC_en_out),
    .pc_hazard(PC_hazard),
    .E(E),
    .F(F),
    .cache_Ready(cache_Ready),
    .LA_IF(la),
    .LA_EX(ALU_result_out3),
    .LA_M(rs_write_RF));
    
    
    
    //Stage 2 
    stage2 stage2mod(
    //Outputs
    //10 Bits
    .rs_out(rs_out2),
    .rt_out(rt_out2),
    .signextendimm_out(signextendimm_out),
    .la_out(la),
    
    //3 Bits 
    .reg_writesel_out(reg_writesel_out2),
    .rd_sel1_out(rd_sel1_out2),
    .rd_sel2_out(rd_sel2_out2),
    //5 Bits
    .half_word_out(half_word_out2),
    
    //Control Signals
    .reg_write_en_out(reg_write_en_out2),
    .RAM_writeEnable_out(RAM_writeEnable_out2),
    .imm_sel_out(imm_sel_out2),
    .MemtoReg_out(MemtoReg_out2),
    .upper_hw_en_out(upper_hw_en_out2),
    .lower_hw_en_out(lower_hw_en_out2),
    .j_cntrl_out(j_cntrl_out),
    .PC_en_out_stage(PC_en_out),
    .PC_en_out_reg(PC_en_out_reg),                  //passed reg to reg for done/result timing 
    .PC_hazard(PC_hazard),
    .E(E),
    .F(F),
    .ALU_sel_out(ALU_sel_out2), 
 
    //Inputs
    .instruction(instruction_out),
    .rs_write_M(rs_write_RF),
    .ALU_EX(ALU_result_out3),
    .Mem_M(Mem_M),
    .write_sel_M(write_sel_M),
    .write_sel_EX(reg_writesel_out3),
    .clk(clk),
    .reset(reset),
    .reg_write_en_M(reg_write_en_M),
    .MemtoReg_M(MemtoReg_M),
    .reg_write_en_EX(reg_write_en_out3),
    .MemtoReg_EX(MemtoReg_out3),
    .cache_Ready(cache_Ready));
    
     
     
     //Stage 3  
     stage3 stage3mod (
     //Outputs 
     //10 Bits
    .PC_en_out(PC_en_out3),
    .rs_out(rs_out3),
    .rt_out(rt_out3),
    .ALU_result(ALU_result_out3),
    
    //Control Signals
    .reg_write_en_out(reg_write_en_out3),
    .RAM_writeEnable_out(RAM_writeEnable_out3),
    .MemtoReg_out(MemtoReg_out3),
    .reg_writesel_out(reg_writesel_out3),
    
    //Inputs
    //10Bits
    .PC_en_in(PC_en_out_reg),
    .cache_Ready(cache_Ready),
    .rs_in(rs_out2),
    .rt_in(rt_out2),
    .signextimm(signextendimm_out),
    
    //Control Signals
    .ALU_EX(ALU_result_out3),
    .ALU_M(ALU_M),
    .Mem_M(Mem_M),
    .ALU_sel(ALU_sel_out2),
    .reg_write_en_in(reg_write_en_out2),
    .RAM_writeEnable_in(RAM_writeEnable_out2),
    .imm_sel(imm_sel_out2),
    .MemtoReg_in(MemtoReg_out2),
    .upper_hw_en_in(upper_hw_en_out2),
    .lower_hw_en_in(lower_hw_en_out2),
    
    
    .MemtoReg_M(MemtoReg_M),
    .reg_write_en_M(reg_write_en_M),
    .MemtoReg_EX(MemtoReg_out3),
    .reg_write_en_EX(reg_write_en_out3),
    .reg_writesel_in(reg_writesel_out2),
    .rd_sel1_in(rd_sel1_out2),
    .rd_sel2_in(rd_sel2_out2),
    .write_sel_EX(reg_writesel_out3),
    .write_sel_M(write_sel_M),
    .half_word_in(half_word_out2),
    .reset(reset),
    .clk(clk) );
    
    
    
    
    //Stage 4 
    stage4 stage4mod (
    //Outputs
    //10 Bits
    .mem_res_out(Mem_M),
    .ALU_result_out(ALU_M),
    
    //Control Signals 
    .PC_en_out(PC_en_out4),
    .reg_write_en_out(reg_write_en_M),
    .MemtoReg_out(MemtoReg_M), 
    .reg_writesel_out(write_sel_M),
    .cache_Ready(cache_Ready),
    
    //Inputs
    .clk(clk),
    .reset(reset),
    
    //10 Bit Inputs
    .rs(rs_out3),
    .rt_in(rt_out3),
    .ALU_result_in(ALU_result_out3),
    
    //Control Inputs 
    .PC_en_in(PC_en_out3),
    .reg_write_en_in(reg_write_en_out3), 
    .RAM_writeEnable_in(RAM_writeEnable_out3),
    .MemtoReg_in(MemtoReg_out3),
    .reg_writesel_in(reg_writesel_out3));
    
    
    
    
    //Stage 5 
    stage5 stage5mod (
    //Outputs 
    .MemOrALU_MUX_out(rs_write_RF),
    .FinalResult(FinalResult),
    
    //Inputs
    .memory_res_in(Mem_M),
    .ALU_result_in(ALU_M),
    .MemtoReg_in(MemtoReg_M),
    .clk(clk),
    .PC_en_out(PC_en_out4)
    );
    
    always @(*) begin 
    
        if (PC_en_out4 == 1'b0)  begin  
            done = 1'b1;
            result = FinalResult;
        end
        else begin
            done=1'b0;
            result = 10'bxxxxxxxxxx;
        end
        
    end


endmodule 

module tb_pipeline ();
    wire done;
    wire [9:0] result;
    reg clk, reset; 
    
    pipeline SUT(.done(done), .result(result), .clk(clk), .reset(reset));
    
    parameter PERIOD = 10; 
    initial clk = 1'b0;
    always #(PERIOD/2) clk = ~clk;
    
    initial begin 
        reset = 1'b1; #PERIOD; 
        reset = 1'b0; #PERIOD;
                      #PERIOD;
                      
    end 
    
endmodule
    

