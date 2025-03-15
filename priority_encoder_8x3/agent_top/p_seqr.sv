class p_seqr extends uvm_sequencer #(p_trans);
	`uvm_component_utils(p_seqr)

	function new(string name="p_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
