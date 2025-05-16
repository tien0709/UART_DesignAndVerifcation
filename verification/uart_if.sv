interface uart_if(
    input logic clk,
    input logic rst_n
);
    // UART signals
    logic        tx;      // UART transmit (output from DUT)
    logic        rx;      // UART receive  (input to DUT)
    
    // Clocking block for driving UART RX
    clocking cb_rx @(posedge clk);
        //default input #1step output #1step;
        output rx;
    endclocking

    // Clocking block for sampling UART TX
    clocking cb_tx @(posedge clk);
        //default input #1step output #1step;
        input tx;
    endclocking

    // Modport definitions
    modport DUT (
        input  clk,
        input  rst_n,
        input  rx,
        output tx
    );

    modport TB (
        input  clk,
        input  rst_n,
        clocking cb_rx,
        clocking cb_tx
    );

endinterface