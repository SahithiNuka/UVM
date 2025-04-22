

class uart_env extends uvm_env;
	`uvm_component_utils(uart_env)

	env_cfg e_cfg;
	agent_top a_top;
	uart_sb sbh;
	uart_vseqr vseqrh;
	
	function new(string name="uart_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("ENV","Can't get env_cfg")

		if(e_cfg.has_scoreboard)
			 sbh = uart_sb::type_id::create("sbh",this);

		if(e_cfg.has_v_seqr)
			vseqrh = uart_vseqr::type_id::create("vseqrh",this);

		a_top = agent_top::type_id::create("a_top",this);		
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(e_cfg.has_v_seqr)
			begin
				foreach(vseqrh.seqrh[i])
					vseqrh.seqrh[i] = a_top.agenth[i].seqrh;
			end
		if(e_cfg.has_scoreboard)
			begin
				foreach(a_top.agenth[i])
					a_top.agenth[i].monh.monitor_port.connect(sbh.fifo[i].analysis_export);
			end
	endfunction
endclass
