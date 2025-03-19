class rx_wr_driver;
  transaction trans;
  mailbox#(transaction) gen2drv;
  virtual UART_IF.WRD_RX_M WRD_IF;
  
  function new(virtual UART_IF.WRD_RX_M WRD_IF, mailbox#(transaction) gen2drv);
   		this.gen2drv = gen2drv;
        this.WRD_IF = WRD_IF;
        $display("UART RX write Driver is Build");
  endfunction
  
  virtual task start();
    fork 
 	 forever   
  	 begin  
    	gen2drv.get(trans);
       
        repeat(11) begin
           @(WRD_IF.WRD_RX_CB)begin
            WRD_IF.WRD_RX_CB.rx<=trans.rx_reg[10];
      		trans.rx_reg=trans.rx_reg<<1;
           end
       end
       //WRD_IF.WRD_RX_CB.rx<=1'b1;
     end
    join_none;
  endtask
  
endclass