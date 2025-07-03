module stage1(
    output wire [9:0] instruction_out,
    input wire clk, reset, j_cntrl, pc_en, pc_hazard, E, F, cache_Ready,
    input wire [9:0] LA_IF, LA_EX, LA_M
    );
    
    
    wire [9:0] PC_LA, incPC, PC_reg_out, instruction_in, PC_or_incPC, pc_in, la, la_F;
    
    mux2x1_10 LA_sel1(.mout(la_F), .A(LA_IF), .B(LA_M), .SW(F)); 
    
    mux2x1_10 LA_sel2(.mout(la), .A(la_F), .B(LA_EX), .SW(E)); 
    
    mux2x1_10 PC_incPC (.mout(PC_or_incPC), .A(incPC), .B(pc_in), .SW(pc_hazard)); 
    
    mux2x1_10 PC_j_mux(.mout(PC_LA), .A(PC_or_incPC), .B(la), .SW(j_cntrl));                    //A if SW is 0  

    PC_reg PC_Reg(.dout(PC_reg_out), .clk(clk), .reset(reset), .en(pc_en), .din(PC_LA));
    
    adder10 add1(.sum(incPC), .cout(cout), .A(pc_in),.B(10'b1),.cin(1'b0));         //Increment PC
    
    instructionMemory ROM(.ReadData(instruction_in), .Address(PC_reg_out));
    
    IF_reg IF (.instruction_out(instruction_out), .PC_out(pc_in), .clk(clk), .reset(reset), .cache_Ready(cache_Ready), .instruction_in(instruction_in), .PC_in(PC_reg_out));
    
endmodule

module tb_stage1();
    wire [9:0]instruction_out;
    reg clk, reset, j_cntrl, pc_en, pc_hazard;
    reg [9:0] la;
    
    stage1 SUT(.instruction_out(instruction_out), .clk(clk), .reset(reset), .j_cntrl(j_cntrl), .pc_en(pc_en),
    .pc_hazard(pc_hazard), .la(la));
    
    parameter PERIOD = 10;
    initial clk = 1'b0; //clock starts on 0
    always #(PERIOD/2) clk = ~clk;
    
    initial begin
    reset=1'b1;  #PERIOD;
    reset=1'b0; la=10'b01; j_cntrl=1'b0; pc_en=1'b1; #PERIOD;
                                                     #PERIOD;
                                                     #PERIOD;
    j_cntrl=1'b1;                                    #PERIOD;
                                                     #PERIOD;
    j_cntrl=1'b0; pc_hazard=1'b1;                    #PERIOD;
                                                     #PERIOD;
                         
    end
endmodule