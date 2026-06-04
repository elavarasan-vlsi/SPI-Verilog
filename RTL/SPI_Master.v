module SPI_Master(
    input  clk,
    input  reset,
    input  RW,                 // RW = 1 Read | RW = 0 Write
    input  enable,             // Start transaction
    input [1:0] Mode,
    input  MISO, 
    input  [7:0] Data_In,      // Input data for MOSI
    output reg MOSI,
    output reg [7:0] Data_Out, // Read data from MISO
    output reg SCLK,
    output reg write_en,       // Write Data_Out into Rx_FIFO
    output Read_en             // Read Data from Tx_FIFO
 );
    reg [2:0] Bit_Counter;
    reg [3:0] clock_tick;
    reg [7:0] Reg_Data;  
    reg trig;

    localparam  IDLE = 2'h0, READ = 2'h1, DATA = 2'h2;

    wire CPOL = Mode[0];  // Clock polarity
    wire CPHA = Mode[1];  // Clock phase

    reg [1:0] state;
    
    assign Read_en = (enable && (state==IDLE));

    always@(posedge clk)begin
        if(reset)begin
            clock_tick  <= 4'h0;
            Bit_Counter <= 3'h7;
            Data_Out <= 8'h0;
            Reg_Data <= 8'h0;
            state <= IDLE;
            MOSI <= 1'b0;
            trig <= 1'b0;
            SCLK <= CPOL;
            write_en <= 1'b0;
    
        end else begin

            case (state)
                IDLE : begin
                    trig <= 1'b0;
                    clock_tick <= 4'b0;
                    state <= enable ? READ : IDLE;
                    SCLK <= CPOL;         // Idle state
                end 

                READ : begin
                    clock_tick <= 4'b1;
                    Reg_Data <= Data_In;   // Store data from Data_In register
                    MOSI <= Data_In[7];
                    Bit_Counter <= 3'h7;
                    state <= DATA;
                end

                DATA : begin
                    trig <= 1'b1;
                    clock_tick <= (clock_tick==4'h9) ? 4'h0 : clock_tick + 1;

                    if(clock_tick==9 || clock_tick==4)
                        SCLK <= ~SCLK;                 // Generating serial clock

                    if(clock_tick==(CPHA ? 9 : 4))begin  // Sample edge
                        Bit_Counter <= Bit_Counter - 1;   // Byte wraps 0 to 7 after 0-1
                        Data_Out[Bit_Counter] <= MISO;    // Reads bit from MISO
                    end

                    if(clock_tick==(CPHA ? 4 : 9))begin  // Shift edge
                        MOSI <= Reg_Data[Bit_Counter];   // Write bit from Reg_Data
                    end
                            
                    state <= (Bit_Counter==7 && clock_tick==0) ? IDLE : DATA;
                end

                default : state <= IDLE;
            endcase

            write_en <= (state==IDLE) && trig && RW;

        end
    end

endmodule 