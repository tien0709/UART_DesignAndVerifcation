`uvm_analysis_imp_decl(_in_model_rx)
`uvm_analysis_imp_decl(_in_model_tx)
class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    
    uvm_analysis_imp_in_agent_rx#(rx_item_mon, uart_scoreboard) port_in_agent_rx;
  	uvm_analysis_imp_in_agent_tx#(tx_item_mon, uart_scoreboard) port_in_agent_tx;
  
  //note: dut need time to process so data_out at tx agent arrive scoreboard slower than data in from rx agent to scoreboard 
    
    protected rx_item_mon exp_rx_q[$];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);   
        port_in_agent_rx = new ("port_in_agent_rx", this);
        port_in_agent_tx = new ("port_in_agent_tx", this);
    endfunction
    
  	function void write_in_agent_rx(rx_item_mon item_rx);
      if(exp_rx_q.size()>=1) begin
	 //only 1 entry in queue 
    `uvm_error("ALGORITHM_ISSUE", $sformatf("Something went wrong as there are already %0d entries in exp_rx_q and just received one more",
                                              exp_rx_q.size()))
      end
      else 
        exp_rx_q.push_back(item_rx);     
    endfunction
  
    function void write_in_agent_tx(tx_item_mon item_tx);    
        rx_item_mon item_rx = exp_rx_q.pop_front();
          
      if(item_tx.data_out!=item_rx.data_in) 
        `uvm_error("DUT_ERROR", $sformatf("Mismatch detected for the RX data in = %s - TX data out = %s", item_rx.data_in, item_tx.data_our);	
        
    endfunction
endclass