module EX_reg(
    output reg [9:0] rs_out, rt_out, ALU_result_out,
    
    //Control Unit Outputs 
     output reg [2:0] reg_writesel_out,
     output reg reg_write_en_out, RAM_writeEnable_out, MemtoReg_out, PC_en_out,
     
     //Inputs
     input wire clk, reset, cache_Ready, PC_en_in,
     input wire [9:0] rs_in, rt_in, ALU_result_in,
     
     //Control Unit Inputs 
     input wire [2:0] reg_writesel_in,
     input wire reg_write_en_in, RAM_writeEnable_in, MemtoReg_in
     );

 always @(negedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        rs_out <= 10'b0000000000; 
        rt_out <= 10'b0000000000;
        ALU_result_out <= 10'b0000000000; 
        reg_writesel_out <= 3'b0;
        reg_write_en_out <= 1'b0;
        RAM_writeEnable_out <= 1'b0;
        MemtoReg_out <= 1'b0;
        PC_en_out <= 1'b1;
     end
     
     else if(cache_Ready==1'b1) begin
        rs_out <= rs_in; 
        rt_out <= rt_in;
        ALU_result_out <= ALU_result_in; 
        reg_writesel_out <= reg_writesel_in;
        reg_write_en_out <= reg_write_en_in;
        RAM_writeEnable_out <= RAM_writeEnable_in;
        MemtoReg_out <= MemtoReg_in;
        PC_en_out <= PC_en_in;
     end
  end
endmodule

module tb_EX_reg();
      wire [9:0] rs_out, rt_out, ALU_result_out;
      
    //Control Unit Outputs 
      wire [2:0] reg_writesel_out;
      wire reg_write_en_out, RAM_writeEnable_out, MemtoReg_out, PC_en_out;
      
     //Inputs
      reg clk, reset, cache_Ready, PC_en_in;
      reg [9:0] rs_in, rt_in, ALU_result_in;
      
     //Control Unit Inputs 
      reg [2:0] reg_writesel_in;
      reg reg_write_en_in, RAM_writeEnable_in, MemtoReg_in;
    
     EX_reg SUT(.rs_out(rs_out), .rt_out(rt_out), .ALU_result_out(ALU_result_out), .reg_writesel_out(reg_writesel_out),
     .reg_write_en_out(reg_write_en_out), .RAM_writeEnable_out(RAM_writeEnable_out), 
     .MemtoReg_out(MemtoReg_out), .PC_en_out(PC_en_out), .clk(clk), .reset(reset), .cache_Ready(cache_Ready), .PC_en_in(PC_en_out),
     .rs_in(rs_in), .rt_in(rt_in), .ALU_result_in(ALU_result_in), .reg_writesel_in(reg_writesel_in), .reg_write_en_in(reg_write_en_in),
     .RAM_writeEnable_in(RAM_writeEnable_in), .MemtoReg_in(MemtoReg_in)); 
    
     parameter PERIOD = 10;
    
     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
    
     initial begin
         reset = 1'b1;                                               #PERIOD; //test reset
         reset = 1'b0;
         ALU_result_in=10'b0000000001;
         rs_in = 10'b01; rt_in = 10'b1;
         reg_writesel_in = 3'b010;
         reg_write_en_in = 1'b1; RAM_writeEnable_in = 1'b0; 
         MemtoReg_in = 1'b0;
         PC_en_in = 1'b1;
         cache_Ready=1'b0;
         #PERIOD;
         
         cache_Ready=1'b1;
         ALU_result_in=10'b0000000011;
         PC_en_in=1'b0;
         rs_in = 10'b111; rt_in = 10'b10;
         reg_writesel_in = 3'b100;
         reg_write_en_in = 1'b0; RAM_writeEnable_in = 1'b1; 
         MemtoReg_in = 1'b1;
         #PERIOD; 

     end
endmodule