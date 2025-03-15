class d_driver extends uvm_driver #(d_trans);
	`uvm_component_utils(d_driver)

	uvm_analysis_port #(d_trans)drv2sb;
	virtual inf.MP1 vif;
	d_cfg cfg;
	function new(string name="d_driver",uvm_component parent);
		super.new(name,parent);
		drv2sb = new("drv2sb",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
			`uvm_fatal("DRIVER","Can't get virtual interface")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		d_trans d_xtn;
		d_xtn = d_trans::type_id::create("d_xtn");
		forever
			begin
				seq_item_port.get_next_item(d_xtn);
				send_to_dut(d_xtn);
				drv2sb.write(d_xtn);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(d_trans d_xtn);
		`uvm_info("DRIVER",$sformatf("Printing from driver \n %s",d_xtn.sprint()),UVM_LOW)
		vif.MP1.in <= d_xtn.in;
		vif.MP1.en <= d_xtn.en;
	endtask

endclass
