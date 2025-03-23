

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	env_cfg e_cfg;
	s_trans s_xtn; //for analysis fifo
	d_trans d_xtn; //for analysis fifo
	
	uvm_tlm_analysis_fifo #(s_trans) fifo_src; //getting data from source monitor
	uvm_tlm_analysis_fifo #(d_trans) fifo_dest[]; //getting data from destination monitor

	bit [1:0]address;

	s_trans s_cov_data; //for covergroup
	d_trans d_cov_data; //for covergroup

	int data_verified_count;

	//covergroup for source
	covergroup router_source;
		option.per_instance = 1;
		//address
		ADDR : coverpoint s_cov_data.header[1:0] { bins h1 = {2'b00};
							   bins h2 = {2'b01};
							   bins h3 = {2'b10};}

		//data
		PAYLOAD_SIZE: coverpoint s_cov_data.header[7:2] { bins s_pkt = {[1:20]};
								  bins m_pkt = {[21:40]};
						 		  bins b_pkt = {[41:63]};}

		//bad pkt
		BAD_PKT: coverpoint s_cov_data.error {bins bad_pkt = {1'b1};
						      bins good_pkt = {1'b0};}

		ADDR_PAYLOAD_SIZE: cross ADDR,PAYLOAD_SIZE;
		ADDR_PAYLOAD_SIZE_BAD_PKT: cross ADDR,PAYLOAD_SIZE,BAD_PKT;
	endgroup

	//covergroup for destination
	covergroup router_dest;
		option.per_instance = 1;
		//address
		ADDR: coverpoint d_cov_data.header[1:0] { bins h1 = {2'b00};
							  bins h2 = {2'b01};
							  bins h3 = {2'b10};}

		//data
		PAYLOAD_SIZE: coverpoint d_cov_data.header[7:2] {bins s_pkt = {[1:20]};
								 bins m_pkt = {[21:40]};
								 bins b_pkt = {[41:63]};}

		ADDR_PAYLOAD_SIZE: cross ADDR,PAYLOAD_SIZE;
	endgroup
		
	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		router_source = new();
		router_dest = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("SCOREBOARD","Cant get env cfg")
		/*if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal("SCOREBOARD","Cant get address")
		*/
		fifo_dest = new[e_cfg.no_of_dagents];
		fifo_src = new("fifo_src",this);
		foreach(fifo_dest[i])
			begin
				fifo_dest[i] = new($sformatf("fifo_dest[%0d]",i),this);
			end
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				fork
					begin
						fifo_src.get(s_xtn);
						s_cov_data = s_xtn;
						s_xtn.print();
						router_source.sample();
					end
		
					/*begin
						fifo_dest[address].get(d_xtn);
						d_cov_data = d_xtn;
						d_xtn.print();
						router_dest.sample();
					end
				join
				compare(s_xtn,d_xtn);
			end
	endtask*/
					//without using destination address
					begin
						fork
							begin
								fifo_dest[0].get(d_xtn);
								d_cov_data = d_xtn;
								d_xtn.print();
								router_dest.sample();
							end

							begin
								fifo_dest[1].get(d_xtn);
								d_cov_data = d_xtn;
								d_xtn.print();
								router_dest.sample();
							end

							begin
								fifo_dest[2].get(d_xtn);
								d_cov_data = d_xtn;
								d_xtn.print();
								router_dest.sample();
							end
						join_any
						disable fork;
					end
				join
				compare(s_xtn,d_xtn);
			end
	endtask

	task compare(s_trans s_xtn, d_trans d_xtn);
		if(s_xtn.header == d_xtn.header)
			$display("SB_HEADER, header matches successfully");
		else
			$display("SB_HEADER, header dismatches");

		if(s_xtn.pl_data == d_xtn.pl_data)
			$display("SB_PAYLOAD, payload matches successfully");
		else
			$display("SB_{AYLOAD, payload dismatches");
		if(s_xtn.parity == d_xtn.parity)
			$display("SB_PARITY, parity matches successfully");
		else
			$display("SB_PARITY, parity dismatches");
	endtask
		
			
endclass
