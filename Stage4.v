module stage4 (
    output wire [9:0] mem_res_out, ALU_result_out,
    output wire reg_write_en_out, MemtoReg_out, PC_en_out,
    output wire [2:0] reg_writesel_out,
    output wire cache_Ready,
    input wire [9:0] rs, rt_in, ALU_result_in,
    input wire reg_write_en_in, RAM_writeEnable_in, MemtoReg_in, clk, reset, PC_en_in,
    input wire [2:0] reg_writesel_in
    );
    
    wire [9:0] RES_in;
    
    cache  Cache_Mod(.mem_res_out(RES_in), .cache_Ready(cache_Ready), .rs(rs), .rt_in(rt_in), .RAM_writeEnable_in(RAM_writeEnable_in), .MemtoReg_in(MemtoReg_in), .clk(clk), .reset(reset));
    
     M_reg MEMreg(
     //outputs 
     .memory_res_out(mem_res_out), .ALU_result_out(ALU_result_out), .reg_writesel_out(reg_writesel_out),
     .reg_write_en_out(reg_write_en_out), .MemtoReg_out(MemtoReg_out), .PC_en_out(PC_en_out),
     //inputs
     .clk(clk), .reset(reset),
     .memory_res_in(RES_in), .ALU_result_in(ALU_result_in), .cache_Ready(cache_Ready), .PC_en_in(PC_en_in), .reg_writesel_in(reg_writesel_in),
     .reg_write_en_in(reg_write_en_in), .MemtoReg_in(MemtoReg_in));

endmodule

module tb_Stage4();

    wire [9:0] mem_res_out, ALU_result_out;
    wire reg_write_en_out, MemtoReg_out, PC_en_out;
    wire [2:0] reg_writesel_out;
    wire cache_Ready;
    reg [9:0] rs, rt_in, ALU_result_in;
    reg reg_write_en_in, RAM_writeEnable_in, MemtoReg_in, clk, reset, PC_en_in;
    reg [2:0] reg_writesel_in;
    
    stage4 SUT (.mem_res_out(mem_res_out), .ALU_result_out(ALU_result_out), .reg_write_en_out(reg_write_en_out), .MemtoReg_out(MemtoReg_out), 
    .PC_en_out(PC_en_out), .reg_writesel_out(reg_writesel_out), .cache_Ready(cache_Ready), .rs(rs), 
    .rt_in(rt_in), .ALU_result_in(ALU_result_in), .reg_write_en_in(reg_write_en_in), 
    .RAM_writeEnable_in(RAM_writeEnable_in), .MemtoReg_in(MemtoReg_in), .clk(clk), .reset(reset), .PC_en_in(PC_en_in), .reg_writesel_in(reg_writesel_in));
    
    parameter PERIOD = 10;
    initial clk = 1'b0;
    always #(PERIOD/2) clk=~clk;
    
    initial begin
        ALU_result_in = 10'b11; reg_write_en_in = 2'b10; PC_en_in = 1'b1; reg_writesel_in = 3'b101; 
        reset=1'b1; #PERIOD;
        reset=1'b0;
        rs =10'b0000011111; rt_in=10'b0000000000;  
        RAM_writeEnable_in=1'b1; MemtoReg_in=1'b0;
        reg_writesel_in=3'b001;                                                     #PERIOD;
        #PERIOD; #PERIOD;
        
        rs =10'b0;
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b1; MemtoReg_in = 1'b0;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000100000; 
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        #PERIOD;    #PERIOD;
        #PERIOD;    #PERIOD;
        
    end
endmodule