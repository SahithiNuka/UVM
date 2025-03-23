`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:02:30 09/29/2024 
// Design Name: 
// Module Name:    synchronizer_block 
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
module synchronizer_block(clk,rstn,detect_addr,write_enb_reg,re0,re1,re2,e0,e1,e2,f0,f1,f2,din,
					vo0,vo1,vo2,sr0,sr1,sr2,fifo_full,we);
					input clk,rstn,detect_addr,write_enb_reg,re0,re1,re2,e0,e1,e2,f0,f1,f2;
					input [1:0]din;
					output reg fifo_full,sr0,sr1,sr2;
					output vo0,vo1,vo2;
					output reg[2:0]we;
					reg [1:0]address;
					reg [4:0]count_0,count_1,count_2;
					
		//capturing address
		always@(posedge clk)
			begin
				if(!rstn)
					address<=2'b00;
				else if(detect_addr)
					address<=din;
			end
		
		//write enable logic - we
		always@(*)
			begin
				if(write_enb_reg)
					begin
						case(address)
							2'b00: we=3'b001;
							2'b01: we=3'b010;
							2'b10: we=3'b100;
							default: we=3'b000;
						endcase
					end
				else
					we=3'b000;
			end
			
		//fifo full logic
		always@(*)
			begin
				case(address)
					2'b00: fifo_full=f0;
					2'b01: fifo_full=f1;
					2'b10: fifo_full=f2;
					default: fifo_full=1'b0;
				endcase
			end
			
		//valid out logic - vo
		assign vo0=~e0;
		assign vo1=~e1;
		assign vo2=~e2;
		
		//soft reset logics - sr
		//sr0
		always@(posedge clk)
			begin
				if(!rstn)
					begin
						sr0<=1'b0;
						count_0<=5'd0;
					end
				else if(!vo0)
					begin
						sr0<=1'b0;
						count_0<=5'd0;
					end
				else if(re0)
					begin
						sr0<=1'b0;
						count_0<=5'd0;
					end
				else if(count_0<=5'd29)
					begin
						sr0<=1'b0;
						count_0<=count_0+5'd1;
					end
				else
					begin
						sr0<=1'b1;
						count_0<=5'd0;
					end
			end
		//sr1
		always@(posedge clk)
			begin
				if(!rstn)
					begin
						sr1<=1'b0;
						count_1<=5'd0;
					end
				else if(!vo1)
					begin
						sr1<=1'b0;
						count_1<=5'd0;
					end
				else if(re1)
					begin
						sr1<=1'b0;
						count_1<=5'd0;
					end
				else if(count_1<=5'd29)
					begin
						sr1<=1'b0;
						count_1<=count_1+5'd1;
					end
				else 
					begin
						sr1<=1'b1;
						count_1<=5'd0;
					end
			end
		//sr2
		always@(posedge clk)
			begin
				if(!rstn)
					begin
						sr2<=1'b0;
						count_2<=5'd0;
					end
				else if(!vo2)
					begin
						sr2<=1'b0;
						count_2<=5'd0;
					end
				else if(re2)
					begin
						sr2<=1'b0;
						count_2<=5'd0;
					end
				else if(count_2<=5'd29)
					begin
						sr2<=1'b0;
						count_2<=count_2+5'd1;
					end
				else
					begin
						sr2<=1'b1;
						count_2<=5'd0;
					end
			end
endmodule
