class p_sb extends uvm_scoreboard;
	`uvm_component_utils(p_sb)

	p_trans p_xtn1, p_xtn_cov1, p_xtn2, p_xtn_cov2;	
	uvm_tlm_analysis_fifo #(p_trans)fifo_drv;
	uvm_tlm_analysis_fifo #(p_trans)fifo_mon;

	covergroup fcov1;
		option.per_instance = 1;
		C1: coverpoint p_xtn_cov1.in {bins b1 = {[0:63]};
					    	bins b2 = {[64:127]};
						bins b3 = {[128:191]};
						bins b4 = {[192:255]};}
	endgroup

	covergroup fcov2;
		option.per_instance = 1;
		C1: coverpoint p_xtn_cov2.out{bins b1 = {3'b000};
						bins b2 = {3'b001};
						bins b3 = {3'b010};
						bins b4 = {3'b011};
						bins b5 = {3'b100};
						bins b6 = {3'b101};
						bins b7 = {3'b110};
						bins b8 = {3'b111};}
	endgroup
	function new(string name="p_sb",uvm_component parent);
		super.new(name,parent);
		fifo_drv = new("fifo_drv",this);
		fifo_mon = new("fifo_mon",this);
		fcov1 = new();
		fcov2 = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		forever
			fork
				begin
					fifo_drv.get(p_xtn1);
					p_xtn_cov1 = p_xtn1;
					p_xtn1.print();
					fcov1.sample();
				end
				begin
					fifo_mon.get(p_xtn2);
					p_xtn_cov2 = p_xtn2;
					fcov2.sample();
				end
			join
	endtask
endclass
