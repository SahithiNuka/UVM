class p_monitor extends uvm_monitor;
	`uvm_component_utils(p_monitor)
	
	uvm_analysis_port #(p_trans)mon2sb;
	virtual inf.MP vif;
	p_cfg cfg;	
	function new(string name="p_monitor",uvm_component parent);
		super.new(name,parent);
		mon2sb = new("mon2sb",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(p_cfg)::get(this,"","p_cfg",cfg))
			`uvm_fatal("MONITOR","Can't get virtual address")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();
			end
	endtask

	task collect_data();
		p_trans p_xtn;
		p_xtn = p_trans::type_id::create("p_xtn");
		@(vif.MP.in);
		p_xtn.in = vif.MP.in;
		p_xtn.out = vif.MP.out;
		`uvm_info("MONITOR",$sformatf("Printing from monitor \n %s",p_xtn.sprint()),UVM_LOW)
		mon2sb.write(p_xtn);
	endtask	

endclass
