

class d_drv extends uvm_driver #(d_trans);
	`uvm_component_utils(d_drv)

	d_cfg cfg;
	virtual router_if.DDRV_MP vif;
	
	function new(string name="d_drv",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
			`uvm_fatal("DDRV","Can't get d_cfg");
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(d_trans d_xtn);
//		`uvm_info("D_DRV",$sformatf("printing from driver \n %s", d_xtn.sprint()),UVM_LOW)
		@(vif.d_drv_cb);
		wait(vif.d_drv_cb.vld_out == 1)
		repeat(d_xtn.delay)
			@(vif.d_drv_cb);
		vif.d_drv_cb.read_eb <= 1'b1;
		@(vif.d_drv_cb);
		wait(vif.d_drv_cb.vld_out == 0)
		@(vif.d_drv_cb);
		vif.d_drv_cb.read_eb <= 1'b0;
	endtask

endclass
