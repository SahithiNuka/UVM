

class s_agent extends uvm_agent;
	`uvm_component_utils(s_agent)

	s_cfg cfg;

	s_drv drvh;
	s_mon monh;
	s_seqr seqrh;

	function new(string name="s_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(s_cfg)::get(this,"","s_cfg",cfg))
			`uvm_fatal("S_AGENT","Can't get s_cfg!")
		monh = s_mon::type_id::create("monh",this);

		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh = s_drv::type_id::create("drvh",this);
				seqrh = s_seqr::type_id::create("seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
			end
	endfunction

endclass




















