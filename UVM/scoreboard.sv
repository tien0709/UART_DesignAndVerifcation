class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    
    uvm_analysis_port #(uart_transaction) exp_port;
    uvm_analysis_port #(uart_transaction) act_port;
    
    uart_transaction exp_q[$];
    uart_transaction act_q[$];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void write(uart_transaction t);
        if(t.data === 8'hFF) return; // Ignore reset value
        
        if(exp_q.size()) begin
            uart_transaction exp = exp_q.pop_front();
            if(exp.data != t.data)
                `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected: %h, Actual: %h", exp.data, t.data))
            else
                `uvm_info("SCOREBOARD", $sformatf("Match! Data: %h", t.data), UVM_MEDIUM)
        end else begin
            act_q.push_back(t);
        end
    endfunction
endclass