`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:06:50 09/30/2024 
// Design Name: 
// Module Name:    top_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_module(clk,rstn,pkt_vd,re0,re1,re2,din,vo0,vo1,vo2,busy,error,dout0,dout1,dout2);
	input clk,rstn,pkt_vd,re0,re1,re2;
	input [7:0]din;
	output vo0,vo1,vo2,busy,error;
	output [7:0]dout0,dout1,dout2;
	
	wire sr0,sr1,sr2,parity_done,fifo_full,low_pkt_vd,fe0,fe1,fe2,detect_addr,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,
			lfd_state,full0,full1,full2;
	wire [2:0]we;
	wire [7:0]data_out;
	
	fifo f1(.clk(clk),
			 .rstn(rstn),
			 .we(we[0]),
			 .re(re0),
			 .soft_rst(sr0),
			 .lfd_state(lfd_state),
			 .empty(fe0),
			 .full(full0),
			 .din(data_out),
			 .dout(dout0));
			 
	fifo f2(.clk(clk),
			 .rstn(rstn),
			 .we(we[1]),
			 .re(re1),
			 .soft_rst(sr1),
			 .lfd_state(lfd_state),
			 .empty(fe1),
			 .full(full1),
			 .din(data_out),
			 .dout(dout1));
			 
	fifo f3(.clk(clk),
			 .rstn(rstn),
			 .we(we[2]),
			 .re(re2),
			 .soft_rst(sr2),
			 .lfd_state(lfd_state),
			 .empty(fe2),
			 .full(full2),
			 .din(data_out),
			 .dout(dout2));
			 
	fsm fb(.clk(clk),
		    .rstn(rstn),
			 .pkt_vd(pkt_vd),
			 .din(din[1:0]),
			 .fifo_full(fifo_full),
			 .fifo_empty0(fe0),
			 .fifo_empty1(fe1),
			 .fifo_empty2(fe2),
			 .sft_rst0(sr0),
			 .sft_rst1(sr1),
			 .sft_rst2(sr2),
			 .parity_done(parity_done),
			 .low_pkt_vd(low_pkt_vd),
			 .detect_add(detect_addr),
			 .ld_state(ld_state),
			 .laf_state(laf_state),
			 .full_state(full_state),
			 .lfd_state(lfd_state),
			 .write_enb_reg(write_enb_reg),
			 .rst_in_reg(rst_int_reg),
			 .busy(busy));
			 
	register r1(.clk(clk),
					.rstn(rstn),
					.pkt_vd(pkt_vd),
					.fifo_full(fifo_full),
					.rst_in_reg(rst_int_reg),
					.detect_addr(detect_addr),
					.ld_state(ld_state),
					.laf_state(laf_state),
					.full_state(full_state),
					.lfd_state(lfd_state),
					.din(din),
					.parity_done(parity_done),
					.low_pkt_vd(low_pkt_vd),
					.error(error),
					.dout(data_out));
					
	synchronizer_block s1(.clk(clk),
								 .rstn(rstn),
								 .detect_addr(detect_addr),
								 .write_enb_reg(write_enb_reg),
								 .re0(re0),
								 .re1(re1),
								 .re2(re2),
								 .e0(fe0),
								 .e1(fe1),
								 .e2(fe2),
								 .f0(full0),
								 .f1(full1),
								 .f2(full2),
								 .din(din[1:0]),
								 .vo0(vo0),
								 .vo1(vo1),
								 .vo2(vo2),
								 .sr0(sr0),
								 .sr1(sr1),
								 .sr2(sr2),
								 .fifo_full(fifo_full),
								 .we(we));
endmodule
