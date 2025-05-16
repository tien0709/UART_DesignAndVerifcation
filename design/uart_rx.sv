
     //Output điều khiển bởi always should use a new variable (trung gian)
  
   // have to using non blocking because we have assign  count_reg so to ensure not race condition then count_reg need be update first, after that count_reg be assign for count
           //note: non-blocking always assign RHS to LHS in the last timestap of cycle but blocking always assign RHS to LHS immediately, it block all other process of system until finish assignment
           
module uart_rx (
  input logic clk, rst,
  input logic baud_trig,
  input logic rx,
  output logic [7:0] data_out,
  output logic done_rx
);

  typedef enum logic [1:0] {IDLE, START, DATA_F} state_t;
  state_t curr_state, next_state;

  logic [10:0] d_reg, next_d_reg;
  logic [3:0] count, next_count;

  // Sequential logic
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      curr_state <= IDLE;
      count <= 0;
      d_reg <= 11'b0;
    end else begin
      curr_state <= next_state;
      count <= next_count;
      d_reg <= next_d_reg;
    end
  end

  // Combinational logic
  always_comb begin
    // default assignments
    next_state = curr_state;
    next_count = count;
    next_d_reg = d_reg;

    case (curr_state)
      IDLE: begin
        //if (baud_trig) begin
          next_d_reg = 11'b0;
          next_count = 0;
          if (rx == 1'b0)
            next_state = START;
       // end
      end

      START: begin
        if (baud_trig) begin      
          next_d_reg[0] = rx;
          next_d_reg <={rx, d_reg[10:1]}; // shift left and capture rx
          next_count = count + 1;
          next_state = DATA_F;
          $display("Time: %0t ns, RX receive start bit data = %b ", $time, rx);
        end
      end
      DATA_F: begin
        if (baud_trig) begin
          next_d_reg <={rx, d_reg[10:1]}; // shift left and capture rx
          next_count = count + 1;
          $display("Time: %0t ns, RX receive bit data = %b ", $time, rx);
          if (next_count == 11) begin// stop bit 
            next_state = IDLE;

          end
        end
      end
    endcase
  end

  assign done_rx = (curr_state == IDLE && count == 11);
  assign data_out = done_rx ? d_reg[8:1] : 8'hFF;

  initial begin
    $monitor("Time: %0t ns, 8 bits content that RX received = %b", $time, data_out);
  end

endmodule

