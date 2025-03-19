class rx_rd_monitor;
  transaction trans;
  mailbox#(transaction) rd_mnt2sb;
  virtual UART_IF.RDM_RX_M RDM_IF;
  
  function new(virtual UART_IF.RDM_RX_M RDM_IF, mailbox#(transaction) rd_mnt2sb);
    this.RDM_IF = RDM_IF;
    this.rd_mnt2sb = rd_mnt2sb;
    $display("UART RX Read Monitor is Build");
  endfunction
  
  virtual task start();
    fork begin
      forever begin
        trans = new;
        wait(RDM_IF.RDM_RX_CB.rd_en==1'b1);
        trans.d_out=RDM_IF.RDM_RX_CB.d_out;
   		rd_mnt2sb.put(trans);
      end
    end
    join_none;
    
  endtask
endclass