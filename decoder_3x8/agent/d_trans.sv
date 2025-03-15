class d_trans extends uvm_sequence_item;
	`uvm_object_utils(d_trans)

	//properties
	rand logic[2:0]in;
	rand logic en;
	logic[7:0]out;

	function new(string name="d_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("EN",this.en,1,UVM_BIN);
		printer.print_field("IN",this.in,3,UVM_BIN);
		printer.print_field("OUT",this.out,8,UVM_BIN);
	endfunction
endclass
