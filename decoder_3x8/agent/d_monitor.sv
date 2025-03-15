class d_monitor extends uvm_monitor;
	`uvm_component_utils(d_monitor)
	
	uvm_analysis_port #(d_trans)mon2sb;
	virtual inf.MP2 vif;
	d_cfg cfg;	
	function new(string name="d_monitor",uvm_component parent);
		super.new(name,parent);
		mon2sb = new("mon2sb",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
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
		d_trans d_xtn;
		d_xtn = d_trans::type_id::create("d_xtn");
		@(vif.MP2.en or vif.MP2.in or vif.MP2.out);
		d_xtn.in = vif.MP2.in;
		d_xtn.en = vif.MP2.en;
		d_xtn.out = vif.MP2.out;
		`uvm_info("MONITOR",$sformatf("Printing from monitor \n %s",d_xtn.sprint()),UVM_LOW)
		mon2sb.write(d_xtn);
	endtask	

endclass
