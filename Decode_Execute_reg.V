module decode_execute_reg (
    output reg [9:0] rs_out, rt_out, signextendimm_out,
    //Control Unit Outputs 
     output reg [2:0] reg_writesel_out, rd_sel1_out, rd_sel2_out,
     output reg [4:0] half_word_out,
     output reg reg_write_en_out, RAM_writeEnable_out, imm_sel_out, MemtoReg_out, upper_hw_en_out, lower_hw_en_out,
     output reg [1:0] ALU_sel_out,
     output reg jcntrl_out, PC_en_out,
     //Inputs
     input wire clk, reset, jcntrl_in, PC_en_in, cache_Ready,
     input wire [9:0] rs_in, rt_in, signextendimm_in,
     //Control Unit Inputs 
     input wire [2:0] reg_writesel_in, rd_sel1_in, rd_sel2_in,
     input wire [4:0] half_word_in,
     input wire reg_write_en_in, RAM_writeEnable_in, imm_sel_in, MemtoReg_in, upper_hw_en_in, lower_hw_en_in,
     input wire [1:0] ALU_sel_in
     );

 always @(negedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        rs_out <= 10'b0000000000; 
        rt_out <= 10'b0000000000; 
        signextendimm_out <= 10'b0000000000; 
        reg_writesel_out <= 3'b0;
        rd_sel1_out <= 3'b0;
        rd_sel2_out <= 3'b0;
        half_word_out <= 5'b0;
        reg_write_en_out <= 1'b0;
        RAM_writeEnable_out <= 1'b0;
        imm_sel_out <= 1'b0;
        MemtoReg_out <= 1'b0;
        upper_hw_en_out <= 1'b0;
        lower_hw_en_out <= 1'b0;
        ALU_sel_out <= 2'b0;
        jcntrl_out <= 1'b0;
        PC_en_out <= 1'b1;
        
     end
     else if (cache_Ready == 1)  begin
        rs_out <= rs_in; 
        rt_out <= rt_in; 
        signextendimm_out <= signextendimm_in; 
        reg_writesel_out <= reg_writesel_in;
        rd_sel1_out <= rd_sel1_in;
        rd_sel2_out <= rd_sel2_in;
        half_word_out <= half_word_in;
        reg_write_en_out <= reg_write_en_in;
        RAM_writeEnable_out <= RAM_writeEnable_in;
        imm_sel_out <= imm_sel_in;
        MemtoReg_out <= MemtoReg_in;
        upper_hw_en_out <= upper_hw_en_in;
        lower_hw_en_out <= lower_hw_en_in;
        ALU_sel_out <= ALU_sel_in;
        jcntrl_out <= jcntrl_in;
        PC_en_out <= PC_en_in;
     
     end
  end
endmodule

module tb_decode_execute_reg();
      wire [9:0] rs_out, rt_out, signextendimm_out;
    //Control Unit Outputs 
      wire [2:0] reg_writesel_out, rd_sel1_out, rd_sel2_out;
      wire [4:0] half_word_out;
      wire reg_write_en_out, RAM_writeEnable_out, imm_sel_out, MemtoReg_out, upper_hw_en_out, lower_hw_en_out;
      wire [1:0] ALU_sel_out;
      wire jcntrl_out, PC_en_out;
     //Inputs
      reg clk, reset, jcntrl_in, PC_en_in, cache_Ready;
      reg [9:0] rs_in, rt_in, signextendimm_in;
     //Control Unit Inputs 
      reg [2:0] reg_writesel_in, rd_sel1_in, rd_sel2_in;
      reg [4:0] half_word_in;
      reg reg_write_en_in, RAM_writeEnable_in, imm_sel_in, MemtoReg_in, upper_hw_en_in, lower_hw_en_in;
      reg [1:0] ALU_sel_in;
    
     decode_execute_reg SUT(
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
    .jcntrl_out(jcntrl_out),
    .PC_en_out(PC_en_out),
    
    //Inputs  
    .clk(clk),
    .reset(reset),
    .jcntrl_in(jcntrl_in),
    .PC_en_in(PC_en_in),
    .cache_Ready(cache_Ready),
    .rs_in(rs_in),
    .rt_in(rt_in),
    .signextendimm_in(signextendimm_in),
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
    
     parameter PERIOD = 10;
    
     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
    
     initial begin
         reset = 1'b1;                                               #PERIOD; //test reset
         reset = 1'b0;
         PC_en_in = 1'b1;   cache_Ready = 1'b1;
         rs_in = 10'b01; rt_in = 10'b1; signextendimm_in = 10'b0; 
         reg_writesel_in = 3'b010;
         half_word_in = 5'b1;
         reg_write_en_in = 1'b1; RAM_writeEnable_in = 1'b0; 
         imm_sel_in = 1'b1; MemtoReg_in = 1'b0; upper_hw_en_in = 1'b0; lower_hw_en_in = 1'b0;
         jcntrl_in = 1'b0; rd_sel1_in = 3'b101; rd_sel2_in = 3'b110; 
         ALU_sel_in = 2'b00;                                                                        #PERIOD; 
         PC_en_in = 1'b0;
         rs_in = 10'b111; rt_in = 10'b10; signextendimm_in = 10'b11; 
         reg_writesel_in = 3'b100;
         half_word_in = 5'b1111;
         reg_write_en_in = 1'b0; RAM_writeEnable_in = 1'b1;
         imm_sel_in = 1'b0; MemtoReg_in = 1'b1; upper_hw_en_in = 1'b1; lower_hw_en_in = 1'b1; 
         ALU_sel_in = 2'b10; 
         jcntrl_in = 1'b1; rd_sel1_in = 3'b111; rd_sel2_in = 3'b000;                                                                         
                                                                                                    #PERIOD; 
         PC_en_in = 1'b1;   cache_Ready = 1'b0;
         rs_in = 10'b01; rt_in = 10'b1; signextendimm_in = 10'b0; 
         reg_writesel_in = 3'b010;
         half_word_in = 5'b1;
         reg_write_en_in = 1'b1; RAM_writeEnable_in = 1'b0; 
         imm_sel_in = 1'b1; MemtoReg_in = 1'b0; upper_hw_en_in = 1'b0; lower_hw_en_in = 1'b0;
         jcntrl_in = 1'b0; rd_sel1_in = 3'b101; rd_sel2_in = 3'b110; 
         ALU_sel_in = 2'b00;                                                                        #PERIOD;  
         
         
         
     end
endmodule