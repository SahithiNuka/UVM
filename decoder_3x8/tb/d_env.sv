class d_env extends uvm_env;
	`uvm_component_utils(d_env)

	d_agent agenth;
	d_sb sbh;

	function new(string name="d_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agenth = d_agent::type_id::create("agenth",this);
		sbh = d_sb::type_id::create("sbh",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agenth.drvh.drv2sb.connect(sbh.fifo_drv.analysis_export);
		agenth.monh.mon2sb.connect(sbh.fifo_mon.analysis_export);
	endfunction
endclass
