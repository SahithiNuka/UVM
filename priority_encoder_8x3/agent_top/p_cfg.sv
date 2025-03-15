class p_cfg extends uvm_object;
	`uvm_object_utils(p_cfg)

	virtual inf vif;
	function new(string name="p_cfg");
		super.new(name);
	endfunction
endclass
