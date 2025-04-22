
class uart_vseqr extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(uart_vseqr)

	uart_seqr seqrh[];
	env_cfg e_cfg;

	function new(string name="uart_vseqr",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("VSEQR","Can't get env_cfg")
		seqrh = new[e_cfg.no_of_agents];
	endfunction

endclass
