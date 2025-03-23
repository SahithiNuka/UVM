

class env_cfg extends uvm_object;
	`uvm_object_utils(env_cfg)

	int no_of_sagents;
	int no_of_dagents;
	int has_scoreboard;
	int has_virtual_sequencer;

	s_cfg scfg[];
	d_cfg dcfg[];

	function new(string name="env_cfg");
		super.new(name);
	endfunction

endclass

