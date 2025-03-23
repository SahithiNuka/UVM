

class d_seqs extends uvm_sequence #(d_trans);
	`uvm_object_utils(d_seqs)

	function new(string name="d_seqs");
		super.new(name);
	endfunction
endclass


class d_seq1 extends d_seqs;
	`uvm_object_utils(d_seq1)

	function new(string name = "d_seq1");
		super.new(name);
	endfunction

	task body();
		req = d_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {delay < 29;});
		finish_item(req);
	endtask
endclass

class sft_rst_seq extends d_seq1;
	`uvm_object_utils(sft_rst_seq)
	
	function new(string name="sft_rst_seq");
		super.new(name);
	endfunction

	task body();
		req = d_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {delay > 30;});
		finish_item(req);
	endtask
endclass














