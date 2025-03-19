module uart_tx( clk, rst, wr_en, data_in, done_tx, baud_clk, tx_out);
  
  input logic clk, rst, wr_en, baud_clk;
  //wr_en = !empty signal output from ff_tx 
  
  input logic[7:0]data_in;
  output logic done_tx;
  output logic tx_out;//bit is transfered
  
  //temporary variable
  logic[8:0] data_in_reg;
  logic tx_out_reg;
  logic done_tx_reg;
  logic parity_bit;
  localparam start_bit=1'b0, stop_bit=1'b1;
  typedef enum {idle, start, process, stop } state;
  //idle=> initial/ suspension, start=> starting transfer(tranfer start bit), process =>transfer content and parity bit, stop(tranfer stop bit).
  state current_state, next_state;
  
  logic [3:0]count;//count for bit be tranfered
  
  //assign
  assign parity_bit = ^data_in;
  assign tx_out = tx_out_reg;
  assign done_tx = done_tx_reg;
  
  //update current state
  
  always @(posedge clk or posedge rst) begin
    if(rst == 1) current_state = idle;
    else current_state = next_state;
  end 
  
  //fsm
  always_latch
    begin
    case(current_state)
      idle:begin
        tx_out_reg = 1'bx;
        count = 0;
        data_in_reg = 11'b0;
        done_tx_reg = 1'b1;
        if(wr_en)
          next_state = start;
        else
          next_state = idle;
      end
	  start: begin
        $display("start tx");
        tx_out_reg = 1'b0;
        count = 1;
        data_in_reg = {parity_bit, data_in};
        if(baud_clk)
          next_state = process;
      end
      process: begin
        $display("process tx");
        tx_out_reg = data_in_reg[count-1];
        count = count + 1;
        if(count == 9 && baud_clk) next_state = stop;
      end
      stop: begin
        $display("stop tx");
        tx_out_reg = 1'b1;
        count = count + 1;
        if(baud_clk)
          next_state = idle;
      end
    endcase
    end
endmodule
  