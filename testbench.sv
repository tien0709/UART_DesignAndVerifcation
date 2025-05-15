`include "pkg.sv"
module tb;

  // Inputs
  logic clk, rst;
  logic rd_en, wr_en;
  logic [7:0] d_in;
  logic rx;

  // Outputs
  logic [7:0] d_out;
  logic tx_can_receive_signal, rx_can_send_signal;
  logic tx;
  
  // Instantiate Interface
  uart_if rx_if(.clk(clk));
  uart_if tx_if(.clk(clk));

  // Clock generation (100 MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period = 100 MHz
  end

  initial begin
        tx_if.rst = 1;
        #6ns tx_if.rst = 0;
   		#30ns tx_if.rst = 1;
  end
  
  assign rx_if.rst = tx_if.rst;
  
  // Reset and initial setup
  initial begin
    // Dump waveform
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, tb);
    
    
    uvm_config_db#(virtual uart_if)::set(null, "uvm_test_top.env.tx_agent", "vif", tx_if);
    uvm_config_db#(virtual uart_if)::set(null, "uvm_test_top.env.rx_agent", "vif", rx_if);
    
    run_test("");
    
  end
  
    // Instantiate DUT
  uart_design dut (
    .clk(clk),
    .rst(rst),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .d_in(d_in),
    .d_out(d_out),
    .tx_can_receive_signal(tx_can_receive_signal),
    .rx_can_send_signal(rx_can_send_signal),
    .tx(tx),
    .rx(rx)
  );

//     rst = 1;
//     rd_en = 0;
//     wr_en = 0;
//     d_in = 8'h00;
//     rx = 1;

//     #50;
//     rst = 0;

//     // Send a byte via UART RX line (simulate external UART transmission)
//     #100;
//     uart_rx_byte(8'b11110000); // send 0xAA

// // stop, parity, data[7:0], start
// // Enable reading from RX FIFO after receiving
//     #500;
//     rd_en = 1;
//     #80;//minimum = baud_clk
//     rd_en = 0;

//     // --- Test UART TX: write a byte and observe 'tx' ---
//     #200;
//     d_in = 8'b10101010;  // data to send
//     // stop, parity, data[7:0], start
//     wr_en = 1;
//     #80;
//     wr_en = 0;

//     // Wait enough time for transmission to complete
//     #2000;

//     // Finish simulation
//     $finish;
//   end

//   //monitored received data
//   initial begin
//       $monitor("Time: %0t ns, RX fifo Received 8 bits data = %b (%0d)", $time, d_out, d_out);
//   end

//   // UART RX simulation task (8N1 format)
//   task uart_rx_byte(input [8:0] data);
//     integer i;
//     begin
//       // Start bit
//       rx = 0;

//       #(8*10); 
      
//       // Send 8 data bits (LSB first)
//       for (i = 0; i < 8; i = i + 1) begin
//         rx = data[i];
//         #(8*10);
//       end

//       // parity bit
//       rx = ^data;
//       #(8*10);
      
//       // Stop bit
//       rx = 1;
//       #(8*10);
//     end
//   endtask

//   //monitored received data in TX FIFO
//   initial begin
//     $monitor("Time: %0t ns, TX fifo Received 8 bits data = %b (%0d)", $time, d_in, d_in);
//   end

endmodule
