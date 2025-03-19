int no_of_pass=0;
int no_of_fail=0;
`include "transaction.sv"
`include "rx_reference.sv"
`include "rx_scoreboard.sv"
`include "rx_rd_monitor.sv"
`include "rx_rd_driver.sv"
`include "rx_wr_driver.sv"
`include "rx_wr_monitor.sv"
`include "generator.sv"

class rx_environment;
  
  virtual UART_IF.WRD_RX_M WRD_IF;
  virtual UART_IF.WRM_RX_M WRM_IF;
  virtual UART_IF.RDM_RX_M RDM_IF;
  virtual UART_IF.RDD_RX_M RDD_IF;
  
  mailbox#(transaction) wr_gen2drv;
  mailbox#(transaction) wr_mnt2ref;
  mailbox#(transaction) wr_ref2sb;
  mailbox#(transaction) rd_mnt2sb;
  
  generator rx_gen_h;
  rx_wr_driver rx_wr_drv_h;
  rx_wr_monitor rx_wr_mnt_h;
  rx_reference rx_wr_ref_h;
  rx_rd_monitor rx_rd_mnt_h;
  rx_rd_driver rx_rd_drv_h;
  rx_scoreboard rx_sb_h;
  
  function new(virtual UART_IF.WRD_RX_M WRD_IF, virtual UART_IF.WRM_RX_M WRM_IF, virtual UART_IF.RDM_RX_M RDM_IF, virtual UART_IF.RDD_RX_M RDD_IF);
    wr_gen2drv = new;
    wr_mnt2ref = new;
    wr_ref2sb = new;
    rd_mnt2sb = new;
    
    this.WRD_IF=WRD_IF;
    this.WRM_IF=WRM_IF;
    this.RDM_IF=RDM_IF;
    this.RDD_IF=RDD_IF;
    
  endfunction
  
  virtual task build();
    $display("UART RX Environment is Build");
    rx_gen_h=new(wr_gen2drv);
    rx_wr_drv_h=new(WRD_IF, wr_gen2drv);     
    rx_wr_mnt_h=new(WRM_IF, wr_mnt2ref);
  	rx_rd_drv_h=new(RDD_IF);
    rx_ref_h=new(wr_mnt2ref, wr_ref2sb);
  	rx_rd_mnt_h=new(RDM_IF,rd_mnt2sb);
  	rx_sb_h=new(rd_mnt2sb, wr_ref2sb); 
  endtask
  
  virtual task start_dut();
    fork
      begin
      $display("Start metode-----");
      	rx_gen_h.start();
  		rx_wr_drv_h.start();
  		rx_wr_mnt_h.start();
  		rx_wr_ref_h.start();
  		rx_rd_mnt_h.start();
  		rx_rd_drv_h.start();
  		rx_sb_h.start();
      end
    join_any
    
  endtask
  
  
   virtual task stop_dut();
		wait ( rx_no_of_write_trans==rx_no_of_transaction && rx_no_of_read_trans==rx_no_of_write_trans);
    $display("Total number of trans =%d\n Number of pass transaction =%d\n Number of fail transaction= %d",rx_no_of_transaction,no_of_pass,no_of_fail);
 
 	#10 $finish;
  endtask
  
   task run();
 	 start_dut(); 
   	 stop_dut();
   endtask
  
endclass