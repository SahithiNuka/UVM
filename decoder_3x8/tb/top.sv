module top;
	
	import d_pkg::*;
	import uvm_pkg::*;

	inf in1();

	decoder3_8 DUT(.in(in1.in),
			.en(in1.en),
			.out(in1.out));

	initial
		begin
			uvm_config_db #(virtual inf)::set(null,"*","vif",in1);
			run_test();
		end
endmodule
