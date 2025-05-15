module uart_tx (
  input  logic clk,
  input  logic rst,
  input  logic wr_en,
  input  logic baud_trig,
  input  logic [7:0] data_in,
  output logic tx,
  output logic done_tx
);

  typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
  state_t curr_state, next_state;

  logic [10:0] d_reg, next_d_reg;
  logic [3:0] count, next_count;
  logic tx_reg, next_tx_reg;
  logic parity_bit;

  // Tạo bit chẵn lẻ
  assign parity_bit = ^data_in;

  // Cập nhật trạng thái
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      curr_state <= IDLE;
      d_reg <= 11'b0;
      count <= 4'd0;
      tx_reg <= 1'b1; // Line idle
    end else begin
      curr_state <= next_state;
      d_reg <= next_d_reg;
      count <= next_count;
      tx_reg <= next_tx_reg;
    end
  end

  // FSM logic
  always_comb begin
    // Default values
    next_state = curr_state;
    next_d_reg = d_reg;
    next_count = count;
    next_tx_reg = tx_reg;

    case (curr_state)
      IDLE: begin
        next_tx_reg = 1'b1; // Line idle
        if (wr_en) begin
          next_d_reg = {1'b1, parity_bit, data_in, 1'b0}; // stop, parity, data[7:0], start
        
          $display("Time: %0t ns, TX will transfer data = %b with form:  {stop, parity, data[7:0], start}", $time, next_d_reg);
          next_state = START;
          next_count = 0;
        end
      end

      START: begin
        if (baud_trig) begin

          next_tx_reg = next_d_reg[0];
          next_d_reg = next_d_reg >> 1;
          next_count = count + 1;
          next_state = DATA;
              $display("Time: %0t ns, TX transfer bit data = %b", $time, next_tx_reg);
        end
      end

      DATA: begin
        if (baud_trig) begin
          next_tx_reg = d_reg[0];
          next_d_reg = d_reg >> 1;
          next_count = count + 1;
          if (next_count == 10)
            next_state = STOP;
              $display("Time: %0t ns, TX transfer bit data = %b", $time, next_tx_reg);
        end
      end

      STOP: begin
        if (baud_trig) begin
          next_tx_reg = 1'b1;
          next_d_reg = d_reg >> 1;
          next_count = count + 1;
          next_state = IDLE;
              $display("Time: %0t ns, TX transfer bit data = %b", $time, next_tx_reg);
          $display("Time: %0t ns, finish TX a pack", $time);
        end
      end
    endcase
  end

  assign done_tx = (curr_state == IDLE);
  assign tx = tx_reg;

  
endmodule

