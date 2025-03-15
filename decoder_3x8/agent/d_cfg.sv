class d_cfg extends uvm_object;
	`uvm_object_utils(d_cfg)

	virtual inf vif;
	function new(string name="d_cfg");
		super.new(name);
	endfunction
endclass
