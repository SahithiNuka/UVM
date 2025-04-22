
class uart_test extends uvm_test;
	`uvm_component_utils(uart_test)

	env_cfg e_cfg;
	a_cfg acfg[];

	int no_of_agents = 2;
	int has_scoreboard = 1;
	int has_v_seqr = 1;

	uart_env envh;

	function new(string name = "uart_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		acfg = new[no_of_agents];
		e_cfg = env_cfg::type_id::create("e_cfg");
		e_cfg.acfg = new[no_of_agents];
		
		foreach(acfg[i])
			begin
				acfg[i] = a_cfg::type_id::create($sformatf("acfg[%0d]",i));
				if(!uvm_config_db #(virtual uart_interface)::get(this,"",$sformatf("vif_%0d",i),acfg[i].vif))
					`uvm_fatal("TEST","Can't get virtual interface")
				acfg[i].is_active = UVM_ACTIVE;
				e_cfg.acfg[i] = acfg[i];
			end
		e_cfg.no_of_agents = no_of_agents;
		e_cfg.has_scoreboard = has_scoreboard;
		e_cfg.has_v_seqr = has_v_seqr;

		uvm_config_db #(env_cfg)::set(this,"*","env_cfg",e_cfg);
		super.build_phase(phase);
		envh = uart_env::type_id::create("envh",this);
	endfunction

	task run_phase(uvm_phase phase);
		uvm_top.print_topology();
	endtask
endclass


//full duplex test

class full_duplex_test extends uart_test;
	`uvm_component_utils(full_duplex_test)

	full_duplex1 f1;
	full_duplex2 f2;

	function new(string name="full_duplex_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		f1 = full_duplex1::type_id::create("f1");
		f2 = full_duplex2::type_id::create("f2");
		fork
			f1.start(envh.a_top.agenth[0].seqrh);
			f2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass
			

//half duplex test
class half_duplex_test extends uart_test;
	`uvm_component_utils(half_duplex_test)

	half_duplex1 h1;
	half_duplex2 h2;

	function new(string name="half_duplex_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		h1 = half_duplex1::type_id::create("h1");
		h2 = half_duplex2::type_id::create("h2");
		fork
			h1.start(envh.a_top.agenth[0].seqrh);
			h2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass
			

//loop back test
class loop_back_test extends uart_test;
	`uvm_component_utils(loop_back_test)

	loop_back1 l1;
	loop_back2 l2;

	function new(string name="loop_back_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		l1 = loop_back1::type_id::create("l1");
		l2 = loop_back2::type_id::create("l2");
		fork
			l1.start(envh.a_top.agenth[0].seqrh);
			l2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass
			
//parity error test
class parity_error_test extends uart_test;
	`uvm_component_utils(parity_error_test)

	parity_seq1 p1;
	parity_seq2 p2;

	function new(string name="parity_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		p1 = parity_seq1::type_id::create("p1");
		p2 = parity_seq2::type_id::create("p2");
		fork
			p1.start(envh.a_top.agenth[0].seqrh);
			p2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass


//framing error test
class framing_error_test extends uart_test;
	`uvm_component_utils(framing_error_test)

	framing_seq1 f1;
	framing_seq2 f2;

	function new(string name="framing_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		f1 = framing_seq1::type_id::create("f1");
		f2 = framing_seq2::type_id::create("f2");
		fork
			f1.start(envh.a_top.agenth[0].seqrh);
			f2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass


//overrun error test
class overrun_error_test extends uart_test;
	`uvm_component_utils(overrun_error_test)

	overrun_seq1 o1;
	overrun_seq2 o2;

	function new(string name="overrun_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		o1 = overrun_seq1::type_id::create("o1");
		o2 = overrun_seq2::type_id::create("o2");
		fork
			o1.start(envh.a_top.agenth[0].seqrh);
			o2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass


//break interrupt error test
class break_int_test extends uart_test;
	`uvm_component_utils(break_int_test)

	break_int_seq1 b1;
	break_int_seq2 b2;

	function new(string name="break_int_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		b1 = break_int_seq1::type_id::create("b1");
		b2 = break_int_seq2::type_id::create("b2");
		fork
			b1.start(envh.a_top.agenth[0].seqrh);
			b2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass


//timeout error test
class timeout_error_test extends uart_test;
	`uvm_component_utils(timeout_error_test)

	timeout_seq1 t1;
	timeout_seq2 t2;

	function new(string name="timeout_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		t1 = timeout_seq1::type_id::create("t1");
		t2 = timeout_seq2::type_id::create("t2");
		fork
			t1.start(envh.a_top.agenth[0].seqrh);
			t2.start(envh.a_top.agenth[1].seqrh);
		join
		#10000;
		phase.drop_objection(this);
	endtask
endclass


//timeout error test
class thrempty_test extends uart_test;
	`uvm_component_utils(thrempty_test)

	thrempty_seq1 th1;
	thrempty_seq2 th2;

	function new(string name="thrempty_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		th1 = thrempty_seq1::type_id::create("th1");
		th2 = thrempty_seq2::type_id::create("th2");
		fork
			th1.start(envh.a_top.agenth[0].seqrh);
			th2.start(envh.a_top.agenth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass














