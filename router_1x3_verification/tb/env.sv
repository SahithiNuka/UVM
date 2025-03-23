

class env extends uvm_env;
	`uvm_component_utils(env)

	env_cfg e_cfg;
	scoreboard sb;
	v_seqr vseqr;
	s_agt_top s_top;
	d_agt_top d_top;

	function new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("ENV","Cant get env_cfg")
		if(e_cfg.has_scoreboard)
			sb=scoreboard::type_id::create("sb",this);
		
		if(e_cfg.has_virtual_sequencer)
			vseqr = v_seqr::type_id::create("vseqr",this);
		s_top = s_agt_top::type_id::create("s_top",this);
		d_top = d_agt_top::type_id::create("d_top",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(e_cfg.has_virtual_sequencer)
			begin
				foreach(vseqr.s_seqrh[i])
					vseqr.s_seqrh[i] = s_top.agenth[i].seqrh;
				foreach(vseqr.d_seqrh[i])
					vseqr.d_seqrh[i] = d_top.agenth[i].seqrh;
			end
		if(e_cfg.has_scoreboard)
			begin
				foreach(s_top.agenth[i])
					s_top.agenth[i].monh.monitor_port.connect(sb.fifo_src.analysis_export);
				foreach(d_top.agenth[i])
					d_top.agenth[i].monh.monitor_port.connect(sb.fifo_dest[i].analysis_export);
			end
	endfunction

endclass






















