module ALU(
    output wire [9:0] result,
    output wire cout, bout,
    input wire [9:0] rs,rt,
    input wire [1:0] opcode,
    input wire cin, bin
    );
    
    wire [9:0] add_result, sub_result, shift_result, nor_result; //local wires for possible alu results
    
    adder10 addALU(add_result [9:0], cout, rs [9:0], rt [9:0], cin);
    
    sub10bit subtractALU(sub_result[9:0], bout, rs [9:0], rt[9:0], bin);
    
    shift shiftALU(shift_result[9:0], rt [9:0], rs [9:0]);
    
    //nor gate 
    nor(nor_result[0], rs[0],rt[0]);
    nor(nor_result[1], rs[1], rt[1]);
    nor(nor_result[2], rs[2], rt[2]);
    nor(nor_result[3], rs[3], rt[3]);
    nor(nor_result[4], rs[4], rt[4]);
    nor(nor_result[5], rs[5], rt[5]);
    nor(nor_result[6], rs[6], rt[6]);
    nor(nor_result[7], rs[7], rt[7]);
    nor(nor_result[8], rs[8], rt[8]);
    nor(nor_result[9], rs[9], rt[9]);
        
    //ALU Mux 
    //0 selects add, 1 selects subtract, 2 selects shift, 3 selects nor
    mux4x1 ALUMux(result [9:0], add_result[9:0], sub_result[9:0], shift_result[9:0], nor_result[9:0], opcode [1:0]);   

endmodule

module tb_ALU();
    wire [9:0] result;
    wire cout, bout;
    reg [9:0] rs,rt;
    reg [1:0] opcode;
    reg cin, bin;
    
    ALU SUT(.result(result), .cout(cout), .bout(bout), .rs (rs), .rt(rt), .opcode(opcode), .cin(cin), .bin(bin));
    
    parameter PERIOD = 10;
    
    initial begin
        
        //initialize inputs 
        rs = 10'b0000000000;
        rt = 10'b0000000000;
        cin = 1'b0;
        bin = 1'b0;
        opcode = 2'b00;
        #PERIOD;
        
        //test addition
        rs = 10'b0000000011; //3
        rt = 10'b0000000101; //5
        opcode = 2'b00; //add
        #PERIOD;
        
        //test subtraction
        rs = 10'b0000001010; //10
        rt = 10'b0000000011; //3
        opcode = 2'b01; //subract
        #PERIOD;
        
        //test shift
        rs = 10'b0000000010; 
        rt = 10'b0000000001;
        opcode = 2'b10; //shift left
        #PERIOD;
        
        rs = 10'b0000000010; 
        rt = 10'b1111111111;
        opcode = 2'b10; //shift right 
        #PERIOD;
        
        //test nor
        rs = 10'b1111111100;
        rt = 10'b0011101100;
        opcode = 2'b11; //nor
        #PERIOD;
        
    end
endmodule
    

