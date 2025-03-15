class p_driver extends uvm_driver #(p_trans);
	`uvm_component_utils(p_driver)

	uvm_analysis_port #(p_trans)drv2sb;
	virtual inf.MP vif;
	p_cfg cfg;
	function new(string name="p_driver",uvm_component parent);
		super.new(name,parent);
		drv2sb = new("drv2sb",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(p_cfg)::get(this,"","p_cfg",cfg))
			`uvm_fatal("DRIVER","Can't get virtual interface")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		p_trans p_xtn;
		p_xtn = p_trans::type_id::create("p_xtn");
		forever
			begin
				seq_item_port.get_next_item(p_xtn);
				send_to_dut(p_xtn);
				drv2sb.write(p_xtn);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(p_trans p_xtn);
		`uvm_info("DRIVER",$sformatf("Printing from driver \n %s",p_xtn.sprint()),UVM_LOW)
		vif.MP.in <= p_xtn.in;
	endtask

endclass
