
class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)
    
    tx_agent agent_tx;
    rx_agent agent_rx;
    uart_scoreboard sb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      	agent_tx = tx_agent::type_id::create("agent_tx", this);
      	agent_rx = rx_agent::type_id::create("agent_rx", this);
        sb = uart_scoreboard::type_id::create("sb", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      	agent_tx.monitor.output_port.connect(sb.port_in_agent_tx);
        agent_rx.monitor.output_port.connect(sb.port_in_agent_rx);
    endfunction
endclass