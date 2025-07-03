module cache(
    output reg [9:0] mem_res_out,
    output wire cache_Ready,
    input wire [9:0] rs, rt_in, 
    input wire RAM_writeEnable_in, MemtoReg_in, clk, reset
    );
    
    wire [9:0] data, data_out;
    
    //RAM RAM_module(.ReadData(memory_result), .clk(clk), .WriteEnable(RAM_writeEnable_in), .Address(rt_in), .WriteData(rs_in));
    
    assign data = (RAM_writeEnable_in) ? rs: 10'bZZZZZ_ZZZZZ;
    assign data_out = data;
    
//    cache_module cache_mod(.RS(data), .ready(cache_Ready), .clk(clk), .reset(reset), .write(RAM_writeEnable_in), .MemtoReg(MemtoReg_in), .Address(rt_in));


    wire current_dirty1, current_dirty2, current_valid1, current_valid2;
    wire next_dirty1, next_dirty2, next_valid1, next_valid2;
    wire RAM_ready;
    wire [1:0] write_cache, RamWriteEnable;
    wire [4:0] tag_write, tag_cache; 
    wire [3:0] index_out;
    
    wire [19:0] cache_data, RAM_data;

    //Cache Control
    state_machine Control_Mod (
    //outputs
    .RS(data),                    //inout
    .cache_data(cache_data),
    .RAM_data(RAM_data),
    .valid1_out(next_valid1),
    .dirty1_out(next_dirty1),
    .valid2_out(next_valid2),
    .dirty2_out(next_dirty2),
    .ready(cache_Ready),
    .write_cache(write_cache),
    .tag_out(tag_write),
    .index_out(index_out),
    .RamWriteEnable(RamWriteEnable),
    
    //inputs
    .clk(clk),
    .reset(reset),
    .valid1_in(current_valid1),
    .dirty1_in(current_dirty1),
    .valid2_in(current_valid2),
    .dirty2_in(current_dirty2),
    .tag_cache(tag_cache),
    .write_in(RAM_writeEnable_in),
    .offset_in(rt_in[0]),
    .MemtoReg(MemtoReg_in),
    .index_in(rt_in[4:1]),
    .tag_instr(rt_in [9:5]),
    .RAM_ready(RAM_ready)
    );
    
    //Cache Memory 
    
    cache_Mem Cache_Mem_Mod(.data(cache_data), .dirty1_out(current_dirty1), .dirty2_out(current_dirty2), .valid1_out(current_valid1), .valid2_out(current_valid2), .tag_out(tag_cache),
    .clk(clk), .dirty1_in(next_dirty1), .dirty2_in(next_dirty2), .valid1_in(next_valid1), .valid2_in(next_valid2), .tag_in(tag_write),
    .WriteEnable(write_cache), .index_in(rt_in[4:1]));
    
    //RAM Module 
    
    RAM RAM_Mod(.data(RAM_data), .ready(RAM_ready), .clk(clk), .WriteEnable(RamWriteEnable), .Address_in({tag_write,index_out}));


    always @(*) begin 
        mem_res_out = data_out;
    end
   
    
endmodule

module tb_cache();

    wire [9:0] mem_res_out;
    wire cache_Ready;
    reg [9:0] rs, rt_in; 
    reg RAM_writeEnable_in, MemtoReg_in, clk, reset;
    
    cache SUT (.mem_res_out(mem_res_out), .cache_Ready(cache_Ready), .rs(rs), .rt_in(rt_in), .RAM_writeEnable_in(RAM_writeEnable_in), .MemtoReg_in(MemtoReg_in), .clk(clk), .reset(reset));
    
    parameter PERIOD = 10;
    initial clk = 1'b0;
    always #(PERIOD/2) clk=~clk;
    
    initial begin
        reset=1'b1; #PERIOD;
        reset=1'b0;
        rs =10'b0000011111; rt_in=10'b0000000000;  
        RAM_writeEnable_in=1'b1; MemtoReg_in=1'b0;                                                     #PERIOD;
        #PERIOD; #PERIOD;
        
        rs =10'b0;
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b0; MemtoReg_in = 1'b1;                                #PERIOD;
        
        rs =10'b1010101; rt_in=10'b0000000001; 
        RAM_writeEnable_in=1'b1; MemtoReg_in = 1'b0;                                #PERIOD;
    end
endmodule
