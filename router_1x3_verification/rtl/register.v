`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:02 09/29/2024 
// Design Name: 
// Module Name:    register 
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
module register(clk,rstn,pkt_vd,fifo_full,rst_in_reg,detect_addr,ld_state,laf_state,full_state,lfd_state,din,parity_done,low_pkt_vd,error,dout);
	input clk,rstn,pkt_vd,fifo_full,rst_in_reg,detect_addr,ld_state,laf_state,full_state,lfd_state;
	input [7:0]din;
	output reg parity_done,low_pkt_vd,error;
	output reg [7:0]dout;
	reg [7:0]hold_header_reg,fifo_full_reg,pkt_parity_reg,itrnl_parity_reg;
	
	//dout logic
	always@(posedge clk)
		begin
			if (!rstn)
				dout<=8'b0;
			else 
				begin
					if (detect_addr && pkt_vd)
						hold_header_reg<=din;
					else if(lfd_state)
						dout<=hold_header_reg;
					else if(ld_state && !fifo_full)
						dout<=din;
					else if(ld_state && fifo_full)
						fifo_full_reg<=din;
					else if(laf_state)
						dout<=fifo_full_reg;
				end
		end


	//packet parity
	always@(posedge clk)
		begin
			if (!rstn)
				pkt_parity_reg<=8'b0;
			else if(!pkt_vd && ld_state)
				pkt_parity_reg<=din;
		end


	//internal parity
	always@(posedge clk)
		begin
			if (!rstn)
				itrnl_parity_reg<=8'b0;
			else if(lfd_state)
				itrnl_parity_reg<=itrnl_parity_reg^hold_header_reg;
			else if(ld_state && pkt_vd && !full_state)
				itrnl_parity_reg<=itrnl_parity_reg^din;
			else if(detect_addr)
				itrnl_parity_reg<=8'b0;
		end


	//error signal
	always@(posedge clk)
		begin
			if (!rstn)
				error<=1'b0;
			else 
				begin
					if (parity_done)
						begin
							if (itrnl_parity_reg != pkt_parity_reg)
								error<=1'b1;
							else
								error<=1'b0;
						end
				end
		end


	//parity done
	always@(posedge clk)
		begin
			if (!rstn)
				parity_done<=1'b0;
			else
				begin
					if (ld_state && !fifo_full && !pkt_vd)
						parity_done<=1'b1;
					else if(laf_state && !pkt_vd)
						parity_done<=1'b1;
					else 
						parity_done<=1'b0;
				end
		end


	//low_pkt_vld
	always@(posedge clk)
		begin
			if (!rstn)
				low_pkt_vd<=1'b0;
			else 
				begin
					if (rst_in_reg)
						low_pkt_vd<=1'b0;
					else if(ld_state && !pkt_vd)
						low_pkt_vd<=1'b1;
				end
		end
endmodule