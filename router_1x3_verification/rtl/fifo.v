`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:41 09/29/2024 
// Design Name: 
// Module Name:    fifo 
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
module fifo(clk,rstn,we,re,soft_rst,lfd_state,empty,full,din,dout);
	input clk,rstn,we,re,soft_rst,lfd_state;
	input [7:0]din;
	output reg [7:0]dout;
	output full,empty;
	reg [4:0]wr_pt,rd_pt;
	reg [6:0]fifo_counter;
	reg lfd_state_s;
	
	reg [8:0]mem[15:0];
	integer i;
	
	//write pointer & read pointer logic
	always@(posedge clk)
		begin
			if(!rstn || soft_rst)
				begin
					wr_pt<=5'd0;
					rd_pt<=5'd0;
				end
			else
				begin
					if(re && !empty)
						rd_pt<=rd_pt+5'd1;
					else
						rd_pt<=rd_pt;
					if(we && !full)
						wr_pt<=wr_pt+5'd1;
					else
						wr_pt<=wr_pt;
				end
		end
		
	//lfd_state logic
	always@(posedge clk)
		begin
			if(!rstn)
				lfd_state_s<=1'b0;
			else
				lfd_state_s<=lfd_state;
		end
	
	//write operation
	always@(posedge clk)
		begin
			if(!rstn)
				begin
					for(i=0;i<16;i=i+1)
						begin
							mem[i]<=9'd0;
						end
				end
			else if(soft_rst)
				begin
					for(i=0;i<16;i=i+1)
						begin
							mem[i]<=9'd0;
						end
				end
			else if(we && !full)
				begin
					mem[wr_pt[3:0]]<={lfd_state_s,din};
				end
		end
	
	//read operation
	always@(posedge clk)
		begin
			if(!rstn)
				dout<=8'd0;
			else if(soft_rst)
				dout<=8'bz;
			else if(re && !empty)
				dout<=mem[rd_pt[3:0]][7:0];
		end
				
	//fifo counter logic
	always@(posedge clk)
		begin
			if(!rstn || soft_rst)
				fifo_counter<=7'd0;
			else if(re && !empty)
				begin
					if(mem[rd_pt[3:0]][8]==1)
						fifo_counter<=mem[rd_pt[3:0]][7:2]+7'd1;
					else if(fifo_counter!=7'd0)
						fifo_counter<=fifo_counter-7'd1;
				end
		end
		
	//empty & full logic
	assign full =((wr_pt[4]!=rd_pt[4]) && (wr_pt[3:0]==rd_pt[3:0]))?1'b1:1'b0;
	assign empty=(wr_pt==rd_pt)?1'b1:1'b0;

endmodule
