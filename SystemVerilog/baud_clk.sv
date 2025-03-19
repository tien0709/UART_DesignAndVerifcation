module baud_clk(clk, rst, dv, baud_trig_tx, baud_trig_rx);
  input clk, rst;
  input logic[10:0] dv;//devider
  output baud_trig_tx, baud_trig_rx;//signal for trigger rx and tx( to acive these chanel)
  //each frame be tranfered: 11 bit
  reg[10:0] reg_tx_current, reg_rx_current;
  reg[10:0] reg_tx_next, reg_rx_next;
  // avoding metastability: using posedge clk for tx and negedge for rx
  always @(posedge clk or posedge rst) begin
    if(rst)
      reg_tx_current <= 0;  
    else 
      reg_tx_current <= reg_tx_next;
  end
  
  always @(negedge clk or posedge rst) begin
    if(rst) 
      reg_rx_current <= 0;      
    else 
      reg_rx_current <= reg_rx_next;
  end
  
  assign baud_trig_tx = (reg_tx_current==dv);
  assign baud_trig_rx = (reg_rx_current==dv);
  
  assign reg_tx_next = (reg_tx_current == dv)? 1 : reg_tx_current + 1;
  assign reg_rx_next = (reg_rx_current == dv)? 1 : reg_rx_current + 1;
    
  
endmodule