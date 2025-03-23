

class d_agent extends uvm_agent;
	`uvm_component_utils(d_agent)
	
	d_cfg cfg;

	d_drv drvh;
	d_mon monh;
	d_seqr seqrh;

	function new(string name="d_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
			`uvm_fatal("D_AGENT","Can't get d_cfg")
		monh = d_mon::type_id::create("monh",this);
		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh = d_drv::type_id::create("drvh",this);
				seqrh = d_seqr::type_id::create("seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
			end
	endfunction

endclass
