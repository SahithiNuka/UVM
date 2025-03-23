

class s_drv extends uvm_driver #(s_trans);
	
	`uvm_component_utils(s_drv)

	s_cfg cfg;
	virtual router_if.SDRV_MP vif;
	
	function new(string name="s_drv",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(s_cfg)::get(this,"","s_cfg",cfg))
			`uvm_fatal("SDRV","can't get s_cfg!")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.s_drv_cb);
		vif.s_drv_cb.rstn <= 0; //resetting the dut
		@(vif.s_drv_cb);
		vif.s_drv_cb.rstn <= 1; //setting dut

		forever
			begin
				seq_item_port.get_next_item(req); //sending request to sequence
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(s_trans s_xtn);
		`uvm_info("S_DRV",$sformatf("printing from driver \n %s", s_xtn.sprint()),UVM_LOW)
		@(vif.s_drv_cb);
		while(vif.s_drv_cb.busy)
			@(vif.s_drv_cb);

		vif.s_drv_cb.pkt_vld <= 1;
		vif.s_drv_cb.data_in <= s_xtn.header;
		@(vif.s_drv_cb);
		foreach(s_xtn.pl_data[i])
			begin
				while(vif.s_drv_cb.busy)
					@(vif.s_drv_cb);
				vif.s_drv_cb.data_in <= s_xtn.pl_data[i];
				@(vif.s_drv_cb);
			end
		while(vif.s_drv_cb.busy)
			@(vif.s_drv_cb);
		
		vif.s_drv_cb.pkt_vld <= 0;
		vif.s_drv_cb.data_in <= s_xtn.parity;
		
		repeat(2)
			@(vif.s_drv_cb);

		s_xtn.error = vif.s_drv_cb.error;

		cfg.drv_data_cnt++;


	endtask
	
endclass

























