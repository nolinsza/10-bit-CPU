module FetchUnit(
     output wire [9:0] dout,
     output wire cout,
     input wire clk, reset, en, ctrl, cin,
     input wire [9:0] la, val1);
     
     wire [9:0] inc_PC, PC;
     
     PC_reg PC_Reg(.dout(PC), .clk(clk), .reset(reset), .en(en), .din(dout));
     adder10 add1(.sum(inc_PC), .cout(cout), .A(PC),.B(val1),.cin(cin));
     
     mux2x1_10 PC_mux(.mout(dout), .A(inc_PC), .B(la), .SW(ctrl));
     
endmodule

module tb_FetchUnit ();
    wire [9:0] dout;
    wire cout;
    reg clk, reset, en, ctrl, cin;
    reg [9:0] la, val1;

 FetchUnit SUT(.dout(dout), .cout(cout), .clk(clk), .reset(reset), .en(en), .ctrl(ctrl), .cin(cin), .la(la), .val1(val1));

 parameter PERIOD = 10;

 initial clk = 1'b0; //clock starts on 0
 always #(PERIOD/2) clk = ~clk;

 initial begin
     reset = 1'b1; la = 4'b1111; val1 = 10'b1;                      #PERIOD;
     reset = 1'b0; ctrl =1'b0; en = 1'b1; cin=1'b0;                 #PERIOD;
                                                                    #PERIOD;
    ctrl = 1'b1;                                                    #PERIOD;
    ctrl=1'b0;                                                      #PERIOD;
                                                                    #PERIOD;
                                                                    #PERIOD;
 end
endmodule
