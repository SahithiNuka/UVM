

class s_trans extends uvm_sequence_item;
	`uvm_object_utils(s_trans)

	//properties
	rand bit [7:0]header;
	rand bit [7:0]pl_data[];
	bit [7:0]parity;
	bit error;

	//constraints
	constraint c1{pl_data.size == header[7:2];}
	constraint c2{header [7:2] != 0;}
	constraint c3{header [1:0] != 3;}
	//constraint c4 {header [1:2] inside {0,1,2;}}
	function new(string name="s_trans");
		super.new(name);
	endfunction

	function void do_print (uvm_printer printer);
		//print_field((string name,bitstream value,size,radix//
		printer.print_field("header",this.header,8,UVM_HEX);
		foreach(pl_data[i])
			printer.print_field($sformatf("pl_data[%0d]",i),this.pl_data[i],8,UVM_HEX);
		printer.print_field("parity",this.parity,8,UVM_HEX);
	endfunction

	function void post_randomize();
		parity = 0 ^  header;
		foreach(pl_data[i])
			begin
				parity = parity ^ pl_data[i];
			end
	endfunction

endclass
