

class s_agt_top extends uvm_env;
	`uvm_component_utils(s_agt_top)

	s_agent agenth[];
	env_cfg e_cfg;
	function new(string name="s_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("SAGT_TOP","Can't get e_cfg!")
		agenth = new[e_cfg.no_of_sagents];
		foreach(agenth[i])
			begin
				agenth[i] = s_agent::type_id::create($sformatf("agenth[%0d]",i),this);
				uvm_config_db #(s_cfg)::set(this,$sformatf("agenth[%0d]*",i),"s_cfg",e_cfg.scfg[i]);
			end
	endfunction

endclass

	
