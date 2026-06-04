
// testing reset during the data transmission
// result at Waveforms/testbench_2cb

module top_module ();
    reg clk=1;
	always #5 clk = ~clk;  // Create clock with period=10 => 100MHz

    reg reset, RW, Tx_write_en, CS, Rx_read_en;
    reg [7:0] Data_In, Tx_input;

    wire MOSI, MISO, SCLK, Tx_full, Tx_empty, Rx_full, Rx_empty, Tx_read_en, Rx_write_en;
    wire [7:0] Tx_output, Rx_output, Rx_input;

    reg [1:0] Mode = 2'h1;

    integer i;

    initial begin

        reset = 1'b0; Tx_write_en = 0;  CS = 1; RW = 0; Rx_read_en = 0;

        #25 reset = 1'b1;   // resetting all modules before test...
        #15 reset = 1'b0;
        
        #200 CS = 0;   // enable slave

        #100 Tx_input = 8'hAA;
        #1090 Tx_write_en = 1;  // storing AA byte in Tx_FIFO
        #10 Tx_write_en = 0;     

        #600 reset = 1'b1;
        #20 reset = 1'b0;

        #20e6 $finish;

    end 

    SPI_Master master(clk, reset, RW, ~Tx_empty, Mode, MISO, Tx_output, MOSI, Rx_input, SCLK, Rx_write_en, Tx_read_en);
    SPI_Slave   slave(CS, SCLK, reset, Mode, MOSI, MISO);

    FIFO_Sync Tx_FIFO(clk, reset, Tx_write_en, Tx_read_en, Tx_input, Tx_output, Tx_full, Tx_empty);
    FIFO_Sync Rx_FIFO(clk, reset, Rx_write_en, Rx_read_en, Rx_input, Rx_output, Rx_full, Rx_empty);
 
endmodule