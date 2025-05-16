// Code your design here
`include "baud_clk.sv"
`include "fifo.sv"
`include "uart_rx.sv"
`include "uart_tx.sv"

module uart_design(clk,rst,rd_en, wr_en, d_in, d_out, tx_can_receive_signal, rx_can_send_signal, tx, rx);
  
  input logic clk,rst;
  input logic rd_en, wr_en;//enable read for rx and write for tx
  input logic  rx;//signal item arrive rx port
  input logic [7:0]d_in;//data in TX FIFO
  
  output logic [7:0]d_out;//data  in RX FIFO
  output  logic tx;//signal item leave tx port
  output logic rx_can_send_signal;
  output logic tx_can_receive_signal;
  
  logic [10:0]dvsr;
  assign dvsr=11'd7;
  
  logic baud_tx, baud_rx;
  logic done_tx, done_rx;//done receving/transmiting signal
  logic [7:0]d_out_tx_ff;//data out of TX FIFO
  logic [7:0]d_in_rx_ff;//data out of TX FIFO
  logic tx_can_send_signal;
  logic rx_can_receive_signal;
  
  baud_clk blck(.clk(clk), .rst(rst), .baud_trig_tx(baud_tx), .baud_trig_rx(baud_rx), .dvsr(dvsr));
  
  
  uart_tx tx1( 	 		   .clk(clk),
                  		   .rst(rst),
          .wr_en(tx_can_send_signal),
               .data_in(d_out_tx_ff),
              	   .done_tx(done_tx),
              				 .tx(tx),
                  .baud_trig(baud_tx)
  );
  uart_rx rx1(   		   .clk(clk),
                 		   .rst(rst),
               .data_out(d_in_rx_ff),
              	   .done_rx(done_rx),
                   			 .rx(rx),
                  .baud_trig(baud_rx)
  );
  
  fifo rx_ff(     		   .clk(clk),
                  		   .rst(rst),
             		   .rd_en(rd_en),
             		 .wr_en(done_rx),
                .data_in(d_in_rx_ff),
             		.data_out(d_out),
             .can_receive_signal(rx_can_receive_signal),//dont care
             .can_send_signal(rx_can_send_signal),
             .baud_trig(baud_rx)
  );
  
  fifo tx_ff(     		   .clk(clk),
                  		   .rst(rst),
             		 .rd_en(done_tx),
            		   .wr_en(wr_en),
               		  .data_in(d_in),
              .data_out(d_out_tx_ff),
             .can_receive_signal(tx_can_receive_signal),
             .can_send_signal(tx_can_send_signal),
             .baud_trig(baud_tx)
  );


 
endmodule