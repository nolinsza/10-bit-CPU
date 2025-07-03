module cache_Mem (
    inout wire [19:0] data,
    output reg dirty1_out, dirty2_out, valid1_out, valid2_out,
    output reg [4:0] tag_out, 
    input wire clk, dirty1_in, dirty2_in, valid1_in, valid2_in,
    input wire [4:0] tag_in,
    input wire [1:0] WriteEnable,
    input wire [3:0] index_in 
    );
    reg [28:0] index[15:0];
    wire [19:0] cache_read, cache_write;
    reg [19:0] cache_read_reg;
   
    assign data = (WriteEnable != 0) ?
        20'bz :        //writing
        cache_read;   //reading
        
    assign cache_write = data;
    assign cache_read = cache_read_reg;

    always@(*) begin 
    
        cache_read_reg [9:0] = index[index_in][21:12];      //word1
        cache_read_reg [19:10] = index[index_in][9:0];      //word2
        dirty1_out = index[index_in][22];                   //dirty1
        valid1_out = index[index_in][23];                   //valid1
        dirty2_out = index[index_in][10];                   
        valid2_out = index[index_in][11];
        tag_out = index[index_in][28:24];
    end
  
    always@(posedge clk) begin 
     
        //write word 1 
        if (WriteEnable == 2'b01) begin     
             index[index_in][21:12] <= cache_write[9:0];
             index[index_in][22] <= dirty1_in;
             index[index_in][23] <= valid1_in;
             index[index_in][28:24] <= tag_in;
        end
        //write word 2 
        else if (WriteEnable == 2'b10) begin 
           index[index_in][9:0] <= cache_write[19:10];
           index[index_in][10] <= dirty2_in;
           index[index_in][11] <= valid2_in;
           index[index_in][28:24] <= tag_in;
        end
        //write both words 
        else if (WriteEnable == 2'b11) begin
            index[index_in][21:12] <= cache_write[9:0];
            index[index_in][9:0] <= cache_write[19:10];
            index[index_in][22] <= dirty1_in;
            index[index_in][23] <= valid1_in;
            index[index_in][10] <= dirty2_in;
            index[index_in][11] <= valid2_in;
            index[index_in][28:24] <= tag_in;
        end 
        
                      
    end
    
    
    //initialize memory 
    initial begin

        //index         tag/val/dir/word1   val/dir/word2        
        index[0] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[1] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[2] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[3] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[4] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[5] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[6] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[7] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[8] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[9] <=  29'b00000_0_0_0000000000_0_0_0000000000;
        index[10] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        index[11] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        index[12] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        index[13] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        index[14] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        index[15] <= 29'b00000_0_0_0000000000_0_0_0000000000;
        
     
    end
endmodule

module tb_Cache_Mem ();
    
    wire [19:0] data, data_read;
    wire dirty1_out, dirty2_out, valid1_out, valid2_out;
    reg clk, dirty1_in, dirty2_in, valid1_in, valid2_in;
    reg [1:0] WriteEnable;
    reg [4:0] index_in;
    
    cache_Mem SUT(.data(data), .dirty1_out(dirty1_out), .dirty2_out(dirty2_out), .valid1_out(valid1_out), .valid2_out(valid2_out),
    .clk(clk), .dirty1_in(dirty1_in), .dirty2_in(dirty2_in), .valid1_in(valid1_in), .valid2_in(valid2_in),
    .WriteEnable(WriteEnable), .index_in(index_in));
    
    parameter PERIOD = 10;
    initial clk = 1'b0; 
    always #(PERIOD/2) clk = ~clk; 
    
    reg [19:0] data_write;
    assign data = (WriteEnable != 0) ?
        data_write :
        20'bz;
    
    assign data_read = data;
    
    initial begin 
        //Test read 
        dirty1_in = 1'b1; dirty2_in = 1'b1; valid1_in = 1'b1; valid2_in = 1'b1;
        WriteEnable = 2'b00; data_write = 20'bz; index_in = 5'b0;      #PERIOD;
        
        //Test write word 1  
        WriteEnable = 2'b01; data_write = 20'b1; index_in = 5'b0;     #PERIOD;
        
        //Test write word 2 
        WriteEnable = 2'b10; data_write = 20'b11; index_in = 5'b0;    #PERIOD;
        
        //Test write both words  
        WriteEnable = 2'b11; data_write = 20'b10; index_in = 5'b1;     #PERIOD;
        
        //Test read 
        WriteEnable = 2'b00; data_write = 20'bz; index_in = 5'b0;      #PERIOD;
    end
     
     

endmodule