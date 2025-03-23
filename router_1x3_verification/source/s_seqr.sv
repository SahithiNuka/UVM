

class s_seqr extends uvm_sequencer #(s_trans);
	`uvm_component_utils(s_seqr)

	function new(string name="s_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
