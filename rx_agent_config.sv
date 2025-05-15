
class rx_agent_config extends uvm_component;
  `uvm_component_utils(rx_agent_config)
    protected uart_vif vif;
  
    local bit has_coverage;
  
        //Delay used when detecting start of an transaction in the monitor
      local time sample_delay_start_tr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        sample_delay_start_tr = 1;
      	has_coverage = 0;
    endfunction
    
  virtual function void set_vif(uart_vif value) begin
      if(this.vif==null) begin
        this.vif = value;
      end
      else    
        `uvm_fatal("ALGORITHM_ISSUE", " trying to set virtual interface more than once");
    endfunction
      
    virtual function uart_vif get_vif() begin
		return this.vif;
    endfunction
      
    virtual function void set_has_coverage(bit value) begin
			this.has_coverage = value;
    endfunction
      
    virtual function bit get_has_coverage() begin
		return this.has_coverage;
    endfunction  
      
          //Setter for sample_delay_start_tr_detection
    virtual function void set_sample_delay_start_tr(time value);
      sample_delay_start_tr = value;
    endfunction
    
    //Getter for sample_delay_start_tr_detection
    virtual function time get_sample_delay_start_tr();
      return sample_delay_start_tr;
    endfunction
      

    virtual task wait_reset_start();
      `uvm_fatal("ALGORITHM_ISSUE", "One must implement wait_reset_start() task")
    endtask
       
    virtual task wait_reset_end();
      `uvm_fatal("ALGORITHM_ISSUE", "One must implement wait_reset_end() task")
    endtask
      
endclass