

class uart_monitor extends uvm_monitor;
	`uvm_component_utils(uart_monitor)

	a_cfg cfg;
	uart_trans u_xtn;

	virtual uart_interface.MON_MP vif;

	uvm_analysis_port #(uart_trans)monitor_port;

	function new(string name="uart_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(a_cfg)::get(this,"","a_cfg",cfg))
			`uvm_fatal("MONITOR","Can't get virtual interface")
		u_xtn = uart_trans::type_id::create("u_xtn");
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
		@(vif.mon_cb);
		wait(vif.mon_cb.wb_ack_o)

		//collecting the signals
		u_xtn.we_i = vif.mon_cb.wb_we_i;
		u_xtn.wb_stb_i = vif.mon_cb.wb_stb_i;
		u_xtn.wb_cyc_i = vif.mon_cb.wb_cyc_i;
		u_xtn.wb_data_i = vif.mon_cb.wb_dat_i;
		u_xtn.wb_sel_i = vif.mon_cb.wb_sel_i;
		u_xtn.wb_addr_i = vif.mon_cb.wb_adr_i;
		u_xtn.wb_data_o = vif.mon_cb.wb_dat_o;
		u_xtn.wb_rst_i = vif.mon_cb.wb_rst_i;
		u_xtn.wb_ack_o = vif.mon_cb.wb_ack_o;
		u_xtn.int_o = vif.mon_cb.int_o;

		//lcr register
		if(u_xtn.wb_addr_i == 3 && u_xtn.we_i == 1)
			u_xtn.lcr = vif.mon_cb.wb_dat_i;

		//dlr (msb)
		if(u_xtn.lcr[7] == 1 && u_xtn.wb_addr_i == 1 && u_xtn.we_i == 1)
			u_xtn.dlr_msb = vif.mon_cb.wb_dat_i;

		//dlr (msb)
		if(u_xtn.lcr[7] == 1 && u_xtn.wb_addr_i == 0 && u_xtn.we_i == 1)
			u_xtn.dlr_lsb = vif.mon_cb.wb_dat_i;

		//fcr register
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 2 && u_xtn.we_i == 1)
			u_xtn.fcr = vif.mon_cb.wb_dat_i;

		//ier 
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 1 && u_xtn.we_i == 1)
			u_xtn.ier = vif.mon_cb.wb_dat_i;

		//thr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 0 && u_xtn.we_i == 1)
			u_xtn.thr.push_back(vif.mon_cb.wb_dat_i);

		//rb
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 0 && u_xtn.we_i == 0)
			u_xtn.rb.push_back(vif.mon_cb.wb_dat_o);
		
		//mcr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 4 && u_xtn.we_i == 1)
			u_xtn.mcr = vif.mon_cb.wb_dat_i;

		//lsr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 5 && u_xtn.we_i == 0)
			u_xtn.lsr = vif.mon_cb.wb_dat_o; 

		//iir
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_addr_i == 2 && u_xtn.we_i == 0)
			begin
				wait(vif.mon_cb.int_o)
				@(vif.mon_cb);
				u_xtn.iir = vif.mon_cb.wb_dat_o;
			end
		`uvm_info(get_type_name(),$sformatf("printing from monitor \n %s", u_xtn.sprint()),UVM_LOW)
		monitor_port.write(u_xtn); //sending to scoreboard
	endtask
endclass
