class p_test extends uvm_test;
	`uvm_component_utils(p_test)

	p_env envh;
	p_cfg cfg;

	function new(string name="p_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void p_config();
		if(!uvm_config_db #(virtual inf)::get(this,"","vif",cfg.vif))
			`uvm_fatal("TEST","Can't get virtual interface")
	endfunction

	function void build_phase(uvm_phase phase);
		cfg = p_cfg::type_id::create("cfg");
		p_config();
		uvm_config_db #(p_cfg)::set(this,"*","p_cfg",cfg);
		super.build_phase(phase);
		envh = p_env::type_id::create("envh",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass

class test_seq1 extends p_test;
	`uvm_component_utils(test_seq1)

	p_seq1 seq1;
	
	function new(string name="test_seq1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		seq1 = p_seq1::type_id::create("seq1");
		seq1.start(envh.agenth.seqrh);
		#100;
		
		phase.drop_objection(this);
	endtask
endclass









