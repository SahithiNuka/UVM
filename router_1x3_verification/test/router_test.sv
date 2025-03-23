

class router_test extends uvm_test;
	`uvm_component_utils(router_test)

	env_cfg e_cfg;
	s_cfg scfg[];
	d_cfg dcfg[];

	int no_of_sagents = 1;
	int no_of_dagents = 3;
	int has_scoreboard = 1;
	int has_virtual_sequencer = 1;

	env envh;

	function new(string name="router_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		scfg = new[no_of_sagents];
		dcfg = new[no_of_dagents];
		e_cfg = env_cfg::type_id::create("e_cfg");
		e_cfg.scfg = new[no_of_sagents];
		e_cfg.dcfg = new[no_of_dagents];
		
		foreach(scfg[i])
			begin
			scfg[i] = s_cfg::type_id::create($sformatf("scfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"","vif",scfg[i].vif))
				`uvm_fatal("TEST","Cant find vif")
			scfg[i].is_active = UVM_ACTIVE;
			e_cfg.scfg[i] = scfg[i];
			end

		foreach(dcfg[i])
			begin
			dcfg[i] = d_cfg::type_id::create($sformatf("dcfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),dcfg[i].vif))
				`uvm_fatal("TEST","cant find vif")
		
			dcfg[i].is_active = UVM_ACTIVE;
			e_cfg.dcfg[i] = dcfg[i];
			end
 	
		e_cfg.no_of_sagents = no_of_sagents;
		e_cfg.no_of_dagents = no_of_dagents;
		e_cfg.has_scoreboard = has_scoreboard;
		e_cfg.has_virtual_sequencer = has_virtual_sequencer;
		uvm_config_db #(env_cfg)::set(this,"*","env_cfg",e_cfg);
		super.build_phase(phase);
		envh = env::type_id::create("envh",this);
	endfunction

	task run_phase(uvm_phase phase);
		uvm_top.print_topology();
	endtask

endclass

// without using virtual sequence n sequencer
//small packet test  
class small_pkt_test extends router_test;
	`uvm_component_utils(small_pkt_test)

	small_pkt s_pkt;
	d_seq1 seq1;
//	sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="small_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 0;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		s_pkt = small_pkt::type_id::create("s_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				s_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass


//small packet test 1
class small_pkt_test1 extends router_test;
	`uvm_component_utils(small_pkt_test1)

	small_pkt s_pkt;
	d_seq1 seq1;
//	sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="small_pkt_test1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		s_pkt = small_pkt::type_id::create("s_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				s_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass


//small packet test 2 
class small_pkt_test2 extends router_test;
	`uvm_component_utils(small_pkt_test2)

	small_pkt s_pkt;
	d_seq1 seq1;
//	sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="small_pkt_test2",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 2;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		s_pkt = small_pkt::type_id::create("s_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				s_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass

//medium packet test 0
class med_pkt_test extends router_test;
	`uvm_component_utils(med_pkt_test)

	medium_pkt m_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="med_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 0;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		m_pkt = medium_pkt::type_id::create("m_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				m_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass


//medium packet test 1
class med_pkt_test1 extends router_test;
	`uvm_component_utils(med_pkt_test1)

	medium_pkt m_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="med_pkt_test1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		m_pkt = medium_pkt::type_id::create("m_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				m_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass
//medium packet test 2
class med_pkt_test2 extends router_test;
	`uvm_component_utils(med_pkt_test2)

	medium_pkt m_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="med_pkt_test2",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 2;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		m_pkt = medium_pkt::type_id::create("m_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				m_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass


//big packet test 0
class big_pkt_test extends router_test;
	`uvm_component_utils(big_pkt_test)

	big_pkt b_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="big_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 0;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		b_pkt = big_pkt::type_id::create("b_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				b_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass


//big packet test 1
class big_pkt_test1 extends router_test;
	`uvm_component_utils(big_pkt_test1)

	big_pkt b_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="big_pkt_test1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		b_pkt = big_pkt::type_id::create("b_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				b_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass



//big packet test 2
class big_pkt_test2 extends router_test;
	`uvm_component_utils(big_pkt_test2)

	big_pkt b_pkt;
	d_seq1 seq1;
	//sft_rst_seq seq2;
	bit [1:0] address;

	function new(string name="big_pkt_test2",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
	
		phase.raise_objection(this);
		
		address = 2;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
		
		b_pkt = big_pkt::type_id::create("b_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		//seq2 = sft_rst_seq::type_id::create("seq2");
		fork
			foreach(envh.s_top.agenth[i])
				b_pkt.start(envh.s_top.agenth[i].seqrh);
			seq1.start(envh.d_top.agenth[address].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask

endclass



















/*
//////////////////////////////////////////////////////////////////////////////////////////////


//using virtual sequence and sequencer
//small pkt
class small_pkt_test extends router_test;
	`uvm_component_utils(small_pkt_test)

	s_vseq vseq;
	
	
	bit [1:0]address;

	function new(string name="small_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);

		vseq = s_vseq::type_id::create("vseq");
		vseq.start(envh.vseqr);
		#100;
		phase.drop_objection(this);
	endtask
endclass


//medium pkt
class med_pkt_test extends router_test;
	`uvm_component_utils(med_pkt_test)

	m_vseq vseq;
	
	
	bit [1:0]address;

	function new(string name="med_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);

		vseq = m_vseq::type_id::create("vseq");
		vseq.start(envh.vseqr);
		#100;
		phase.drop_objection(this);
	endtask
endclass


//big pkt
class big_pkt_test extends router_test;
	`uvm_component_utils(big_pkt_test)

	b_vseq vseq;
	
	
	bit [1:0]address;

	function new(string name="big_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		address = 1;
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);

		vseq = b_vseq::type_id::create("vseq");
		vseq.start(envh.vseqr);
		#100;
		phase.drop_objection(this);
	endtask
endclass

*/








