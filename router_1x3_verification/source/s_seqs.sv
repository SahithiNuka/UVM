

class s_seqs extends uvm_sequence #(s_trans);
	`uvm_object_utils(s_seqs)

	function new(string name="s_seqs");
		super.new(name);
	endfunction

endclass

//small packet sequence
class small_pkt extends s_seqs;
	`uvm_object_utils(small_pkt)

	bit [1:0]address;

	function new(string name="small_pkt");
		super.new(name);
	endfunction

	task body();
		
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("S_SEQS","Cant get address")
	//	repeat(10)
	//		begin
		req = s_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:20]} && header[1:0] == address;});
		`uvm_info("S_SEQ",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
		finish_item(req);
	//		end
	endtask
endclass


//medium packet sequence

class medium_pkt extends s_seqs;
	`uvm_object_utils(medium_pkt)

	bit [1:0]address;

	function new(string name="medium_pkt");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("S_SEQS","Cant get address")
//		repeat(10)
//			begin
		req = s_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[21:40]} && header[1:0] == address;});
		`uvm_info("S_SEQ",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
		finish_item(req);
//			end
	endtask
endclass


//big packet sequence

class big_pkt extends s_seqs;
	`uvm_object_utils(big_pkt)

	bit [1:0]address;

	function new(string name="big_pkt");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("S_SEQ","Cant get address")
//		repeat(10)
//			begin
		req = s_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[41:63]} && header[1:0] == address;});
		`uvm_info("S_SEQ",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
		finish_item(req);
//			end
	endtask
endclass

