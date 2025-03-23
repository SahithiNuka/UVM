
package router_pkg;

	import uvm_pkg::*;

	`include "uvm_macros.svh"

	`include "s_trans.sv"
	`include "s_cfg.sv"
	`include "d_cfg.sv"
	`include "env_cfg.sv"
	`include "s_drv.sv"
	`include "s_mon.sv"
	`include "s_seqr.sv"
	`include "s_agent.sv"
	`include "s_agt_top.sv"
	`include "s_seqs.sv"

	`include "d_trans.sv"
	`include "d_drv.sv"
	`include "d_mon.sv"
	`include "d_seqr.sv"
	`include "d_seqs.sv"
	`include "d_agent.sv"
	`include "d_agt_top.sv"

	`include "scoreboard.sv"
	`include "v_seqr.sv"
	`include "v_seqs.sv"
	`include "env.sv"
	`include "router_test.sv"

endpackage
