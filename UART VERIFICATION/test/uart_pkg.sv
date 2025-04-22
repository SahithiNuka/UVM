


package uart_pkg;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "uart_trans.sv"
	`include "a_cfg.sv"
	`include "env_cfg.sv"
	`include "uart_driver.sv"
	`include "uart_monitor.sv"
	`include "uart_seqr.sv"
	`include "uart_agent.sv"
	`include "agent_top.sv"
	`include "uart_seqs.sv"

	`include "uart_sb.sv"
	`include "uart_vseqr.sv"
	`include "uart_vseqs.sv"
	`include "uart_env.sv"
	`include "uart_test.sv"

endpackage
