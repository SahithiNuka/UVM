

class d_agt_top extends uvm_env;
	`uvm_component_utils(d_agt_top)

	d_agent agenth[];
	env_cfg e_cfg;
	d_cfg dcfg[];
	function new(string name="d_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("DAGT_TOP","Can't get env_cfg")
		agenth = new[e_cfg.no_of_dagents];
		foreach(agenth[i])
			begin
				agenth[i] = d_agent::type_id::create($sformatf("agenth[%0d]",i),this);
				uvm_config_db#(d_cfg)::set(this,$sformatf("agenth[%0d]*",i),"d_cfg",e_cfg.dcfg[i]);
			end
	endfunction
	
endclass

	
