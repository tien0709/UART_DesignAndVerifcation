class rx_item_mon extends uvm_sequence_item;
  rand bit[7:0] data_in;
  
  `uvm_object_utils_begin(rx_item_mon)
  `uvm_field_int(data_in, UVM_DEFAULT);
  `uvm_object_utils_end
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass