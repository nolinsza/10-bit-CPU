module register_file(                
    //output wire [19:0] mout,                //mux outputs  
    output wire [9:0] rs_read, rt, la_out,               //la output
    input wire clk, gb_en,                        //clock and global enable 
    input wire [9:0] rs_write,              //input for registers
    input wire reset,                       //reset registers
    input wire [2:0] write_sel,             //select register to write 
    input wire [2:0] read1sel, read2sel     //select the register to read 
    );
    
     wire [9:0] s0, s1, t0, t1, t2, t3, zero; //output for register 1-7
         
    //Instantiate the registers 
    register10bit la(la_out[9:0], clk, reset, en[0], rs_write[9:0]);
    register10bit reg_so(s0[9:0], clk, reset, en[1], rs_write[9:0]);
    register10bit reg_s1(s1[9:0], clk, reset, en[2], rs_write[9:0]);
    register10bit reg_t0(t0[9:0], clk, reset, en[3], rs_write[9:0]);
    register10bit reg_t1(t1[9:0], clk, reset, en[4], rs_write[9:0]);
    register10bit reg_t2(t2[9:0], clk, reset, en[5], rs_write[9:0]); 
    register10bit reg_t3(t3[9:0], clk, reset, en[6], rs_write[9:0]);
    zeroregister reg_zero(zero[9:0], clk);
    
    wire [6:0] en;      //enables wires 
    
    //Write register select decoder
    assign en[0] = ~write_sel[0] & ~write_sel[1] & ~write_sel[2] & gb_en;
    assign en[1] =  write_sel[0] & ~write_sel[1] & ~write_sel[2] & gb_en;
    assign en[2] = ~write_sel[0] &  write_sel[1] & ~write_sel[2] & gb_en;
    assign en[3] =  write_sel[0] &  write_sel[1] & ~write_sel[2] & gb_en;
    assign en[4] = ~write_sel[0] & ~write_sel[1] &  write_sel[2] & gb_en;
    assign en[5] =  write_sel[0] & ~write_sel[1] &  write_sel[2] & gb_en;
    assign en[6] = ~write_sel[0] &  write_sel[1] &  write_sel[2] & gb_en;
    
    //Read register data using mux 
    //Mux 1: 0:la   1:s0, 2:s1, 3:t0, 4:t1, 5:t2, 6:t3, 7:zero
    mux8x1 M1(rs_read[9:0], la_out[9:0], s0[9:0], s1[9:0], t0[9:0], t1[9:0], t2[9:0], t3[9:0], zero[9:0], read1sel[2:0]);
    
    //Mux 2: 1:la   2:s0, 3:s1, 4:t0, 5:t1, 6:t2, 7:t3
    mux8x1 M2(rt[9:0], la_out[9:0], s0[9:0], s1[9:0], t0[9:0], t1[9:0], t2[9:0], t3[9:0], zero[9:0], read2sel[2:0]);  

endmodule

module tb_reg_file ();
    wire [9:0] la_out;                 //reigster outputs
    wire [9:0] rs_read, rt;                //mux outputs  
    reg clk, gb_en;                  //clock and global enable 
    reg [9:0] rs_write;                  //input for registers
    reg reset;                 //reset for registers
    reg [2:0] write_sel;             //select register to write 
    reg [2:0] read1sel, read2sel;     //select the register to read 
    
    register_file SUT(.rs_read(rs_read), .rt(rt), .la_out(la_out), .clk(clk), .gb_en(gb_en), .rs_write(rs_write), .reset(reset), .write_sel(write_sel), .read1sel(read1sel), .read2sel(read2sel));

    parameter PERIOD = 10;

     initial clk = 1'b0; //clock starts on 0
     always #(PERIOD/2) clk = ~clk;
    
     initial begin
     
       //enable reset to reset all registers
        reset = 1'b1; gb_en = 1'b1; read1sel = 3'b0; read2sel = 3'b1; #PERIOD;
        
        //disable reset
        reset = 1'b0; #PERIOD;
        
        //write a value to all registers
        rs_write = 10'b0000000001; write_sel = 3'b000; #PERIOD;  //writes 1 to la
        rs_write = 10'b0000000010; write_sel = 3'b001; #PERIOD;  //writes 2 to s0
        rs_write = 10'b0000000100; write_sel = 3'b010; #PERIOD;  //writes 4 to s1
        rs_write = 10'b0000001000; write_sel = 3'b011; #PERIOD;  //writes 8 to t0
        rs_write = 10'b0000010000; write_sel = 3'b100; #PERIOD;  //writes 16 to t1
        rs_write = 10'b0000100000; write_sel = 3'b101; #PERIOD;  //writes 32 to t2
        rs_write = 10'b0001000000; write_sel = 3'b110; #PERIOD;  //writes 64 to t3
         
        //read all the registers to verify correct values
        read1sel = 3'b000; read2sel = 3'b001; #PERIOD; //reads la and s0
        read1sel = 3'b010; read2sel = 3'b011; #PERIOD; //reads s1 and t0
        read1sel = 3'b100; read2sel = 3'b101; #PERIOD; //reads t1 and t2
        read1sel = 3'b110; read2sel = 3'b000; #PERIOD; //reads t3 and la
        
        //overwrite some registers
        rs_write = 10'b1111111111; write_sel = 3'b000; #PERIOD; //overwrites all 1s to la 
        rs_write = 10'b1010101010; write_sel = 3'b001; #PERIOD; //overwrites alternating 1s and 0s to s0 
        
        //reread both registers that were overwritten
        read1sel = 3'b000; read2sel = 3'b001; #PERIOD; //reads  la and s0
        
        //disable global enable to ensure nothing can be written when low
        gb_en = 1'b0;
        rs_write = 10'b0000001111; write_sel = 3'b010; #PERIOD; //attempt to write to s1 (should fail)
        rs_write = 10'b1111000000; write_sel = 3'b011; #PERIOD; //attempt to write to t0 (should fail)
        read1sel = 3'b010; read2sel = 3'b011; #PERIOD; //reads s1 and t0 (both should be values from earlier)
        
        //renable global enable and try again
        gb_en = 1'b1;
        rs_write = 10'b0000001111; write_sel = 3'b010; #PERIOD; //attempt to write to s1 (should succeeed)
        rs_write = 10'b1111000000; write_sel = 3'b011; #PERIOD; //attempt to write to t0 (should succeeed)
        read1sel = 3'b010; read2sel = 3'b011; #PERIOD; //reads s1 and t0 (both should have changed)
        
        //reset all registers again
        reset = 7'b1111111; gb_en = 1'b1; #PERIOD;
        read1sel = 3'b010; read2sel = 3'b011; #PERIOD; //reads s1 and t0 again should both be empty
        
      end
      
endmodule

    
    