
class tx_agent extends uvm_agent;
  `uvm_component_utils(tx_agent)
    

    tx_monitor monitor;
    tx_agent_config agent_config;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = tx_monitor::type_id::create("monitor", this);
        agent_config = tx_agent_config::type_id::create("sequencer", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
		
      super.connect_phase(phase);
      
      uart_vif vif;
      
      if(!uvm_config_db(uart_vif)::get(this,"","vif", vif))
        `uvm_fatal("NO_VIF", "can not get virtual interface for tx agent from database");
      else begin
        agent_config.set_vif(vif);
        monitor.agent_config = this.agent_config;
      end
    endfunction
endclass