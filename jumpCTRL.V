module jCNTRL (
    output reg fetchCNTRL,       //sends bit to fetch unit if jmp/bra is taken
    input wire [1:0] jsel,       // 2 bits recived from control unit
    input wire [9:0] rs, rt     //receives rs and rt values  
    );
    
    wire bout;
    wire [9:0] alu; //subtractor result 
    
    sub10bit subtractor(.dif(alu), .bout(bout), .A(rs), .B(rt), .bin(1'b0));
    
    always @(jsel, alu) begin
        case (jsel)
            2'b00: fetchCNTRL=1'b0;      //do not jump
            2'b01:                      //bge instruction
            if (alu[9] == 0) begin
                fetchCNTRL=1'b1;              //branch 
            end
            else begin
                fetchCNTRL=1'b0;               //do not branch
            end
            2'b10:                      //bne instruction
            if (alu[9:0] == 10'b0) begin
                fetchCNTRL=1'b0;              //branch 
            end
            else begin
                fetchCNTRL=1'b1;               //do not branch
            end
            2'b11: fetchCNTRL=1'b1;            //jump
        endcase
    end

endmodule 

module tb_jCNTRL ();
    wire fetchCNTRL;
    reg [1:0] jsel;
    reg [9:0] rs, rt;
    
    jCNTRL sut(.fetchCNTRL(fetchCNTRL), .jsel(jsel), .rs(rs), .rt(rt));
    
    parameter PERIOD = 10;
    
    initial begin 
        
        rs = 10'b1; rt = 10'b0;   
        jsel = 2'b00;              #PERIOD;              //test don't jump 
        jsel = 2'b01;              #PERIOD;              //test bge 
        jsel = 2'b10;              #PERIOD;              //test bne 
        jsel = 2'b11;              #PERIOD;              //test jump 
        
        rt = 10'b100;                             //test branch when rs<rt
        jsel = 2'b01;             #PERIOD;               //test bge
        jsel = 2'b10;             #PERIOD;               // test bne 
        
        rt = 10'b1;                             //test branch when rs=rt
        jsel = 2'b01;             #PERIOD;               //test bge
        jsel = 2'b10;             #PERIOD;               // test bne 
     end
endmodule 