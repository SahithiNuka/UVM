class d_agent extends uvm_agent;
	`uvm_component_utils(d_agent)

	d_driver drvh;
	d_monitor monh;
	d_seqr seqrh;
	
	function new(string name="d_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drvh = d_driver::type_id::create("drvh",this);
		monh = d_monitor::type_id::create("monh",this);
		seqrh = d_seqr::type_id::create("seqrh",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
endclass
