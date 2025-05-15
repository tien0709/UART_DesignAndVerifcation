class tx_item_mon extends uvm_sequence_item;
  rand bit[7:0] data_out;
  
  `uvm_object_utils_begin(tx_item_mon)
  `uvm_field_int(data_out, UVM_DEFAULT);
  `uvm_object_utils_end
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass