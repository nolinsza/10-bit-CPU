module stage3(
    output wire [9:0] rs_out, rt_out, ALU_result,
    output wire reg_write_en_out, RAM_writeEnable_out, MemtoReg_out, PC_en_out,
    output wire [2:0] reg_writesel_out,
    input wire [9:0] rs_in, rt_in, signextimm, ALU_EX, ALU_M, Mem_M, 
    input wire [1:0] ALU_sel,
    input wire reg_write_en_in, RAM_writeEnable_in, imm_sel, MemtoReg_in, upper_hw_en_in, lower_hw_en_in,
    input wire MemtoReg_M, reg_write_en_M, MemtoReg_EX, reg_write_en_EX, cache_Ready, PC_en_in,
    input wire [2:0] reg_writesel_in, rd_sel1_in, rd_sel2_in, write_sel_EX, write_sel_M,
    input wire [4:0] half_word_in,
    input wire reset, clk
);

    //Forwarding Unit 
    wire [1:0] A,B;
    
    //Immediate Mux 
    wire [9:0] imm_or_rt;
    
    //4x1 MUX
    wire [9:0] rs__EX_MUX_Out, rt__EX_MUX_Out;
    
    //HW
    wire [9:0] uhw_out, lhw_out, hw_MUX1_out, EX_result_in;
    
    wire cout, bout;
    wire [9:0] ALU_res;
    
    
    Forwarding_Unit Forwarding_mod(.A(A), .B(B), .write_sel_EX(write_sel_EX), .rd_sel1_in(rd_sel1_in), .write_sel_M(write_sel_M),
    .rd_sel2_in(rd_sel2_in), .reg_write_en_EX(reg_write_en_EX), .MemtoReg_EX(MemtoReg_EX), .reg_write_en_M(reg_write_en_M), .MemtoReg_M(MemtoReg_M), .imm_sel(imm_sel));
    
    //MUX4x1 Switch = 00 selects A 
    //Select rs into ALU
    mux4x1 sel_ALU_rs(.O(rs__EX_MUX_Out),. A(rs_in), .B(ALU_EX), .C(ALU_M), .D(Mem_M), .sw(A));
    
    //HW modules
    upperHW uphw_module(.uhw_out(uhw_out), .hw(half_word_in), .rs(rs__EX_MUX_Out));
    lowerHW lwhw_module(.lhw_out(lhw_out), .hw(half_word_in), .rs(rs__EX_MUX_Out));
    
    
    //Select rt into ALU
    mux2x1_10 sel_imm_rt(.mout(imm_or_rt), .A(rt_in), .B(signextimm), .SW(imm_sel));
    mux4x1 sel_ALU_rt(.O(rt__EX_MUX_Out),. A(imm_or_rt), .B(ALU_EX), .C(ALU_M), .D(Mem_M), .sw(B));
    
    ALU ALU_Module(.result(ALU_res), .cout(cout), .bout(bout), .rs(rs__EX_MUX_Out), .rt(rt__EX_MUX_Out), .opcode(ALU_sel), .cin(1'b0), .bin(1'b0));
    
    //Select HW or ALU
    mux2x1_10 luhw_MUX(.mout(hw_MUX1_out), .A(ALU_res), .B(uhw_out), .SW(upper_hw_en_in));
    mux2x1_10 llhw_MUX(.mout(EX_result_in), .A(hw_MUX1_out), .B(lhw_out), .SW(lower_hw_en_in));
    
    EX_reg EX_Reg_Mod(
    //Output 
    .PC_en_out(PC_en_out),
    .rs_out(rs_out),
    .rt_out(rt_out),
    .ALU_result_out(ALU_result),
    .reg_writesel_out(reg_writesel_out),
    .reg_write_en_out(reg_write_en_out),
    .RAM_writeEnable_out(RAM_writeEnable_out), 
    .MemtoReg_out(MemtoReg_out),
    
    //Inputs
    .cache_Ready(cache_Ready),
    .PC_en_in(PC_en_in),
    .clk(clk),
    .reset(reset),
    .rs_in(rs__EX_MUX_Out), 
    .rt_in(rt__EX_MUX_Out),
    .ALU_result_in(EX_result_in),
    .reg_writesel_in(reg_writesel_in),
    .reg_write_en_in(reg_write_en_in),
    .RAM_writeEnable_in(RAM_writeEnable_in), 
    .MemtoReg_in(MemtoReg_in));
    
endmodule

module tb_stage3();
    wire [9:0] rs_out, rt_out, ALU_result;
    wire reg_write_en_out, RAM_writeEnable_out, MemtoReg_out, upper_hw_en_out, lower_hw_en_out;
    wire [2:0] reg_writesel_out;
    wire [4:0] half_word_out;
    reg [9:0] rs_in, rt_in, signextimm, ALU_EX, ALU_M, Mem_M;
    reg [1:0] ALU_sel;
    reg reg_write_en_in, RAM_writeEnable_in, imm_sel, MemtoReg_in, upper_hw_en_in, lower_hw_en_in;
    reg MemtoReg_M, reg_write_en_M, MemtoReg_EX, reg_write_en_EX;
    reg [2:0] reg_writesel_in, rd_sel1_in, rd_sel2_in, write_sel_EX, write_sel_M;
    reg [4:0] half_word_in;
    reg reset, clk;
    
    stage3 SUT (.rs_out(rs_out), .rt_out(rt_out), .ALU_result(ALU_result), .reg_write_en_out(reg_write_en_out), .RAM_writeEnable_out(RAM_writeEnable_out),
    .MemtoReg_out(MemtoReg_out), .upper_hw_en_out(upper_hw_en_out), .lower_hw_en_out(lower_hw_en_out),
    .reg_writesel_out(reg_writesel_out), .half_word_out(half_word_out), .rs_in(rs_in), .rt_in(rt_in), .signextimm(signextimm), .ALU_EX(ALU_EX), .ALU_M(ALU_M),
    .Mem_M(Mem_M), .ALU_sel(ALU_sel), .reg_write_en_in(reg_write_en_in), .RAM_writeEnable_in(RAM_writeEnable_in),
    .imm_sel(imm_sel), .MemtoReg_in(MemtoReg_in), .upper_hw_en_in(upper_hw_en_in), .lower_hw_en_in(lower_hw_en_in), .MemtoReg_M(MemtoReg_M),
    .reg_write_en_M(reg_write_en_M), .MemtoReg_EX(MemtoReg_EX), .reg_write_en_EX(reg_write_en_EX),
    .reg_writesel_in(reg_writesel_in), .rd_sel1_in(rd_sel1_in), .rd_sel2_in(rd_sel2_in), .write_sel_EX(write_sel_EX), .write_sel_M(write_sel_M),
    .half_word_in(half_word_in), .reset(reset), .clk(clk) );
    
    parameter PERIOD = 10; 
    initial clk = 1'b0; //clock starts on 0 
    always #(PERIOD/2) clk = ~clk; 
     
    initial begin 
        reset=1'b1;  #PERIOD; 
        reset = 1'b0;
        
        rs_in = 10'b10111; rt_in = 10'b01; signextimm = 10'b100; ALU_EX = 10'b1; ALU_M =10'b1; Mem_M = 10'b10;
        ALU_sel = 2'b0; reg_write_en_in = 1'b0; RAM_writeEnable_in = 1'b1; imm_sel = 1'b0; MemtoReg_in = 1'b1; 
        upper_hw_en_in = 1'b0; lower_hw_en_in = 1'b0; reg_writesel_in = 3'b0; half_word_in = 5'b01010;
        
        write_sel_EX = 3'b101;    rd_sel1_in = 3'b101;      write_sel_M=3'b101;     rd_sel2_in=3'b101;      //A = 01    B = 01
        reg_write_en_EX = 1'b1;   MemtoReg_EX = 1'b0;       reg_write_en_M  = 1'b1; MemtoReg_M=1'b1;        #PERIOD; 
        
        write_sel_EX = 3'b100;    rd_sel1_in = 3'b101;      write_sel_M=3'b101;     rd_sel2_in=3'b101;      //A = 10    B = 10
        reg_write_en_EX = 1'b1;   MemtoReg_EX = 1'b0;       reg_write_en_M  = 1'b1; MemtoReg_M=1'b0;        #PERIOD;  
        
        write_sel_EX = 3'b100;    rd_sel1_in = 3'b101;      write_sel_M=3'b101;     rd_sel2_in=3'b101;      //A = 11    B = 11
        reg_write_en_EX = 1'b1;   MemtoReg_EX = 1'b0;       reg_write_en_M  = 1'b1; MemtoReg_M=1'b1;        #PERIOD; 
        
         write_sel_EX = 3'b100;    rd_sel1_in = 3'b101;      write_sel_M=3'b101;     rd_sel2_in=3'b101;      //A = 00    B = 00
        reg_write_en_EX = 1'b0;   MemtoReg_EX = 1'b0;       reg_write_en_M  = 1'b0; MemtoReg_M=1'b0;        #PERIOD; 
    end
endmodule
