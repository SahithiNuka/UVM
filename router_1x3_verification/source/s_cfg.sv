

class s_cfg extends uvm_object;
	`uvm_object_utils(s_cfg)

	virtual router_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	static int drv_data_cnt;
	static int mon_data_cnt;

	function new(string name="s_cfg");
		super.new(name);
	endfunction

endclass
