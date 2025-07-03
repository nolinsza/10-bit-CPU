
module M_reg(
    output reg [9:0] memory_res_out, ALU_result_out,
    
    //Control Unit Outputs 
     output reg [2:0] reg_writesel_out,
     output reg reg_write_en_out, MemtoReg_out, PC_en_out,
     
     //Inputs
     input wire clk, reset,
     input wire [9:0] memory_res_in, ALU_result_in,
     
     //Cache
     input wire cache_Ready, PC_en_in,
     
     //Control Unit Inputs 
     input wire [2:0] reg_writesel_in,
     input wire reg_write_en_in, MemtoReg_in
     );

 always @(negedge clk) begin //triggered by clock rising edge
     if (reset == 1'b1) begin
        memory_res_out <= 10'b0000000000;
        ALU_result_out <= 10'b0000000000; 
        reg_writesel_out <= 3'b0;
        reg_write_en_out <= 1'b0;
        MemtoReg_out <= 1'b0;
        PC_en_out <= 1'b1;
     end
     
     else if (cache_Ready == 1) begin
        memory_res_out <= memory_res_in;
        ALU_result_out <= ALU_result_in; 
        reg_writesel_out <= reg_writesel_in;
        reg_write_en_out <= reg_write_en_in;
        MemtoReg_out <= MemtoReg_in;
        PC_en_out <= PC_en_in;
     
     end
  end
endmodule

module tb_M_reg();
     wire memory_res_out, ALU_result_out;
     
     //Control Unit Outputs 
     wire [2:0] reg_writesel_out;
     wire reg_write_en_out, MemtoReg_out, PC_en_out;
     
     //Inputs
     reg clk, reset;
     reg [9:0] memory_res_in, ALU_result_in;
     
     //Cache
     reg  cache_Ready, PC_en_in;
      
     //Control Unit Inputs 
     reg [2:0] reg_writesel_in;
     reg reg_write_en_in, MemtoReg_in;
   
     M_reg SUT(.memory_res_out(memory_res_out), .ALU_result_out(ALU_result_out), .reg_writesel_out(reg_writesel_out),
     .reg_write_en_out(reg_write_en_out), .MemtoReg_out(MemtoReg_out), .PC_en_out(PC_en_out),
     .clk(clk), .reset(reset), .memory_res_in(memory_res_in), .ALU_result_in(ALU_result_in), .cache_Ready(cache_Ready), .PC_en_in(PC_en_in), .reg_writesel_in(reg_writesel_in), 
     .reg_write_en_in(reg_write_en_in), .MemtoReg_in(MemtoReg_in)); 
     
     parameter PERIOD = 10;
    
     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
     
     initial begin
         reset = 1'b1;                                                  #PERIOD; //test reset
         reset = 1'b0; 
         memory_res_in = 10'b1; ALU_result_in = 10'b0000000011; cache_Ready=1'b1;
         reg_writesel_in = 3'b010;
         reg_write_en_in = 1'b1;
         MemtoReg_in = 1'b0;
         PC_en_in=1'b1;
         #PERIOD; 
         
         
         cache_Ready=1'b1;
         PC_en_in=1'b0;
         memory_res_in = 10'b10;
         reg_writesel_in = 3'b100;
         reg_write_en_in = 1'b0;
         MemtoReg_in = 1'b1; 
         #PERIOD; 
         
         cache_Ready=1'b1;
         PC_en_in=1'b1;
         memory_res_in = 10'b11;
         reg_writesel_in = 3'b111;
         reg_write_en_in = 1'b1;
         MemtoReg_in = 1'b1; 
         #PERIOD; 
         
         cache_Ready=1'b1;
         PC_en_in=1'b1;
         memory_res_in = 10'b11;
         reg_writesel_in = 3'b111;
         reg_write_en_in = 1'b1;
         MemtoReg_in = 1'b1; 
         #PERIOD; 
         
     end
endmodule