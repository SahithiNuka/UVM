class p_trans extends uvm_sequence_item;
	`uvm_object_utils(p_trans)

	//properties
	rand logic[7:0]in;
	logic[2:0]out;

	constraint c1{in inside {8'd30,8'd96,8'd100,8'd185,8'd233,8'd12,8'd90,8'd221,8'd170,8'd88,8'd104,8'd176,8'd144,8'd32,8'd86,8'd64,8'd128};}
	
	function new(string name="p_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("IN",this.in,8,UVM_BIN);
		printer.print_field("OUT",this.out,3,UVM_BIN);
	endfunction
endclass
