module uart_rx(clk, rst, done_rx, data_out, baud_clk, rx_in);
  
  input clk, rst, rx_in, baud_clk;
  output logic done_rx;
  output logic [7:0] data_out;
  
  localparam start_bit = 1'b0, stop_bit = 1'b1;
  
  logic done_rx_reg;
  logic parity_bit;
  logic [10:0] data_out_reg;
  
  logic[4:0] count;
  typedef enum{idle, start, process, stop}state;
  state current_state, next_state;
  
  //assign
  assign data_out = done_rx?8'hx:data_out_reg[8:1];
  assign done_rx = done_rx_reg;
  assign parity_bit=^data_out_reg[8:1];
  
  //update current state
  always @(posedge clk or posedge rst) begin
    if(rst) current_state <= idle;
    else
      current_state <= next_state;
  end
  
  //FSM
  always_latch begin
    case(current_state)
      	idle:
          begin
            done_rx_reg = 1'b1;
            data_out_reg = 8'hx;
            count = 0;
            if(rx_in == start_bit) begin
              next_state = start;
            end
          end
        start:
          begin
            $display("start tx");
            if(baud_clk) begin
              data_out_reg[count] = start_bit;
              count = 1;
              next_state = process;
            end
          end
        process:
          begin
            $display("process tx");
          if(baud_clk) begin
            data_out_reg[count] = rx_in;
            count = count + 1;
            next_state = stop;
            end
          end
        stop:
          begin
            $display("stop tx");
            if(baud_clk) begin
              data_out_reg[count] = parity_bit;
              data_out_reg[count+1] = stop_bit;
              next_state = idle;
            end
          end
    endcase
  end
  
endmodule