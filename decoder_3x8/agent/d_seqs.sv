class d_seqs extends uvm_sequence #(d_trans);
	`uvm_object_utils(d_seqs);
	
	function new(string name="d_seqs");
		super.new(name);
	endfunction
endclass

class d_seq1 extends d_seqs;
	`uvm_object_utils(d_seq1)

	d_trans d_xtn;
	function new(string name="d_seq1");
		super.new(name);
	endfunction

	task body();
		repeat(1)
			begin
				for(int i=0; i<8; i++)
					begin
						d_xtn = d_trans::type_id::create("d_xtn");
						start_item(d_xtn);
						assert(d_xtn.randomize() with {d_xtn.en == 1; d_xtn.in == i;});
						`uvm_info("SEQ",$sformatf("Printing from sequence \n %s",d_xtn.sprint()),UVM_LOW)
						finish_item(d_xtn);
					end
			end
	endtask
endclass
