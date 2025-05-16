class rx_sequence extends uvm_sequence#(.REQ(rx_transaction));
  
  rand rx_transaction rx;
  
  `uvm_declare_p_sequencer(rx_sequencer)
  `uvm_object_utils(rx_sequence)
  
  function new(string name="");
    super.new(name);
    rx = rx_transaction::type_id::create("rx");
  endfunction
  
  task body();
    rx_transaction rx;

    start_item(rx);//a built-in function in sequence
    assert(rx.randomize());
    finish_item(rx);
  endtask
  
endclass