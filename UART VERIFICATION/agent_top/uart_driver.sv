

class uart_driver extends uvm_driver #(uart_trans);
	`uvm_component_utils(uart_driver)

	a_cfg cfg;

	virtual uart_interface.DRV_MP vif;

	function new(string name="uart_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(a_cfg)::get(this,"","a_cfg",cfg))
			`uvm_fatal("DRIVER","Can't get virtual interface")

	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b0; 
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b1;	
		vif.drv_cb.wb_stb_i <= 1'b0;
		vif.drv_cb.wb_cyc_i <= 1'b0;
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1'b0;
		
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(uart_trans u_xtn);
		`uvm_info("S_DRV",$sformatf("printing from driver \n %s", u_xtn.sprint()),UVM_LOW)
		@(vif.drv_cb);

		//control signal
		vif.drv_cb.wb_sel_i <= 4'b0001;
		vif.drv_cb.wb_stb_i <= 1'b1;
		vif.drv_cb.wb_cyc_i <= 1'b1;

		//data signals
		vif.drv_cb.wb_we_i <= u_xtn.we_i;
		vif.drv_cb.wb_adr_i <= u_xtn.wb_addr_i;
		vif.drv_cb.wb_dat_i <= u_xtn.wb_data_i;

		//waiting for UART acknowledgement
		wait(vif.drv_cb.wb_ack_o == 1'b1)
		vif.drv_cb.wb_stb_i <= 1'b0;
		vif.drv_cb.wb_cyc_i <= 1'b0;
		
		//the receiver driver logic
		if(u_xtn.wb_addr_i == 2 && u_xtn.we_i == 1'b0)
			begin
				wait(vif.drv_cb.int_o);
				repeat(2)
					@(vif.drv_cb);
				u_xtn.iir = vif.drv_cb.wb_dat_o;
				seq_item_port.put_response(u_xtn);
			end
	endtask
endclass
