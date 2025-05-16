
class rx_agent extends uvm_agent;
  `uvm_component_utils(rx_agent)
    
    rx_driver driver;
    rx_monitor monitor;
  	rx_sequencer #(rx_transaction) sequencer;
    rx_agent_config agent_config;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = rx_driver::type_id::create("driver", this);
        monitor = rx_monitor::type_id::create("monitor", this);
        sequencer = rx_sequencer#(uart_transaction)::type_id::create("sequencer", this);
     	agent_config = rx_agent_config::type_id::create("sequencer", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
		
      super.connect_phase(phase);
      
      uart_vif vif;
      
      if(!uvm_config_db(uart_vif)::get(this,"","vif", vif))
        `uvm_fatal("NO_VIF", "can not get virtual interface for rx_agent from database");
      else begin
        agent_config.set_vif(vif);
      
        driver.seq_item_port.connect(sequencer.seq_item_export);
      
        monitor.agent_config = this.agent_config;
      	driver.agent_config = this.agent_config;
      end
    endfunction
endclass