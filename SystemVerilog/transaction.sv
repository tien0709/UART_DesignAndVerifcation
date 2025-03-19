class transaction;
  rand bit[10:0]rx_reg;
  logic rx;
  logic [7:0] d_out;
  logic rd_en;
  bit [10:0]rx_d_ref[];
  
  parameter START_BIT = 1'b0;
  parameter END_BIT = 1'b1;
  
  constraint data_unique{unique{rx_reg[8:1];}
  constraint start_stop_bit{rx_reg[0]=START_BIT;rx_reg[10]=STOP_BIT;}
  constraint good_parity_bit{rx_reg[9]=^rx_reg[8:1];} 
  constraint bad_parity_bit{rx_reg[9]=~^rx_reg[8:1];}
  constraint range_data{rx_reg [8:1] dist {[0:7]:/5,[8:15]:/5,[16:31]:/5,[32:63]:/5,[64:127]:/5,[128:255]:/5};} 
  
  function void post_randomization();
    $display("stop_bit = %b, parity_bit = %b, data = %d,  start_bit = %b, random = %b ~ %h",rx_reg[10],rx_reg[9],rx_reg[8:1],rx_reg[0],rx_reg,rx_reg);
  endfunction
endclass