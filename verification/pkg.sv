package uart_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uart_if.sv"   
    `include "types.sv"

    `include "rx_transaction.sv"
    `include "rx_sequence.sv"
    `include "rx_sequencer.sv"
    `include "rx_driver.sv"
    `include "rx_monitor.sv"
    `include "rx_agent_config.sv"
    `include "rx_agent.sv"
    
	`include "tx_monitor.sv"
    `include "tx_agent_config.sv"
    `include "tx_agent.sv"

    `include "uart_scoreboard.sv"
    `include "uart_env.sv"
    `include "uart_test.sv"
endpackage
