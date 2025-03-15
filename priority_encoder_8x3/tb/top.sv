module top;
	
	import p_pkg::*;
	import uvm_pkg::*;

	inf in1();

	p_encoder DUT(.in(in1.in),
			.out(in1.out));

	initial
		begin
			uvm_config_db #(virtual inf)::set(null,"*","vif",in1);
			run_test();
		end
endmodule
