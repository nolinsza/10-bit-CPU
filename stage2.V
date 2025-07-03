module stage2 (
    output wire [9:0] rs_out, rt_out, signextendimm_out, la_out,
    //Control Unit Outputs 
     output wire [2:0] reg_writesel_out, rd_sel1_out, rd_sel2_out,
     output wire [4:0] half_word_out,
     output wire reg_write_en_out, RAM_writeEnable_out, imm_sel_out, MemtoReg_out, upper_hw_en_out, lower_hw_en_out,
     output wire j_cntrl_out, PC_en_out_stage, PC_en_out_reg, PC_hazard, E, F,
     output wire [1:0] ALU_sel_out,    
                            
     input wire [9:0] instruction, rs_write_M,
     input wire [9:0] ALU_EX, Mem_M,
     input wire [2:0] write_sel_M, write_sel_EX,
     input wire clk, reset, reg_write_en_M, MemtoReg_M, reg_write_en_EX, MemtoReg_EX, cache_Ready
);

     //Control Unit Outputs
     wire [2:0] reg_writesel_in, rd_sel1_in, rd_sel2_in;
     wire imm_sel_in, RAM_writeEnable_cntrl, upper_hw_en_in ,lower_hw_en_in, MemtoReg_cntrl, reg_write_en_cntrl;
     wire [1:0] jsel_cntrl, ALU_sel_in;
     wire [2:0] imm;
     wire [4:0] half_word_in;
     
     //register file outputs 
     wire [9:0] rs_read, rt_read;
     
     //sign extend module output
     wire [9:0] signextendimm;
     
     //Hazard Detection 
     wire reg_write_en_hz, RAM_writeEnable_out_hz, hazard, A, B, C, D;
     
     //Hazard Mux
     wire RAM_writeEnable_in, reg_write_en_in, MemtoReg_in;
     wire [1:0] jsel_hazard;
     
     //Pipeline Register 
     wire j_cntrl_ID;
     
     //Forward Mux 
     wire [9:0] RS_sub, RT_sub, RT_ALU_M, RS_ALU_M ; 

    //Control Unit
    controlunit ControlUnitModule(
    //Outputs 
    .reg_writesel(reg_writesel_in),
    .reg_read1sel(rd_sel1_in),
    .reg_read2sel(rd_sel2_in),
    .reg_write_en(reg_write_en_cntrl),
    .ALU_sel(ALU_sel_in),
    .immVal(imm),
    .imm_sel(imm_sel_in),
    .fetch_cntrl(jsel_cntrl),
    .PC_en(PC_en_out_stage),
    .RAM_writeEnable(RAM_writeEnable_cntrl),
    .half_word(half_word_in),
    .upper_hw_en(upper_hw_en_in),
    .lower_hw_en(lower_hw_en_in),
    .MemtoReg(MemtoReg_cntrl),
    
    //Input
    .instruction(instruction));
    
    
    //Hazard Detection
    Hazard_Detection HazardDetectionModule(
    //Outputs 
    .hazard(hazard),
    .PC_hazard(PC_hazard),
    .A(A), 
    .B(B),
    .C(C),
    .D(D),
    .E(E),
    .F(F),
    
    //Inputs
    .MemtoReg_ID(MemtoReg_out),
    .reg_write_en_M(reg_write_en_M),
    .MemtoReg_M(MemtoReg_M),
    .reg_write_en_EX(reg_write_en_EX),
    .rd_sel1_ID(rd_sel1_out),
    .rd_sel1_IF(rd_sel1_in),
    .rd_sel2_IF(rd_sel2_in),
    .reg_write_en_ID(reg_write_en_out),
    .branch_cntrl(jsel_cntrl),
    .MemtoReg_EX(MemtoReg_EX),
    .write_sel_EX(write_sel_EX),
    .write_sel_M(write_sel_M),
    .write_sel_ID(reg_writesel_out)
    );
    
    
    
    //Hazard Mux
    hazardmux Cntrl_HazardMUX(
    //Output
    .reg_write_en_out(reg_write_en_in),
    .RAM_writeEnable_out(RAM_writeEnable_in),
    .MemtoReg_out(MemtoReg_in),
    .jsel_out(jsel_hazard),
    
    //Inputs
    .reg_cntrl(reg_write_en_cntrl),
    .RAM_cntrl(RAM_writeEnable_cntrl),
    .jsel_cntrl(jsel_cntrl),
    .MemtoReg_cntrl(MemtoReg_cntrl),
    .sw(hazard));
  
  
  
    //Register File 
    register_file RF(
    //Outputs
    .rs_read(rs_read),
    .rt(rt_read),
    .la_out(la_out),
    //Inputs
    .clk(clk),
    .gb_en(reg_write_en_M),
    .rs_write(rs_write_M),
    .reset(reset),
    .write_sel(write_sel_M),
    .read1sel(rd_sel1_in),
    .read2sel(rd_sel2_in));  
    
    sign_extend signextendmodule(.signextendimm(signextendimm), .imm(imm)); 

    jCNTRL jump_cntrl_module(.fetchCNTRL(j_cntrl_out), .jsel(jsel_hazard), .rs(RS_sub), .rt(RT_sub));
    
    //Forwarding Signal B Mux
    mux2x1_10 SigB(.mout(RS_ALU_M), .A(Mem_M), .B(ALU_EX), .SW(B));
    //Forwarding Signal A Mux 
    mux2x1_10 SigA(.mout(RS_sub), .A(rs_read), .B(RS_ALU_M), .SW(A));
    
    //Forwarding Signal D Mux
    mux2x1_10 SigD(.mout(RT_ALU_M), .A(Mem_M), .B(ALU_EX), .SW(D));
    //Forwarding Signal C Mux 
    mux2x1_10 SigC(.mout(RT_sub), .A(rt_read), .B(RT_ALU_M), .SW(C));
    
    //Decode/Execute Register 
    decode_execute_reg ID_EX_reg(
    //outputs 
    .rs_out(rs_out),
    .rt_out(rt_out),
    .signextendimm_out(signextendimm_out),
    .reg_writesel_out(reg_writesel_out),
    .rd_sel1_out(rd_sel1_out),
    .rd_sel2_out(rd_sel2_out),
    .half_word_out(half_word_out),
    .reg_write_en_out(reg_write_en_out),
    .RAM_writeEnable_out(RAM_writeEnable_out),
    .imm_sel_out(imm_sel_out), 
    .MemtoReg_out(MemtoReg_out),
    .upper_hw_en_out(upper_hw_en_out),
    .lower_hw_en_out(lower_hw_en_out),
    .ALU_sel_out(ALU_sel_out),
    .jcntrl_out(j_cntrl_ID),
    .PC_en_out(PC_en_out_reg),
    
    //Inputs  
    .clk(clk),
    .reset(reset),
    .jcntrl_in(j_cntrl_out),
    .PC_en_in(PC_en_out_stage),
    .cache_Ready(cache_Ready),
    .rs_in(rs_read),
    .rt_in(rt_read),
    .signextendimm_in(signextendimm),
    .reg_writesel_in(reg_writesel_in),
    .rd_sel1_in(rd_sel1_in),
    .rd_sel2_in(rd_sel2_in),
    .half_word_in(half_word_in),
    .reg_write_en_in(reg_write_en_in),
    .RAM_writeEnable_in(RAM_writeEnable_in),
    .imm_sel_in(imm_sel_in),
    .MemtoReg_in(MemtoReg_in),
    .upper_hw_en_in(upper_hw_en_in),
    .lower_hw_en_in(lower_hw_en_in),
    .ALU_sel_in(ALU_sel_in)); 
    
endmodule 

module tb_stage2 ();
     wire [9:0] rs_out, rt_out, signextendimm_out, la_out;
    //Control Unit Outputs 
      wire [2:0] reg_writesel_out, rd_sel1_out, rd_sel2_out;
      wire [4:0] half_word_out;
      wire reg_write_en_out, RAM_writeEnable_out, imm_sel_out, MemtoReg_out, upper_hw_en_out, lower_hw_en_out;
      wire j_cntrl_out, PC_en_out;
      wire [1:0] ALU_sel_out;                              
      reg [9:0] instruction, rs_write_M;
      reg [2:0] write_sel_M;
      reg clk, reset, reg_write_en_M;
      
      stage2 SUT(
    //Outputs
    //10 Bits
    .rs_out(rs_out),
    .rt_out(rt_out),
    .signextendimm_out(signextendimm_out),
    .la_out(la_out),
    
    //3 Bits 
    .reg_writesel_out(reg_writesel_out),
    .rd_sel1_out(rd_sel1_out),
    .rd_sel2_out(rd_sel2_out),
    //5 Bits
    .half_word_out(half_word_out),
    
    //Control Signals
    .reg_write_en_out(reg_write_en_out),
    .RAM_writeEnable_out(RAM_writeEnable_out),
    .imm_sel_out(imm_sel_out),
    .MemtoReg_out(MemtoReg_out),
    .upper_hw_en_out(upper_hw_en_out),
    .lower_hw_en_out(lower_hw_en_out),
    .j_cntrl_out(j_cntrl_out),
    .PC_en_out(PC_en_out),
    .ALU_sel_out(ALU_sel_out), 
    
    //Inputs
    .instruction(instruction),
    .rs_write_M(rs_write_M),
    .write_sel_M(write_sel_M),
    .clk(clk),
    .reset(reset),
    .reg_write_en_M(reg_write_en_M));
      
      parameter PERIOD = 10; 
      initial clk = 1'b0;
      always #(PERIOD/2) clk = ~clk;
      
      initial begin 
      reset = 1'b1; #PERIOD;
      reset = 1'b0; 
      instruction = 10'b0011000010;                                         //lw $t1, $s0
      rs_write_M = 10'b110; write_sel_M = 3'b001; reg_write_en_M = 1'b1;    //write to s1  
                                                                            #PERIOD;
      instruction = 10'b0011000101;                                         //sw $t1, $s1 - should create memory hazard 
      rs_write_M = 10'b110; write_sel_M = 3'b001; reg_write_en_M = 1'b0;    //Do not write 
                                                                            #PERIOD;
      instruction = 10'b0100011111; //bne $s1, $zero                        //should create jump hazard 
      rs_write_M = 10'b110; write_sel_M = 3'b001; reg_write_en_M = 1'b0;    //Do not write 
                                                            
      
      end
endmodule 