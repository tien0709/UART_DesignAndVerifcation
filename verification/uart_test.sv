class uart_test extends uvm_test; 
  `uvm_component_utils(uart_test)
    
    uart_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uart_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
      	phase.raise_objection(this, "TEST_DONE");
      
        `uvm_info("DEBUG", "start of test", UVM_LOW);
      
        #100ns;
      
      	repeate(2) begin
      
        rx_sequence seq = rx_sequence::type_id::create("seq");
      
        seq.set_sequencer(env.rx_agent.sequencer);
      
        void'(seq.randomize());
      
      	seq.start(env.rx_agent.sequencer);
        
        #500
          
     	end
      
        #1000;
        `uvm_info("DEBUG", "end of test", UVM_LOW);
        phase.drop_objection(this);
    endtask
endclass