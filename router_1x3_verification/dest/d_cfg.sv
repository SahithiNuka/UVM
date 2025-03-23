

class d_cfg extends uvm_object;
	`uvm_object_utils(d_cfg)

	virtual router_if vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	function new(string name="d_cfg");
		super.new(name);
	endfunction
endclass
