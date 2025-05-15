class rx_driver extends uvm_driver#(rx_transaction);
  `uvm_component_utils(rx_driver);
  
  rx_agent_config agent_config;
  
  function new(name="", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function new(string name, uvm_component parent);
        super.new(name, parent);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    if($cast(agent_config, super.agent_config) == 0) begin
      `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Could not cast %0s to %0s", 
                                              super.agent_config.get_type_name(), agent_config::type_id::type_name))
    end
  endfunction
      
  task run_phase(uvm_phase phase);
        forever begin
          fork
            begin
              //wait_reset_end();
              seq_item_port.get_next_item(req);
              drive_transaction(req);
              seq_item_port.item_done();
            end
          join
        end
  endtask
    
  task drive_transaction(rx_transaction trans);
    // Start bit
    vif.cb.rx <= 0;

    @(vif.cb.baud_trig)
    // Data bits
    for(int i = 0; i < 8; i++) begin
      vif.cb.rx <= trans.data[i];
      @(vif.cb.baud_trig)
    end

    // Parity bit (odd parity)
    vif.cb.rx <= ^trans.data;
    @(vif.cb.baud_trig)
    
    // Stop bit
    vif.cb.rx <= 1;
    @(vif.cb.baud_trig)
  endtask
  
    //Task for waiting the reset to be finished
    protected virtual task wait_reset_end();
      agent_config.wait_reset_end();
    endtask
  
endclass