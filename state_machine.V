module state_machine(
    
    inout wire [9:0] RS,                                                        //input/output from instrution
    inout [19:0] cache_data, RAM_data,
    output reg valid1_out, valid2_out, dirty1_out, dirty2_out,                  //outputs to cache
    output reg ready,
    output reg [1:0] write_cache,                                               //read/write cache signal
    output reg [4:0] tag_out,                                                    //tag to write to cache and address for ROM/Cache                                                 
    output reg [3:0] index_out,
    output reg [1:0] RamWriteEnable,                                            //output to RAM
        
    
    
    input wire clk, reset, valid1_in, valid2_in,                              //input from cache
    input wire dirty1_in, dirty2_in,                                          //input from cache
    input wire [4:0] tag_cache,                                               //input from cache 
    
    input wire write_in, offset_in, MemtoReg,                                               //input from insturction
    input wire [3:0] index_in,
    input wire [4:0] tag_instr,                                                    //input from instruction 
    
    input wire RAM_ready                                                        //input from RAM

);
    
    wire [9:0] RS_read, RS_write;
    reg [9:0] RS_read_reg;

    //RS inout
    assign RS = (write_in == 1) ?
        10'bz :        //writing
        RS_read;      //reading
        
    assign RS_write = RS;
    assign RS_read = RS_read_reg;
    
    //cache_data inout
    wire [19:0] cache_write, cache_read;
    reg [19:0] cache_write_reg;

    assign cache_data = (write_cache == 0) ?
        20'bz :         //reading
        cache_write;      //writing
        
    assign cache_read = cache_data;
    assign cache_write = cache_write_reg;
    
    //RAM_data inout
    wire [19:0] RAM_write, RAM_read;
    reg [19:0] RAM_write_reg;

    //RS inout
    assign RAM_data = (RamWriteEnable == 0) ?
        20'bz :         //reading
        RAM_write;      //writing
        
    assign RAM_read = RAM_data;
    assign RAM_write = RAM_write_reg;

    localparam Idle = 2'b00;        //wait for cache to complete/process hits 
    localparam WB = 2'b01;          //write back dirty values
    localparam Allocate = 2'b10;    //fetch block from memory 
    localparam Finish = 2'b11;      //write block to cache 
    
    //state register 
    reg [1:0] current_state, next_state;
    
    
    always @(*) begin 
        
        case (current_state) 
        
            Idle: begin 
                
                //Address out = address in 
                tag_out = tag_instr;
                index_out = index_in;
                
               RamWriteEnable = 2'b00;             //Do not write to RAM
               RAM_write_reg = 20'bz;              //RAM_data is input
                
                //hit and valid 
                if ((tag_cache == tag_instr) && ((offset_in == 0) && (valid1_in == 1)) | ((offset_in == 1) && (valid2_in == 1))) begin 
                
                    ready = 1'b1;
                    next_state = Idle;           
                        
                    //hit valid and read 
                    if(write_in == 0) begin              
                        write_cache = 1'b00;                //reading from cache 
                        dirty1_out = dirty1_in;             //does not matter    
                        dirty2_out = dirty2_in;             //does not matter  
                        cache_write_reg = 20'bz;
                        
                    
                        //hit valid, read, word 1 
                        if(offset_in == 0) begin
                            valid1_out = 1'b0;                  //does not matter not writing to cache
                            valid2_out = 1'b0;                  //does not mater
                            RS_read_reg = cache_read[9:0];       //read word 1 
                        end
                        
                        //hit, valid, read, word 2 
                        else begin
                            valid1_out = 1'b0;                  //does not matter not writing to cache
                            valid2_out = 1'b0;                  //does not mater            
                            RS_read_reg = cache_read[19:10];    //read word 2  
                        end
                    end
                        
                    //hit valid and write 
                    else begin               
                        
                        cache_write_reg [9:0] = RS_write;
                        cache_write_reg [19:10] = RS_write; //write RS 
                        RS_read_reg = 10'bz;                                    
                    
                        //hit valid, write, word 1 
                        if(offset_in == 0) begin
                            write_cache = 2'b01;              //only write word1 
                            dirty1_out = 1'b1;                //dirty    
                            dirty2_out = dirty2_in;           //does not change
                            valid1_out = 1'b1;                //valid
                            valid2_out = valid2_in;           //does not change
                             
                        end
                        
                        //hit, valid, write, word 2 
                        else begin
                            write_cache = 2'b10;          //only write word2
                            dirty1_out = dirty1_in;       //does not change    
                            dirty2_out = 1'b1;            //dirty
                            valid1_out = valid1_in;       //does not change   
                            valid2_out = 1'b1;            //valid             
                            end
                         end
                end
                
                         
                //Miss and Dirty and Writing or Reading 
                else if( (((offset_in == 0) && (dirty1_in == 1)) | ((offset_in == 1) && (dirty2_in == 1))) && ((write_in == 1) | (MemtoReg == 1)) ) begin       
                    next_state = WB;           
                    write_cache = 2'b00;                //Read from cache  
                    dirty1_out = 1'b0;                 //does not matter - not writing to cache     
                    dirty2_out = 1'b0;                 //does not matter - not writing to cache  
                    valid1_out = 1'b0;                 //does not matter - not writing to cache 
                    valid2_out = 1'b0;                 //does not matter - not writing to cache 
                    ready = 1'b0;
                    cache_write_reg = 20'bz;
                    if (write_in == 0) begin
                        RS_read_reg = 10'b0; //does not matter 
                    end
                    else begin
                        RS_read_reg = 10'bz;
                    end

                    
                end
                
                //Miss not dirty and Writing or Reading 
                else if( (((offset_in == 0) && (dirty1_in == 0)) | ((offset_in == 1) && (dirty2_in == 0))) && ((write_in == 1) | (MemtoReg == 1))  ) begin   
                    next_state = Allocate;            
                    write_cache = 2'b00;                //Read from cache  
                    dirty1_out = 1'b0;                 //does not matter - not writing to cache     
                    dirty2_out = 1'b0;                 //does not matter - not writing to cache  
                    valid1_out = 1'b0;                 //does not matter - not writing to cache 
                    valid2_out = 1'b0;                 //does not matter - not writing to cache  
                    ready = 1'b0;
                    cache_write_reg = 20'bz;
                    
                     if (write_in == 0) begin
                        RS_read_reg = 10'b0; //does not matter 
                    end
                    else begin
                        RS_read_reg = 10'bz;
                    end
                end
                
                //memory is not being used 
                else begin 
                    next_state = Idle;                   
                    write_cache = 2'b00;        //not writing          
                    dirty1_out = 1'b0;          //does not matter 
                    dirty2_out = 1'b0; 
                    valid1_out = 1'b0; 
                    valid2_out = 1'b0; 
                    ready = 1'b1;    
                    cache_write_reg = 20'bz;  
                    
                    if (write_in == 0) begin
                        RS_read_reg = 10'b0; //does not matter 
                    end
                    else begin
                        RS_read_reg = 10'bz;
                    end      
                end
           end          
            
            WB: begin
                cache_write_reg = 20'bz;
                ready = 1'b0;   
                //Address out = address in 
                tag_out = tag_cache; 
                index_out = index_in;
                
                //Move to allocate when RAM is Ready
                if(RAM_ready == 1) begin
                    next_state = Allocate;
                end
                
                else begin
                   next_state = WB; 
                end
                
                //Write Dirty Bits to RAM
                //Write both
                if((dirty1_in == 1)&&(valid2_in==0)) begin 
                    RamWriteEnable = 2'b11;              //Write both values to RAM
                end
                //Write word 1 
                else if (dirty1_in == 1) begin 
                    RamWriteEnable = 2'b01;              //Write word 1 to RAM
                end
                //Write Word 2 
                else begin 
                    RamWriteEnable = 2'b10;              //Write word 2 to RAM
                end
                
                RAM_write_reg = cache_read;             //write cache values to RAM
                                     
                 write_cache = 2'b00;                //Read From Cache  
                 dirty1_out = 1'b0;                 //does not matter - not writing to cache     
                 dirty2_out = 1'b0;                 //does not matter - not writing to cache  
                 valid1_out = 1'b0;                 //does not matter - not writing to cache 
                 valid2_out = 1'b0;                 //does not matter - not writing to cache 
                 
                 if (write_in == 0) begin
                        RS_read_reg = 10'b0; //does not matter 
                    end
                    else begin
                        RS_read_reg = 10'bz;
                    end
                
            end
            
            Allocate: begin 
                ready = 1'b0;
                cache_write_reg = 20'bz;
                //Address out = address in 
                tag_out = tag_instr; 
                index_out = index_in;
            
                //Move to Finish 
                next_state = Finish;
                        
                RamWriteEnable = 2'b00;             //reading from RAM
                RAM_write_reg = 20'bz;              //RAM_data is input
                write_cache = 2'b00;                //Do not write to Cache until Finish 
                
                //Do not matter 
                dirty1_out = 1'b0;
                dirty2_out = 1'b0;
                valid1_out = 1'b0;                
                valid2_out = 1'b0;      
                
                if (write_in == 0) begin
                        RS_read_reg = 10'b0; //does not matter 
                    end
                    else begin
                        RS_read_reg = 10'bz;
                    end                               
                        
            end
            
            Finish: begin
                ready = 1'b0;
                RAM_write_reg = 20'bz;
                //Address out = address in 
                tag_out = tag_instr; 
                index_out = index_in;
                
                //Set Next State Idle
                next_state = Idle; 
                                 
                //Set outputs 
                RamWriteEnable = 2'b00;             //Continue reading from RAM
                valid1_out = 1'b1;                  //Valid           
                valid2_out = 1'b1;
                write_cache = 2'b11;                //Write both words 
                
                //Read
                if (write_in == 0) begin       
                    cache_write_reg = RAM_read;
                    dirty1_out = 1'b0;              //Not dirty 
                    dirty2_out = 1'b0;
                    
                    //Read offset 0
                    if (write_in == 0) begin
                        RS_read_reg = RAM_read[19:10];         //Read word 1                   
                    end        
                    
                    //Read offset 1 
                    else begin
                         RS_read_reg = RAM_read[19:10];         //Read word 2  
                    end 
                end
                
                //Write 
                else begin
                
                RS_read_reg = 10'bz;
                  
                   //Write offset 0 
                   if (offset_in == 0) begin
                        cache_write_reg[9:0] = RS;  //Write RS to Cache
                        cache_write_reg[19:10] = RAM_read [19:10];
                        dirty1_out = 1'b1;
                        dirty2_out = 1'b0;
                   end     
                   
                   //Write offset 1 
                   else begin
                        cache_write_reg[9:0] = RAM_read [9:0];
                        cache_write_reg[19:10] = RS;
                        dirty1_out = 1'b0;
                        dirty2_out = 1'b1;
                   end
                end  
            end
        endcase
    end
    
    
    
    always @(posedge clk) begin 
        
    
        if (reset == 1) begin 
            current_state <= Idle; 
        end
    
        //Move not next stage on rising edge of clock 
        else begin 
            current_state <= next_state; 
        end
 
    end
    
endmodule 



module tb_state_machine ();

    wire [9:0] RS, RS_out;                                                     
    wire [19:0] cache_data, cache_data_out, RAM_data, RAM_data_out;
    wire valid1_out, valid2_out, dirty1_out, dirty2_out;          
    wire ready;
    wire [1:0] write_cache;                                       
    wire [4:0] tag_out;                                                                                   
    wire [3:0] index_out;
    wire [1:0] RamWriteEnable;                                    
        
    
    
    reg clk, reset, valid1_in, valid2_in;                        
    reg dirty1_in, dirty2_in;                                    
    reg [4:0] tag_cache;                                         
    reg write_in, offset_in;                                     
    reg [3:0] index_in;
    reg [4:0] tag_instr;                                                                     
    reg RAM_ready;                                                
                       
    
    state_machine SUT (
    //outputs
    .RS(RS),
    .cache_data(cache_data),
    .RAM_data(RAM_data),
    .valid1_out(valid1_out),
    .dirty1_out(dirty1_out),
    .valid2_out(valid2_out),
    .dirty2_out(dirty2_out),
    .ready(ready),
    .write_cache(write_cache),
    .tag_out(tag_out),
    .index_out(index_out),
    .RamWriteEnable(RamWriteEnable),
    
    //inputs
    .clk(clk),
    .reset(reset),
    .valid1_in(valid1_in),
    .dirty1_in(dirty1_in),
    .valid2_in(valid2_in),
    .dirty2_in(dirty2_in),
    .tag_cache(tag_cache),
    .write_in(write_in),
    .offset_in(offset_in),
    .index_in(index_in),
    .tag_instr(tag_instr),
    .RAM_ready(RAM_ready)
    );
    
    parameter PERIOD = 10;
    initial clk = 1'b0; 
    always #(PERIOD/2) clk = ~clk; 
    
    //RS inout
    reg [9:0] RS_in;
    assign RS = (write_in == 1) ? 
        RS_in :
        10'bz;
        
    assign RS_out = RS;
    
    //Cache_data inout
    reg [19:0] cache_data_in;
    assign cache_data = (write_cache == 0) ?
        cache_data_in :
        20'bz;
    
    assign cache_data_out = cache_data;
    
    
    //RAM_data inout
    reg [19:0] RAM_data_in;
    assign RAM_data = (RamWriteEnable == 0) ?
        RAM_data_in :
        20'bz;
    
    assign RAM_data_out = RAM_data;
    
    initial begin 
        reset = 1'b1;          #PERIOD;
       
        //read hit and valid 
        reset = 1'b0;
        write_in = 1'b0; offset_in = 1'b0;
        valid1_in = 1'b1; valid2_in = 1'b1;
        dirty1_in = 1'b0; dirty2_in = 1'b0; 
        tag_cache = 5'b00000; tag_instr = 5'b00000;
        index_in = 4'b0000;
        RAM_ready = 1'b1;
        
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b0;
        #PERIOD;
        
        //write hit and valid 
        write_in = 1'b1; offset_in = 1'b0;
        valid1_in = 1'b1; valid2_in = 1'b1;
        dirty1_in = 1'b0; dirty2_in = 1'b0; 
        tag_cache = 5'b00000; tag_instr = 5'b00000;
        index_in = 4'b0000;
        RAM_ready = 1'b1;
        
        RS_in = 10'b1110;
        cache_data_in = 20'bz;
        RAM_data_in = 20'b0;
        #PERIOD;
        
        //read and not valid 
        //Idle Stage 
        write_in = 1'b0; offset_in = 1'b0;
        valid1_in = 1'b1; valid2_in = 1'b1;
        dirty1_in = 1'b0; dirty2_in = 1'b0; 
        tag_cache = 5'b00001; tag_instr = 5'b00000;
        index_in = 4'b0000;
        RAM_ready = 1'b1;
        
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //Allocate Stage 
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //Finish Stage 
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;

        //write and not valid 
        //Idle Stage 
        write_in = 1'b1; offset_in = 1'b0;
        valid1_in = 1'b1; valid2_in = 1'b1;
        dirty1_in = 1'b0; dirty2_in = 1'b0; 
        tag_cache = 5'b00001; tag_instr = 5'b00000;
        index_in = 4'b0000;
        RAM_ready = 1'b1;
        
        RS_in = 10'b111;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //Allocate Stage 
        RS_in = 10'b111;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //Finish Stage 
        RS_in = 10'b111;
        cache_data_in = 20'bz;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //read and not valid with dirty bit  
        //Idle Stage 
        write_in = 1'b0; offset_in = 1'b0;
        valid1_in = 1'b1; valid2_in = 1'b1;
        dirty1_in = 1'b1; dirty2_in = 1'b0; 
        tag_cache = 5'b00001; tag_instr = 5'b00000;
        index_in = 4'b0000;
        RAM_ready = 1'b1;
        
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;
        
        //WB Stage  
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'bz;
        RAM_ready = 1'b0;                   //extra cycle for writing to RAM
        #PERIOD;
        
        //Allocate Stage
        RAM_ready = 1'b1;
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'bz;
        #PERIOD;
        
        //Finish Stage 
        RS_in = 10'bz;
        cache_data_in = 20'b11110000000111;
        RAM_data_in = 20'b11000000000001110000;
        #PERIOD;

        
    end
endmodule                                         
