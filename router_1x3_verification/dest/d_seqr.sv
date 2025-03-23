 

class d_seqr extends uvm_sequencer #(d_trans);
	`uvm_component_utils(d_seqr)

	function new(string name="d_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction
endclass
