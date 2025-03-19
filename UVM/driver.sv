class uart_driver extends uvm_driver#(uart_transaction);
  `uvm_component_utils(uart_driver);
  
  virtual uart_if vif;
  funtion new(name="driver");
  endfunction
  
  function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
  endfunction
      
  task run_phase(uvm_phase phase);
    forever begin
      @(vif.cb);
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask
    
    task drive_transaction(uart_transaction tx);
      // Start bit
      vif.cb.rx <= 0;
      repeat(16) begin // Assuming baud_trig is 16x baud rate
        vif.cb.baud_trig <= 1;
        @(vif.cb);
        vif.cb.baud_trig <= 0;
        @(vif.cb);
      end

      // Data bits
      for(int i = 0; i < 8; i++) begin
        vif.cb.rx <= tx.data[i];
        repeat(16) begin
          vif.cb.baud_trig <= 1;
          @(vif.cb);
          vif.cb.baud_trig <= 0;
          @(vif.cb);
        end
      end

      // Parity bit (odd parity)
      vif.cb.rx <= ^tx.data;
      repeat(16) begin
        vif.cb.baud_trig <= 1;
        @(vif.cb);
        vif.cb.baud_trig <= 0;
        @(vif.cb);
      end

      // Stop bit
      vif.cb.rx <= 1;
      repeat(16) begin
        vif.cb.baud_trig <= 1;
        @(vif.cb);
        vif.cb.baud_trig <= 0;
        @(vif.cb);
      end
    endtask
endclass