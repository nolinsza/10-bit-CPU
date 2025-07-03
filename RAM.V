module RAM(
    inout wire [19:0] data,
    output reg ready, 
    input wire clk,
    input wire [1:0] WriteEnable,
    input wire [8:0] Address_in 
    );
    reg [9:0] memory[20:0]; //memory is really [1023:0] [20:0] is used for simulation 
    wire [19:0] memory_read, memory_write;
    reg [19:0] memory_read_reg;
    reg current_state, next_state;
    reg [9:0] Address;
    
    localparam Idle = 1'b0;
    localparam Write = 1'b1;
    
    assign data = (WriteEnable != 0) ?
        20'bz :        //writing
        memory_read;   //reading
        
    assign memory_write = data;
    assign memory_read = memory_read_reg;

    always@(*) begin 
    
    Address [9:1] = Address_in;
    Address [0] = 1'b0;
    
    memory_read_reg [9:0] = memory[Address];
    memory_read_reg [19:10] = memory[Address+1];
    
        case (current_state)
        
            Idle: begin
    
                //read
                if(WriteEnable == 0) begin 
                    next_state = Idle;
                    ready = 1'b1;
                end
                
                //write
                else begin 
                    next_state = Write; 
                    ready = 1'b0;  
                end               
            end
            
            Write: begin
                next_state = Idle;
                ready = 1'b1;
            end   
        endcase
    end
    
    always@(posedge clk) begin 
    
        current_state = next_state;
     
        //write word 1 
        if (WriteEnable == 2'b01) begin     
             memory[Address] = memory_write[9:0];
        end
        //write word 2 
        else if (WriteEnable == 2'b10) begin 
            memory[Address+1] = memory_write[19:10];
        end
        //write both words 
        else if (WriteEnable == 2'b11) begin
            memory[Address] = memory_write[9:0];
            memory[Address+1] = memory_write[19:10];
        end 
        
                      
    end
    
    
    //initialize memory 
    initial begin
        
        //Set the RAM to begin in IDLE
        current_state = Idle;
        
        memory[0] <= 10'b0000010100; 
        memory[1] <= 10'b0000000001; 
        memory[2] <= 10'b0000000010; 
        memory[3] <= 10'b0000000011; 
        memory[4] <= 10'b0000000100; 
        memory[5] <= 10'b0000000101; 
        memory[6] <= 10'b0000000110; 
        memory[7] <= 10'b0000000111; 
        memory[8] <= 10'b0000001000; 
        memory[9] <= 10'b0000001001; 
        memory[10] <= 10'b0000001010;
        memory[11] <= 10'b0000001011;
        memory[12] <= 10'b0000001100;
        memory[13] <= 10'b0000001101;
        memory[14] <= 10'b0000001110;
        memory[15] <= 10'b0000001111;
        memory[16] <= 10'b0000010000;
        memory[17] <= 10'b0000010001;
        memory[18] <= 10'b0000010010;
        memory[19] <= 10'b0000010011;
        memory[20] <= 10'b0000010100;
        
     
    end
endmodule

module tb_RAM();
    //inout
    wire [19:0] data, data_read;
    wire ready;
    reg clk;
    reg [1:0] WriteEnable;
    reg [8:0] Address_in;
    
    RAM SUT(.data(data), .ready(ready), .clk(clk), .WriteEnable(WriteEnable), .Address_in(Address_in));
    
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
        WriteEnable = 2'b00; data_write = 20'bz; Address_in = 9'b0;     #PERIOD;
        
        //Test write word 1  
        WriteEnable = 2'b01; data_write = 20'b1; Address_in = 9'b0;     #PERIOD;
        
        //Test write word 2 
        WriteEnable = 2'b10; data_write = 20'b11; Address_in = 9'b1;     #PERIOD;
        
        //Test write both words  
        WriteEnable = 2'b11; data_write = 20'b10; Address_in = 9'b11;     #PERIOD;
    end

endmodule