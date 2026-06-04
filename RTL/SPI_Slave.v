module SPI_Slave (
    input  CS,  
    input SCLK, 
    input reset,
    input [1:0] Mode,
    input  MOSI, 
    output MISO
 );
    
    reg [7:0] Data_In = 8'h0;
    reg [7:0] Stored = 8'h0;
    reg [2:0] Bit_Counter = 3'h7;

    reg phase;

    wire CPOL = Mode[0];
    wire CPHA = Mode[1];

    assign MISO = Stored[Bit_Counter];

    always@(SCLK or reset)begin
        if(reset)begin
            Data_In <= 8'h0;
            Stored <= 8'h0;
            Bit_Counter <= 3'h7;
            Bit_Counter_O <= 3'h7;
            phase <= CPHA;       // Phase of the Mode

        end else if(~CS)begin    // Only enables when Chip select(CS) is low

            if(phase==0)begin
                if(SCLK== (CPOL==CPHA))begin // Sample edge
                    Data_In[Bit_Counter] <= MOSI;
                end else begin
                    if(Bit_Counter==0)
                        Stored <= Data_In;
                    Bit_Counter <= Bit_Counter - 1;
                end
            end else
                phase <= 1'b0;

        end
    end
    
endmodule