class uart_transaction extends uvm_sequence_item;
  rand bit[7:0] data;
  
  `uvm_object_utils_begin(uart_transaction)
  `uvm_field_int(data, UVM_DEFAULT);
  `uvm_object_utils_end
  
  function new(string name="transaction");
    super.new(name);
  endfunction
endclass