class tx_monitor extends uvm_monitor;
  `uvm_component_utils(tx_monitor)
    
  tx_agent_config agent_config;
  
  uvm_analysis_port #(tx_item_mon) output_port;
  protected bit tx_q[$];
  
  protected process process_collect_transactions;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    output_port = new("tx_output_port_mon", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    if($cast(agent_config, super.agent_config) == 0) begin
      `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Could not cast %0s to %0s", 
                                              super.agent_config.get_type_name(), agent_config::type_id::type_name))
    end
  endfunction


  task run_phase(uvm_phase phase);
    fork
      begin
        process_collect_transactions = process::self();
        forever begin
          monitor_transaction();
        end
      end
    join
  endtask

  protected virtual task monitor_transaction();

    uart_vif vif = agent_congif.get_vif();

    tx_item_mon item = tx_item_mon::type_id::create("item");

    #(agent_config.get_sample_delay_start_tr());

    wait(vif.can_send_signal);

    @(vif.cb);
    
    if(tx_q.size()<11) tx_q.push_back(vif.cb_tx.tx);
    
    if(tx_q.size()==11) begin
      for(int i = 0; i<11;i++) begin  	
        if(i>=1&&i<=8)
          item.data_out[i] = tx_q.pop_front();
        else tx_q.pop_front();
      end
      output_port.write(item);
    end

    `uvm_info("ITEM_START", $sformatf("Monitor collected bit: %0s", vif.cb_rx.rx, UVM_LOW)

   endtask
endclass