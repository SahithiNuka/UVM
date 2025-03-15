class d_sb extends uvm_scoreboard;
	`uvm_component_utils(d_sb)

	d_trans d_xtn1, d_xtn_cov1;	
	uvm_tlm_analysis_fifo #(d_trans)fifo_drv;
	uvm_tlm_analysis_fifo #(d_trans)fifo_mon;

	covergroup fcov1;
		option.per_instance = 1;
		C1: coverpoint d_xtn_cov1.in {bins b1 = {3'b000};
						bins b2 = {3'b001};
						bins b3 = {3'b010};
						bins b4 = {3'b011};
						bins b5 = {3'b100};
						bins b6 = {3'b101};
						bins b7 = {3'b110};
						bins b8 = {3'b111};}
		C2: coverpoint d_xtn_cov1.out {bins b1 = {8'b0000_0001};
						bins b2 = {8'b0000_0010};
						bins b3 = {8'b0000_0100};
						bins b4 = {8'b0000_1000};
						bins b5 = {8'b0001_0000};
						bins b6 = {8'b0010_0000};
						bins b7 = {8'b0100_0000};
						bins b8 = {8'b1000_0000};
						}
	endgroup

	function new(string name="d_sb",uvm_component parent);
		super.new(name,parent);
		fifo_drv = new("fifo_drv",this);
		fifo_mon = new("fifo_mon",this);
		fcov1 = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		forever
			fork
				begin
					fifo_mon.get(d_xtn1);
					d_xtn_cov1 = d_xtn1; //object assignment
					fcov1.sample();
				end
			join
	endtask

endclass
