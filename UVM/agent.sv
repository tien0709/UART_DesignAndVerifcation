`include "driver.sv"
`include "monitor.sv"
class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)
    
    uart_driver driver;
    uart_monitor monitor;
    uvm_sequencer #(uart_transaction) sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = uart_driver::type_id::create("driver", this);
        monitor = uart_monitor::type_id::create("monitor", this);
        sequencer = uvm_sequencer#(uart_transaction)::type_id::create("sequencer", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass