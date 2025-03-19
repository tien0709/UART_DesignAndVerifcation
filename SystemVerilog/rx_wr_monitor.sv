class rx_wr_monitor;
  transaction trans;
  virtual UART_IF.WRM_RX_M WRM_IF;
  mailbox#(transaction) mnt2ref;
  
  function new(virtual UART_IF.WRM_RX_M WRM_IF, mailbox#(transaction) mnt2ref);
    this.mnt2ref = mnt2ref;
    this.WRM_IF = WRM_IF;
    $display("UART RX write monitor  is Build");
  endfunction
  
  virtual task start();
    fork
      forever begin
        trans = new;
        @(WRM_IF.WRM_RX_CB)begin
          trans.rx = WRM_IF.WRM_RX_CB.rx;
          mnt2ref.put(trans);
        end
      end
    join_none
  endtask
endclass