

class agent_top extends uvm_env;
	`uvm_component_utils(agent_top)

	uart_agent agenth[];
	
	env_cfg e_cfg;
		
	function new(string name="agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("AGENT TOP","Can't get env_cfg")

		agenth = new[e_cfg.no_of_agents];
		foreach(agenth[i])
			begin
				agenth[i] = uart_agent::type_id::create($sformatf("agenth[%0d]",i),this);
				uvm_config_db #(a_cfg)::set(this,$sformatf("agenth[%0d]*",i),"a_cfg",e_cfg.acfg[i]);
			end
	endfunction
endclass 
