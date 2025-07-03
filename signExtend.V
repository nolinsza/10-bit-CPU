module sign_extend(
    output reg [9:0] signextendimm,
    input wire [2:0] imm
);

    always @(imm) begin 
        if (imm[2] == 1) begin 
            signextendimm[9:3] = 7'b1111111;
            signextendimm[2:0] = imm;
        end
        else begin 
        signextendimm[9:3] = 7'b0000000;
            signextendimm[2:0] = imm;
        end   
    end
endmodule 

module tb_sign_extend ();
   wire [9:0] signextendimm;
   reg [2:0] imm; 
   
   sign_extend SUT(.signextendimm(signextendimm), .imm(imm));
   
   parameter PERIOD = 10;
   
   initial begin 
   imm = 3'b011; #PERIOD;
   imm = 3'b100; #PERIOD;
   end
endmodule