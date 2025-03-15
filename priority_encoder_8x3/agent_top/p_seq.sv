class p_seq extends uvm_sequence #(p_trans);
	`uvm_object_utils(p_seq);
	
	function new(string name="p_seq");
		super.new(name);
	endfunction
endclass

class p_seq1 extends p_seq;
	`uvm_object_utils(p_seq1)

	p_trans p_xtn;

	function new(string name="p_seq1");
		super.new(name);
	endfunction

	task body();
		repeat(30)
			begin
				p_xtn=p_trans::type_id::create("p_xtn");
				start_item(p_xtn);
				assert(p_xtn.randomize());
				`uvm_info("SEQ",$sformatf("printing from sequence \n %s",p_xtn.sprint()),UVM_LOW)
				finish_item(p_xtn);
			end
	endtask
endclass

