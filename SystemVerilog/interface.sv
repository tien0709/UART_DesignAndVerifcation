interface UART_IF(input bit clk, baud_clk);
  logic rst;
  logic[10:0] data_out;
  logic rx;
  logic rd_en;
  logic rx_empty;
  
  clocking WRD_RX_CB@(posedge baud_clk);//write driver _rx_ Clocking Block
    default input #1 output #1;
    output rx;
  endclocking
  
  clocking WRM_RX_CB@(negedge baud_clk);//write monitor _rx_ Clocking Block
    default input #1 output #1;
    input rx;
  endclocking
  
  clocking RDM_RX_CB@(posedge clk);//READ monitor _rx_ Clocking Block
    default input #1 output #1;
    input d_out;
    input rd_en;
  endclocking
  
  clocking RDD_RX_CB@(posedge clk);//READ Driver _rx_ Clocking Block
    default input #1 output #1;
    input rx_empty;
    output rd_en;
  endclocking
  
  modport WRD_RX_M(clocking WRD_RX_CB);
  modport RDD_RX_M(clocking RDD_RX_CB);
  modport WRM_RX_M(clocking WRM_RX_CB);
  modport RDM_RX_M(clocking RDM_RX_CB);
  
endinterface
  