

class env_cfg extends uvm_object;
	`uvm_object_utils(env_cfg)

	int no_of_agents;
	int has_scoreboard;
	int has_v_seqr;

	a_cfg acfg[];

	function new(string name="env_cfg");
		super.new(name);
	endfunction
endclass

