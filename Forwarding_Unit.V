module Forwarding_Unit(
    output reg [1:0] A, B,      //Mux Control outputs 
    input wire [2:0] write_sel_EX, rd_sel1_in, write_sel_M, rd_sel2_in,
    input wire reg_write_en_EX, MemtoReg_EX, reg_write_en_M, MemtoReg_M, imm_sel
);

    always @(*) begin 
        
        //Mux Control for RS forwarding 
        if((write_sel_EX == rd_sel1_in) && (reg_write_en_EX == 1'b1) && (MemtoReg_EX == 1'b0)) begin
            A = 2'b01; 
        end
        else if((write_sel_M == rd_sel1_in) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b0)) begin 
            A = 2'b10;
        end
        else if((write_sel_M == rd_sel1_in) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b1)) begin 
            A = 2'b11;
        end
        else begin 
            A = 2'b0;
        end
        
        //Mux Control for RT forwarding 
        if((write_sel_EX == rd_sel2_in) && (reg_write_en_EX == 1'b1) && (MemtoReg_EX == 1'b0) && imm_sel == 0) begin
            B = 2'b01; 
        end
        else if((write_sel_M == rd_sel2_in) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b0) && imm_sel == 0) begin 
            B = 2'b10;
        end
        else if((write_sel_M == rd_sel2_in) && (reg_write_en_M == 1) && (MemtoReg_M == 1'b1) && imm_sel == 0) begin 
            B = 2'b11;
        end
        else begin 
            B = 2'b0;
        end
    end

endmodule 


module tb_Forwarding_Unit();
    wire [1:0] A, B;
    reg [2:0] write_sel_EX, rd_sel1_in, write_sel_M, rd_sel2_in;
    reg reg_write_en_EX, MemtoReg_EX, reg_write_en_M, MemtoReg_M;
    
    Forwarding_Unit SUT(.A(A), .B(B), .write_sel_EX(write_sel_EX), .rd_sel1_in(rd_sel1_in), .write_sel_M(write_sel_M),
    .rd_sel2_in(rd_sel2_in), .reg_write_en_EX(reg_write_en_EX), .MemtoReg_EX(MemtoReg_EX), .reg_write_en_M(reg_write_en_M), .MemtoReg_M(MemtoReg_M));
    
    parameter PERIOD = 10;
    
    initial begin 
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