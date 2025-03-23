

class v_seqs extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(v_seqs)

	v_seqr vseqr;
	s_seqr s_seqrh[];
	d_seqr d_seqrh[];
	env_cfg e_cfg;

	function new(string name="v_seqs");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(env_cfg)::get(null,get_full_name(),"env_cfg",e_cfg))
			`uvm_fatal("VSEQS","Cant get env_cfg")
		s_seqrh = new[e_cfg.no_of_sagents];
		d_seqrh = new[e_cfg.no_of_dagents];
		assert($cast(vseqr,m_sequencer))
		else
			begin
				`uvm_fatal("V_SEQS","Error in $cast of virtual sequencer")
			end
		foreach(s_seqrh[i])
			s_seqrh[i] = vseqr.s_seqrh[i];
		foreach(d_seqrh[i])
			d_seqrh[i] = vseqr.d_seqrh[i];
	endtask
endclass	

//small pkt with normal delay
class s_vseq extends v_seqs;
	`uvm_object_utils(s_vseq)
	
	bit [1:0]address;
	small_pkt s_pkt;
	d_seq1 seq1;

	function new(string name="s_vseq");
		super.new(name);
	endfunction

	task body();
                super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("V_SEQ","Can't get address")
		s_pkt = small_pkt::type_id::create("s_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		fork
			begin
				s_pkt.start(s_seqrh[0]);
			end

			begin
				if(address == 2'b00)
					seq1.start(d_seqrh[0]);
				if(address == 2'b01)
					seq1.start(d_seqrh[1]);
				if(address == 2'b10)
					seq1.start(d_seqrh[2]);
			end
		join
	endtask

endclass


//medium pkt with normal delay
class m_vseq extends v_seqs;
	`uvm_object_utils(m_vseq)
	
	bit [1:0]address;
	medium_pkt m_pkt;
	d_seq1 seq1;

	function new(string name="m_vseq");
		super.new(name);
	endfunction

	task body();
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("V_SEQ","Can't get address")
		m_pkt = medium_pkt::type_id::create("m_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		fork
			begin
				m_pkt.start(s_seqrh[0]);
			end

			begin
				if(address == 2'b00)
					seq1.start(d_seqrh[0]);
				if(address == 2'b01)
					seq1.start(d_seqrh[1]);
				if(address == 2'b10)
					seq1.start(d_seqrh[2]);
			end
		join
	endtask

endclass



//big pkt with normal delay
class b_vseq extends v_seqs;
	`uvm_object_utils(b_vseq)
	
	bit [1:0]address;
	big_pkt b_pkt;
	d_seq1 seq1;

	function new(string name="b_vseq");
		super.new(name);
	endfunction

	task body();
                super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("V_SEQ","Can't get address")
		b_pkt = big_pkt::type_id::create("b_pkt");
		seq1 = d_seq1::type_id::create("seq1");
		fork
			begin
				b_pkt.start(s_seqrh[0]);
			end

			begin
				if(address == 2'b00)
					seq1.start(d_seqrh[0]);
				if(address == 2'b01)
					seq1.start(d_seqrh[1]);
				if(address == 2'b10)
					seq1.start(d_seqrh[2]);
			end
		join
	endtask

endclass







