

class uart_agent extends uvm_agent;
	`uvm_component_utils(uart_agent)

	a_cfg cfg;
	
	uart_driver drvh;
	uart_monitor monh;
	uart_seqr seqrh;

	function new(string name="uart_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(a_cfg)::get(this,"","a_cfg",cfg))
			`uvm_fatal("AGENT","Can't get a_cfg")
		monh = uart_monitor::type_id::create("monh",this);
		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh = uart_driver::type_id::create("drvh",this);
				seqrh = uart_seqr::type_id::create("seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(cfg.is_active == UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
			end
	endfunction
endclass
