class generator;
  transaction trans, data2send;//data2send to protect trans in process function ò system
  mailbox#(transaction) gen2drv;
  function new(mailbox#(transaction) gen2drv);
    this.gen2drv = gen2drv;
    trans = new;
    $display("UART Generator is Build");
  endfunction
  
  virtual task start(); $display("UART Generator is Running");
    fork
      begin
        for(int i=0; i<rx_no_of_transaction; i++) begin
          if(!trans.randomize()) begin
            $display("Genetaror :Randomize is not set properly",$time); 
          end 
          data2send = new trans;
          gen2drv.put(data2send);
        end
      end
    join_none;
  endtask
endclass