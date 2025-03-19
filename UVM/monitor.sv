class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)
    
    virtual uart_if vif;
    uvm_analysis_port #(uart_transaction) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        uart_transaction tx;
        forever begin
            tx = uart_transaction::type_id::create("tx");
            wait(vif.done);
            @(vif.cb);
            tx.data = vif.cb.d_out;
            ap.write(tx);
        end
    endtask
endclass