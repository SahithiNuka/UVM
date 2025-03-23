

`timescale 1ns/1ps

module top;
	import router_pkg::*;
	import uvm_pkg::*;
	bit clock;
	
	always 
		#10 clock = !clock;

	router_if in(clock);
	router_if in0(clock);
	router_if in1(clock);
	router_if in2(clock);

	top_module DUV(.clk(clock),
			.rstn(in.rstn),
			.pkt_vd(in.pkt_vld),
			.re0(in0.read_eb),
			.re1(in1.read_eb),
			.re2(in2.read_eb),
			.din(in.data_in),
			.vo0(in0.vld_out),
			.vo1(in1.vld_out),
			.vo2(in2.vld_out),
			.busy(in.busy),
			.error(in.error),
			.dout0(in0.data_out),
			.dout1(in1.data_out),
			.dout2(in2.data_out));


	initial 
		begin
			`ifdef VCS 
			$fsdbDumpvars(0, top);
			`endif

			uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
			run_test();
		end


	property stable_data;
		@(posedge clock) in.busy |=> $stable(in.data_in);
	endproperty

	property busy_check;
		@(posedge clock) $rose(in.pkt_vld) |=> in.busy;
	endproperty

	property valid_signal;
		@(posedge clock) $rose(in.pkt_vld) |-> ##3(in0.vld_out | in1.vld_out |in2.vld_out);
	endproperty

	property rd_enb0;
		@(posedge clock) in0.vld_out |-> ##[1:29]in0.read_eb;
	endproperty

	property rd_enb1;
		@(posedge clock) in1.vld_out |-> ##[1:29]in1.read_eb;
	endproperty
	
	property rd_enb2;
		@(posedge clock) in2.vld_out |-> ##[1:29]in2.read_eb;
	endproperty
	
	property rd_enb0_low;
		@(posedge clock) $fell(in0.vld_out) |=> $fell(in0.read_eb);
	endproperty

	property rd_enb1_low;
		@(posedge clock) $fell(in1.vld_out) |=> $fell(in1.read_eb);
	endproperty

	property rd_enb2_low;
		@(posedge clock) $fell(in2.vld_out) |=> $fell(in2.read_eb);
	endproperty

	
	A1: assert property(stable_data)
		$display("assertion is successful for stable data");
	    else
		$display("assertion is failed for stable data");

	C1: cover property(stable_data);

	A2: assert property(busy_check)
		$display("assertion is successful for busy check");
	    else
		$display("assertion is failed for busy check");

	C2: cover property(busy_check);

	A3: assert property(valid_signal)
		$display("assertion is successful for valid signal");
	    else
		$display("assertion is failed for valid signal");
	
	C3: cover property(valid_signal);

	A4: assert property(rd_enb0)
		$display("assertion is successful for rd enb0");
	    else
		$display("assertion is failed for rd enb0");

	C4: cover property(rd_enb0);

	A5: assert property(rd_enb1)
		$display("assertion is successful for rd enb1");
	    else
		$display("assertion is failed for rd enb1");

	C5: cover property(rd_enb1);

	A6: assert property(rd_enb2)
		$display("assertion is successful for rd enb2");
	    else
		$display("assertion is failed for rd enb2");

	C6: cover property(rd_enb2);

	A7: assert property(rd_enb0_low)
		$display("assertion is successful for rd enb0 low");
	    else
		$display("assertion is failed for rd enb0 low");

	C7: cover property(rd_enb0_low);

	A8: assert property(rd_enb1_low)
		$display("assertion is successful for rd enb1 low");
	    else
		$display("assertion is failed for rd enb1 low");

	C8: cover property(rd_enb1_low);

	A9: assert property(rd_enb2_low)
		$display("assertion is successful for rd enb2 low");
	    else
		$display("assertion is failed for rd enb2 low");

	C9: cover property(rd_enb2_low);


endmodule
