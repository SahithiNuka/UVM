`timescale 1ns/1ps

module top;
	
	import uart_pkg::*;
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	//clock generation	
	bit clk1;
	bit clk2;
	
	wire a;
	wire b;

	always
		#10 clk1=~clk1;
	always
		#20 clk2=~clk2;

	//interface instatiation

	uart_interface in1(clk1);
	uart_interface in2(clk2);

	//dut instantiation
	//uart-1
	uart_top UART1(.wb_clk_i(clk1),
			.wb_rst_i(in1.wb_rst_i),
			.wb_adr_i(in1.wb_adr_i),
			.wb_dat_i(in1.wb_dat_i),
			.wb_dat_o(in1.wb_dat_o),
			.wb_we_i(in1.wb_we_i),
			.wb_stb_i(in1.wb_stb_i),
			.wb_cyc_i(in1.wb_cyc_i),
			.wb_ack_o(in1.wb_ack_o),
			.wb_sel_i(in1.wb_sel_i),
			.int_o(in1.int_o),
			.stx_pad_o(a),
			.srx_pad_i(b));

	//uart-2
	uart_top UART2(.wb_clk_i(clk2),
			.wb_rst_i(in2.wb_rst_i),
			.wb_adr_i(in2.wb_adr_i),
			.wb_dat_i(in2.wb_dat_i),
			.wb_dat_o(in2.wb_dat_o),
			.wb_we_i(in2.wb_we_i),
			.wb_stb_i(in2.wb_stb_i),
			.wb_cyc_i(in2.wb_cyc_i),
			.wb_ack_o(in2.wb_ack_o),
			.wb_sel_i(in2.wb_sel_i),
			.int_o(in2.int_o),
			.stx_pad_o(b),
			.srx_pad_i(a));

	initial
		begin
			uvm_config_db #(virtual uart_interface)::set(null,"*","vif_0",in1);
			uvm_config_db #(virtual uart_interface)::set(null,"*","vif_1",in2);
			run_test();
		end
endmodule
