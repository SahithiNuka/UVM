class p_agent extends uvm_agent;
	`uvm_component_utils(p_agent)

	p_driver drvh;
	p_monitor monh;
	p_seqr seqrh;
	
	function new(string name="p_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drvh = p_driver::type_id::create("drvh",this);
		monh = p_monitor::type_id::create("monh",this);
		seqrh = p_seqr::type_id::create("seqrh",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
endclass
