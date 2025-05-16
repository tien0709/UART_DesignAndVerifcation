class rx_sequencer extends uvm_sequencer #(rx_transaction);
  
  `uvm_component_utils(rx_sequencer);
  
  function new(name="", uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass