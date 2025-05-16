class rx_transaction extends uvm_sequence_item;
  rand bit[7:0] data;
  
  `uvm_object_utils_begin(rx_transaction)
  `uvm_field_int(data, UVM_DEFAULT);
  `uvm_object_utils_end
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass