module Hazard_Detection(
    output reg hazard, PC_hazard, A, B, C, D,
    //Inputs
    input wire  MemtoReg_ID, reg_write_en_M, MemtoReg_M, reg_write_en_EX, MemtoReg_EX,
    input wire [1:0] branch_cntrl,
    input wire [2:0] rd_sel1_ID, rd_sel1_IF, rd_sel2_IF, write_sel_EX, write_sel_M 
);

    always @(*) begin 
       
        //Stall Conditions 
        if((MemtoReg_ID == 1) && ((rd_sel1_ID == rd_sel1_IF) | (rd_sel1_ID == rd_sel2_IF))) begin 
           hazard = 1'b1;
           PC_hazard = 1'b1;
        end
        
        else if(((branch_cntrl==2'b01)|(branch_cntrl==2'b10)) && (MemtoReg_EX == 1) && ((rd_sel1_IF == write_sel_EX) | (rd_sel2_IF == write_sel_EX))) begin 
           hazard = 1'b1;
           PC_hazard = 1'b1;
        end
        
        else begin
            hazard = 1'b0;
            PC_hazard = 1'b0;
    end
    
    
        //Forwarding RS
         if((write_sel_EX == rd_sel1_IF) && (reg_write_en_EX == 1'b1) && (MemtoReg_EX == 1'b0)) begin
            A = 1'b1; B = 1'b1;     //select ALU result for RS
        end
        else if((write_sel_M == rd_sel1_IF) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b1)) begin 
            A = 1'b1; B = 1'b0;     //select MEM result for RS
        end
        else begin 
            A = 1'b0;       B = 1'b0; //Select Register Value 
        end
        
        //Forwarding RT
        if((write_sel_EX == rd_sel2_IF) && (reg_write_en_EX == 1'b1) && (MemtoReg_EX == 1'b0)) begin
            C = 1'b1; D = 1'b1;     //select ALU result for RT
        end
        else if((write_sel_M == rd_sel2_IF) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b1)) begin 
            C = 1'b1; D = 1'b0;     //select MEM result for RT
        end
        else begin 
            C = 1'b0;       D = 1'b0; //Select Register Value 
        end
    end
        
        
                  
endmodule

module tb_Hazard_Detection ();
    wire reg_write_en_out, RAM_writeEnable_out, PC_en_out;
    wire hazard; 
    reg jcntrl_ID, PC_en_in, MemtoReg_ID;
    reg [2:0] rd_sel2_ID, rd_sel1_IF, rd_sel2_IF;
    
    Hazard_Detection SUT(.reg_write_en_out(reg_write_en_out), .PC_en_out(PC_en_out), .RAM_writeEnable_out(RAM_writeEnable_out), .hazard(hazard),
    .jcntrl_ID(jcntrl_ID), .PC_en_in(PC_en_in), .MemtoReg_ID(MemtoReg_ID), .rd_sel2_ID(rd_sel2_ID), .rd_sel1_IF(rd_sel1_IF), .rd_sel2_IF(rd_sel2_IF));
    
    parameter PERIOD = 10; 
    
    initial begin 
    PC_en_in = 1'b0;                                        #PERIOD;
    PC_en_in = 1'b1;
    jcntrl_ID = 1'b1; //test nop for jcntrl 
                                                            #PERIOD;
    jcntrl_ID = 1'b0;
    MemtoReg_ID = 1'b1; rd_sel2_ID = 3'b001;  // test nop for rt = rs
    rd_sel1_IF = 3'b001; rd_sel2_IF = 3'b100;     
                                                            #PERIOD; 
                                                            jcntrl_ID = 1'b0;
    MemtoReg_ID = 1'b1; rd_sel2_ID = 3'b001;  // test nop for rt = rt
    rd_sel1_IF = 3'b111; rd_sel2_IF = 3'b001;     
                                                            #PERIOD; 
    jcntrl_ID = 1'b0;
    MemtoReg_ID = 1'b1; rd_sel2_ID = 3'b001; 
    rd_sel1_IF = 3'b011; rd_sel2_IF = 3'b110;     
                                                            #PERIOD; 
    MemtoReg_ID = 1'b0; rd_sel2_ID = 3'b001;  // test nop for rt = rt
    rd_sel1_IF = 3'b111; rd_sel2_IF = 3'b001; 
                                                            
    end
endmodule