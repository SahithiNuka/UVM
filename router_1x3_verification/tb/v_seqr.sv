

class v_seqr extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(v_seqr)

	s_seqr s_seqrh[];
	d_seqr d_seqrh[];

	env_cfg e_cfg;

	function new(string name="v_seqr",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("VSEQR","Can't get env_cfg!!")
		s_seqrh = new[e_cfg.no_of_sagents];
		d_seqrh = new[e_cfg.no_of_dagents];
	endfunction

endclass
