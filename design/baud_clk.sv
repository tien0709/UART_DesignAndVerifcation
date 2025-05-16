module baud_clk(
    input logic clk,
    input logic rst,
    input logic [10:0] dvsr,
    output logic baud_trig_tx,
    output logic baud_trig_rx
);

    reg [10:0] b_reg_tx, b_next_tx;
    reg [10:0] b_reg_rx, b_next_rx;

    // Baud tick pulse generators
    logic baud_tick_tx;
    logic baud_tick_rx;

    // TX Counter (posedge)
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            b_reg_tx <= 11'd0;
        else
            b_reg_tx <= b_next_tx;
    end

    // RX Counter (negedge)
    always_ff @(negedge clk or posedge rst) begin
        if (rst)
            b_reg_rx <= 11'd0;
        else
            b_reg_rx <= b_next_rx;
    end

    // Next state logic
    always_comb begin
        b_next_tx = (b_reg_tx == dvsr) ? 11'd0 : b_reg_tx + 1;
        baud_tick_tx = (b_reg_tx == dvsr); // Tick at wrap
    end

    always_comb begin
        b_next_rx = (b_reg_rx == dvsr) ? 11'd0 : b_reg_rx + 1;
        baud_tick_rx = (b_reg_rx == dvsr); // Tick at wrap
    end

    // Create 1-cycle pulse for baud_trig
    logic baud_tick_tx_d, baud_tick_rx_d;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            baud_tick_tx_d <= 0;
        else
            baud_tick_tx_d <= baud_tick_tx;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            baud_tick_rx_d <= 0;
        else
            baud_tick_rx_d <= baud_tick_rx;
    end

    assign baud_trig_tx = baud_tick_tx & ~baud_tick_tx_d;
    assign baud_trig_rx = baud_tick_rx & ~baud_tick_rx_d;

endmodule


