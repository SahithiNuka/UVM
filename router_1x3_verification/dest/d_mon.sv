

class d_mon extends uvm_monitor;
	`uvm_component_utils(d_mon)

	d_cfg cfg;
	virtual router_if.DMON_MP vif;
	uvm_analysis_port #(d_trans) monitor_port;
	d_trans d_xtn;

	function new(string name="d_mon",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
			`uvm_fatal("DMON","Can't get d_cfg")
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
		d_xtn = d_trans::type_id::create("d_xtn");
		wait(vif.d_mon_cb.read_eb == 1 && vif.d_mon_cb.vld_out == 1)
		@(vif.d_mon_cb);
		d_xtn.header = vif.d_mon_cb.data_out;
		d_xtn.pl_data = new[d_xtn.header[7:2]];
		@(vif.d_mon_cb);
		foreach(d_xtn.pl_data[i])
			begin
				d_xtn.pl_data[i] = vif.d_mon_cb.data_out;
				@(vif.d_mon_cb);
			end
		d_xtn.parity = vif.d_mon_cb.data_out;
		`uvm_info("D_MON",$sformatf("printing from dest monitor \n %s", d_xtn.sprint()),UVM_LOW)
		monitor_port.write(d_xtn);
	endtask

endclass
