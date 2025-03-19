module uart_tb;
  parameter time_period = 10;
  bit clk;
  bit b_clk;

  UART_IF DUT_IF(clk, b_clk);
  uart_rx_design DUT(clk, DUT_IF.reset, DUT_IF.rd_en, DUT_IF.d_out, DUT_IF.rx, DUT_IF.rx_empty);
  
  always #(time_period / 2) clk = ~clk;

  test_rx t1(DUT_IF, clk);

  initial begin
    // Initialize clocks
    clk = 0;
    b_clk = 0;

    // Dump waveform
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial begin
    if (DUT_IF.reset == 1'b1) begin
      b_clk = 1'b0;
    end

    for (int i = 0; i < 7; i++) begin
      @(posedge clk) begin
        if (i == 6)
          b_clk = 1'b1;
        else
          b_clk = 1'b0;
      end
    end
  end
endmodule