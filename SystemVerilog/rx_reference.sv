class rx_reference;
  transaction trans, data2send;
  mailbox#(transaction) mnt2ref, ref2sb;
  int i;
  parameter START_BIT = 1'b0;
  
  function new(mailbox#(transaction) mnt2ref, mailbox#(transaction) ref2sb);
    	this.mnt2ref = mnt2ref;
        this.ref2sb = ref2sb;
		$display("UART RX Reference Model is Build");
  endfunction
  
  virtual task start();
    data2send=new;
    data2send.rx_d_ref=new[rx_no_of_transaction];
    i=0;
    fork
    forever begin
      mnt2ref.get(trans);
      if(trans.rx == START_BIT) begin
        data2send.rx_d_ref[i][0] = trans.rx;
        repeat(10) begin
          mnt2ref.get(trans);
          data2send.rx_d_ref[i]=data2send.rx_d_ref[i]<<1;
          data2send.rx_d_ref[i][0]= trans.rx;
        end
        ref2sb.put(data2send);
        i = i + 1;
      end
    end
    join_none;
  endtask;
  
endclass