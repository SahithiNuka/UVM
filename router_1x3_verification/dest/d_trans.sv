 

class d_trans extends uvm_sequence_item;
	`uvm_object_utils(d_trans)

	//properties
	bit [7:0]header;
	bit [7:0]pl_data[];
	bit [7:0]parity;
	bit read_eb, vld_out;
	rand bit [5:0]delay;

	function new(string name="d_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("header",this.header,8,UVM_HEX);
		foreach(pl_data[i])
			printer.print_field($sformatf("pl_data[%0d]",i),this.pl_data[i],8,UVM_HEX);
		printer.print_field("parity",this.parity,8,UVM_HEX);
		/*printer.print_field("read_eb",this.read_eb,1,UVM_BIN);
		printer.print_field("vld_out",this.vld_out,1,UVM_BIN);
		*/
	endfunction
endclass
