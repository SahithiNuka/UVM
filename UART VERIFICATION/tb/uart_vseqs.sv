

class uart_vseqs extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(uart_vseqs)

	uart_vseqr vseqr;
	uart_seqr seqrh[];
	env_cfg e_cfg;

	function new(string name="uart_vseqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(env_cfg)::get(null,get_full_name(),"env_cfg",e_cfg))
			`uvm_fatal("VSEQS","Can't get env_cfg")
		seqrh = new[e_cfg.no_of_agents];
		assert($cast(vseqr,m_sequencer))
		else
			begin
				`uvm_fatal("V_SEQS","Error in $cast of virtual sequencer")
			end

		foreach(seqrh[i])
			seqrh[i] = vseqr.seqrh[i];
	endtask
endclass
