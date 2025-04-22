

class a_cfg extends uvm_object;
	`uvm_object_utils(a_cfg)

	virtual uart_interface vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	function new(string name="a_cfg");
		super.new(name);
	endfunction
endclass
