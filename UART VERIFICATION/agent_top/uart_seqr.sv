

class uart_seqr extends uvm_sequencer #(uart_trans);
	`uvm_component_utils(uart_seqr)

	function new(string name="uart_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction
endclass
