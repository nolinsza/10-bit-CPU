module instructionMemory(ReadData, Address);
    output reg[9:0] ReadData;
    input [9:0] Address;
    reg [9:0] memory[1023:0]; //16 locations of byte size memory
    //initialize memory (your program(s) machine code goes here)
    initial begin
        memory[0]=10'b0010011110;	//lw $s0, $0   initalize array length in s0
        memory[1]=10'b1100100010;   //addi $s1, 1   initialize pointer 
            
        memory[2]=10'b1100011110;	//ADDI $S0, -1          loop 1 less than the length, outer counter	
        memory[3]=10'b0010011111;   //sw $s0, $0            //save n-1 in memory to reset inner counter
        
        memory[4]=10'b0001101101;   //sub $t3, $t3          clear $t3	
        memory[5]=10'b0001100100;   //add $t3, $s1          Save array address to t3
         
        memory[6]=10'b0000100101;   //Lout: sub $s1,$s1        $s1 clear $s1
        memory[7]=10'b0000101100;   //add $s1, $t3          s1 = array address	
        memory[8]=10'b0010111110;   //lw t0,$0              reset the inner counter
        
        
        memory[9]=10'b0011000100;   // Lin: lw $t1, $s1     t1=Element[n]
        memory[10]=10'b1100100010;	//addi $s1, 1           increment pointer 
        memory[11]=10'b0011010100;  //lw $t2, $s1           $t2=Element[n+1]	
        memory[12]=10'b1000000000;  //luhw $la,0	             
        memory[13]=10'b1010010011;  //llhw $la, 19          la to branch location continue                
        memory[14]=10'b0101001010;  //bge $t1, $t2          branch continue if E[n] ? E[n+1] 
        memory[15]=10'b0011000101;  //sw $t1, $s1           stores E[n] where E[n+1] was 
        memory[16]=10'b1100101110;  //addi $s1, -1          decrements the pointer 
        memory[17]=10'b0011010101;  //sw $t2, $s1           Stores E[n+1] where E[n] was 
        memory[18]=10'b1100100010;  //addi $s1, 1           increment the pointer before loop
        	
        memory[19]=10'b1100111110;  //continue: addi $t0, -1 decrement the inner loop counter 	
        memory[20]=10'b1000000000;  //luhw $la, 0                     
        memory[21]=10'b1010001001;  //llhw $la,9           la with branch location Lin         
        memory[22]=10'b0100111111;  //bne $t0, $Zero        branch Lin if counter is not 0
        memory[23]=10'b1100011110;  //addi $s0, -1          decrement outer counter
        memory[24]=10'b1000000000;  //luhw $la, 0                
        memory[25]=10'b1010000110;  //llhw $la, 6          la to branch location Lout           
        memory[26]=10'b0100011111;  //bne $s0, $zero        branch Lout if counter not 0
        memory[27]=10'b1110000000;  //end                   halt

           
    end                                      	
    
                                       
    
    always@(Address) begin 
        ReadData = memory[Address];
    end
endmodule

module tb_ROM();
    wire [9:0] ReadData;
    reg [9:0] Address;
    
    instructionMemory SUT(.ReadData(ReadData), .Address(Address));
    
    parameter PERIOD = 10;
    
   initial begin 
       Address = 10'b0;         #PERIOD; 
       Address = 10'b1;         #PERIOD;
       Address = 10'b10;        #PERIOD;
       Address = 10'b11;        #PERIOD; 
   end
endmodule