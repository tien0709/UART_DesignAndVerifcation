// Code your testbench here
// or browse Examples
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "test.sv"

`include "interface.sv"

module tb;
    logic clk, rst;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        #20 rst = 0;
    end
    
    uart_if uart_if_inst(.clk(clk), .rst(rst));
    uart_rx_design dut (
        .clk(clk),
        .rst(rst),
        .rx(uart_if_inst.rx),
        .d_out(uart_if_inst.d_out),
        .done(uart_if_inst.done),
        .baud_trig(uart_if_inst.baud_trig)
    );
    
    initial begin
        uvm_config_db#(virtual uart_if)::set(null, "*", "vif", uart_if_inst);
        run_test("uart_test");
    end
endmodule