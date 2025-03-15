class d_test extends uvm_test;
	`uvm_component_utils(d_test)

	d_env envh;
	d_cfg cfg;

	function new(string name="d_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void d_config();
		if(!uvm_config_db #(virtual inf)::get(this,"","vif",cfg.vif))
			`uvm_fatal("TEST","Can't get virtual interface")
	endfunction

	function void build_phase(uvm_phase phase);
		cfg = d_cfg::type_id::create("cfg");
		d_config();
		uvm_config_db #(d_cfg)::set(this,"*","d_cfg",cfg);
		super.build_phase(phase);
		envh = d_env::type_id::create("envh",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
endclass

class test_seq1 extends d_test;
	`uvm_component_utils(test_seq1)

	d_seq1 seq1;
	
	function new(string name="test_seq1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		seq1 = d_seq1::type_id::create("seq1");
		seq1.start(envh.agenth.seqrh);
		#100;
		
		phase.drop_objection(this);
	endtask
endclass









