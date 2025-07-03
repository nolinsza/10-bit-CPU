
module controlunit(
    //Output to reg_file
    output reg [2:0] reg_writesel, reg_read1sel, reg_read2sel,
    output reg reg_write_en,
    
    //Output to ALU
    output reg [1:0] ALU_sel,
    output reg [2:0] immVal,
    output reg imm_sel,
    
    //Output to Fetch Unit Check Module 
    output reg [1:0] fetch_cntrl,
    output reg PC_en,
    
    //Output to RAM 
    output reg RAM_writeEnable,
           
    //output to load hw module
    output reg [4:0] half_word,
    output reg upper_hw_en,lower_hw_en,
    
    //if 1 read from memory, if 0 read ALU result 
    output reg MemtoReg,
    
    //Input 
    input wire [9:0] instruction
    );
    
    always @(instruction) begin 
        if (instruction[9:7] != 3'b100 && instruction[9:7] != 3'b101) begin
        
           reg_writesel=instruction[6:4];
           reg_read1sel=instruction[6:4];
           reg_read2sel=instruction[3:1];
           immVal=instruction[3:1];
           half_word=instruction[4:0];
       
       end
       
       else begin
            reg_writesel[1:0]=instruction[6:5];
            reg_writesel[2]=1'b0;
           reg_read1sel=instruction[6:4];
           reg_read2sel=instruction[3:1];
           immVal=instruction[3:1];
           half_word=instruction[4:0];
       end
       
      
       case(instruction[9:7])
            //Opcode:000
            3'b000:
                //Opcode:000 Func:0 (Add)
                if (instruction[0]==0) begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b00;
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end 
                
                //Opcode:000 Func:1 (Subtract)
                else begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b01;
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end
             
             //Opcode: 001
             3'b001:
                //Opcode:001 Func:0 (lw)
                if (instruction[0]==0) begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b00;  //X
                    fetch_cntrl=2'b00;  
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;   //X
                    MemtoReg=1'b1;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end 
                
                //Opcode:001 Func:1 (sw)
                else begin
                    reg_write_en=1'b0;
                    ALU_sel=2'b00;  //X
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b1;
                    imm_sel=1'b0;   //X
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end
                
             //Opcode: 010
             3'b010:
                //Opcode:010 Func:0 (bge)
                if (instruction[0]==0) begin
                    reg_write_en=1'b0;
                    ALU_sel=2'b01;  
                    fetch_cntrl=2'b01;  
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;
                    MemtoReg=1'b0; //X
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end 
                
                //Opcode:010 Func:1 (bne)
                else begin
                    reg_write_en=1'b0;
                    ALU_sel=2'b01; 
                    fetch_cntrl=2'b10;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0; 
                    MemtoReg=1'b0;  //X
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end
             
             //Opcode:011
             3'b011:
                //Opcode:011 Func:0 (nor)
                if (instruction[0]==0) begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b11;  
                    fetch_cntrl=2'b00;  
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;   
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end 
                
                //Opcode:011 Func:1 (shift)
                else begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b10;  
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;   
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end
             
             //Opcode:100
             3'b100:begin
                    //No function bit (luhw)
                    reg_write_en=1'b1;
                    ALU_sel=2'b00;  //X  
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b0;  
                    imm_sel=1'b0;   //x   
                    MemtoReg=1'b0;
                    upper_hw_en=1'b1;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
             end
             
             //Opcode:101    
             3'b101:begin
                    //No function bit (llhw)
                    reg_write_en=1'b1;
                    ALU_sel=2'b00;  //X  
                    fetch_cntrl=2'b00;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0;   //x   
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b1;
                    PC_en=1'b1;
             end    
             
             //Opcode:110
             3'b110:
                //Opcode:110 Func:0 (addi)
                if (instruction[0]==0) begin
                    reg_write_en=1'b1;
                    ALU_sel=2'b00;   
                    fetch_cntrl=2'b00;  
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b1;   
                    MemtoReg=1'b0;
                    upper_hw_en=1'b0;
                    lower_hw_en=1'b0;
                    PC_en=1'b1;
                end 
                
                //Opcode:110 Func:1 (j)
                else begin
                    reg_write_en=1'b0;
                    ALU_sel=2'b00; //X  
                    fetch_cntrl=2'b11;
                    RAM_writeEnable=1'b0;
                    imm_sel=1'b0; //X  
                    MemtoReg=1'b0; //X
                    upper_hw_en=1'b0; //X
                    lower_hw_en=1'b0; //X
                    PC_en=1'b1;
                end
              
              //Opcode:111
              3'b111:begin
                  //No function bit (halt)
                  reg_write_en=1'b0;
                  ALU_sel=2'b00;  //X  
                  fetch_cntrl=2'b00;
                  RAM_writeEnable=1'b0;
                  imm_sel=1'b0;   //x   
                  MemtoReg=1'b0;
                  upper_hw_en=1'b0;
                  lower_hw_en=1'b0;
                  PC_en=1'b0;
             end
         
       endcase  
    end
    
endmodule

module tb_controlunit ();
 //Output to reg_file
    wire [2:0] reg_writesel, reg_read1sel, reg_read2sel;
    wire reg_write_en;
    
    //Output to ALU
    wire [1:0] ALU_sel;
    wire [2:0] immVal;
    wire imm_sel;
    
    //Output to Fetch Unit Check Module 
    wire [1:0] fetch_cntrl;
    wire PC_en;
    
    //Output to RAM 
    wire RAM_writeEnable;
           
    //output to load hw module
   wire [4:0] half_word;
   wire upper_hw_en,lower_hw_en;
    
    //if 1 read from memory, if 0 read ALU result 
    wire MemtoReg;
    
    //Input 
    reg [9:0] instruction;
    
    controlunit SUT(.reg_writesel(reg_writesel), .reg_read1sel(reg_read1sel), .reg_read2sel(reg_read2sel), .reg_write_en(reg_write_en),
    .ALU_sel(ALU_sel), .immVal(immVal), .imm_sel(imm_sel), .fetch_cntrl(fetch_cntrl), .PC_en(PC_en), .RAM_writeEnable(RAM_writeEnable), .half_word(half_word), .upper_hw_en(upper_hw_en), .lower_hw_en(lower_hw_en), .MemtoReg(MemtoReg), .instruction(instruction));
    
    parameter PERIOD = 10;
    
    initial begin 
        
        instruction = 10'b0000110010;   #PERIOD;   //add $t0, $s0
        instruction = 10'b0001101101;   #PERIOD;   //sub $t3, $t3		
        instruction = 10'b0011000100;   #PERIOD;   //lw $t1, $s1
        instruction = 10'b0011000101;   #PERIOD;   //sw $t1, $s1		
        instruction = 10'b0100111000;   #PERIOD;   //bge $t0, $t1
        instruction = 10'b0100111111;   #PERIOD;   //bne $t0, $Zero	
        instruction = 10'b0110110110;   #PERIOD;   //nor $t0, $t0
        instruction = 10'b0110010111;   #PERIOD;   //sl $s0, $t0
        instruction = 10'b1000000000;   #PERIOD;   //luhw $la, 0 	
        instruction = 10'b1010001000;   #PERIOD;   //llhw $la, 8	
        instruction = 10'b1100011010;   #PERIOD;   //addi $s0, -1 	
        instruction = 10'b1100000001;   #PERIOD;   //j 
        instruction = 10'b1110000000;   #PERIOD;   //halt
        
        
    
    end
    
    endmodule
    

