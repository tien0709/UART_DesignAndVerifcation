module fifo (
  input  logic clk, rst,
  input  logic rd_en, wr_en,
  input  logic [7:0] data_in,
  input  logic baud_trig,
  output logic [7:0] data_out,
  output logic can_receive_signal, can_send_signal
);

  reg [7:0] fifo_reg [0:15];
  logic [3:0] wr_ptr, rd_ptr;
  
  logic fifo_full, fifo_empty;
  
  integer i;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 16; i = i + 1)
        fifo_reg[i] <= 8'b0;
      wr_ptr <= 0;
      rd_ptr <= 0;
      data_out <= 8'd0;
    end 
    else begin
      // Write operation
      if (wr_en && !fifo_full && baud_trig) begin
        fifo_reg[wr_ptr] <= data_in;
        wr_ptr <= (wr_ptr == 15) ? 0 : wr_ptr + 1;
		can_receive_signal = 1;
      end
      else can_receive_signal = 0;

      // Read operation
      if (rd_en && !fifo_empty && baud_trig) begin
        data_out <= fifo_reg[rd_ptr];
        rd_ptr <= (rd_ptr == 15) ? 0 : rd_ptr + 1;
		can_send_signal = 1;
      end
      else 
      	can_send_signal = 0;
    end
  end

  //note: using count variable for fifo will lost synchronization
  assign fifo_empty = (rd_ptr==wr_ptr)?1'b1:1'b0;
  assign fifo_full  = (rd_ptr>wr_ptr)?(((rd_ptr-wr_ptr)==1)?1'b1:1'b0):(((wr_ptr-rd_ptr)>=5'd15)?1'b1:1'b0);
  

endmodule
