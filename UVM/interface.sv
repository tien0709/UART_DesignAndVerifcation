interface uart_if(input logic clk, rst);
    logic rx;
    logic [7:0] d_out;
    logic done;
    logic baud_trig;
    
    clocking cb @(posedge clk);
        input d_out, done;
        output rx, baud_trig;
    endclocking
    
    modport DUT (input clk, rst, rx, baud_trig,
                output d_out, done);
endinterface