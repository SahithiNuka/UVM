

class uart_seqs extends uvm_sequence #(uart_trans);
	`uvm_object_utils(uart_seqs)

	function new(string name="uart_seqs");
		super.new(name);
	endfunction
endclass


///////////////////////////////////////// full-duplex sequence 1 ///////////////////////////////////////
class full_duplex1 extends uart_seqs;
	`uvm_object_utils(full_duplex1)

	function new(string name="full_duplex1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd25;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==0; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				

////////////////////////////////////////////////////full-duplex sequence 2///////////////////////////////////////////////// 
class full_duplex2 extends uart_seqs;
	`uvm_object_utils(full_duplex2)

	function new(string name="full_duplex2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
//step1
		//line control register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		finish_item(req);

//step2
		//divisor latch register (msb)
		// divisor1 = 13 stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'd0;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd28;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==0; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


/////////////////////////////////////////////////////// half duplex 1 /////////////////////////////////////////////////////
class half_duplex1 extends uart_seqs;
	`uvm_object_utils(half_duplex1)

	function new(string name = "half_duplex1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 27 and is stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd25;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//as half duplex doesn't transmit and receive data simultaneously so seq1 doesn't have receiver logic and seq2 doesn't have transmitter logic
	endtask
endclass

/////////////////////////////////////////////////////// half duplex2 ////////////////////////////////////////
class half_duplex2 extends uart_seqs;
	`uvm_object_utils(half_duplex2)

	function new(string name = "half_duplex2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7 
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 8
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==0; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


//////////////////////////////////////////////// loop back seq 1 ////////////////////////////////////////////////////
class loop_back1 extends uart_seqs;
	`uvm_object_utils(loop_back1)

	function new(string name = "loop_back1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 326 and its binary is 0000_0001_0110_0110 msb is stored in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'b0100_0110;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

	//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);


	//step 6
		//writing mcr[4]==1, it enables loop back mode
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 4; we_i == 1; wb_data_i == 8'b0001_0000;});
		finish_item(req);

	//step 7
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

	//step 8
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd20;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	
	//step 9
		
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==0; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass

/////////////////////////////////////////////////////// loop back seq 2 ////////////////////////////////////////////
class loop_back2 extends uart_seqs;
	`uvm_object_utils(loop_back2)

	function new(string name = "loop_back2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 163 and its binary is 0000_0000_1010_0011 msb is stoed in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'b1010_0011;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

	//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);


	//step 6
		//writing mcr[4]==1, it enables loop back mode
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 4; we_i == 1; wb_data_i == 8'b0001_0000;});
		finish_item(req);

	//step 7
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

	//step 8
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd15;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	
	//step 9
		
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==0; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


///////////////////////////////////////////////////// partity error seq 1 ////////////////////////////////////////////
class parity_seq1 extends uart_seqs;
	`uvm_object_utils(parity_seq1)

	function new(string name="parity_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//lcr[7]==0, and for enabling parity lcr[3]==1, and lcr[4]==1 for even parity and lcr[4]==0 for odd parity, here we use even parity 
		//lcr == 8'b0001_1011
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0001_1011;}); 
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 5
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

	//step 6
		//writing into ier
		//making ier[2]==1, enabling the receiver line status interrupt
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

	//step 7	
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd24;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 8	
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10		
		if(req.iir[3:1] == 3'b011)	// means there is an parity error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==5; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass

//////////////////////////////////////////////////////// partity error seq 2 /////////////////////////////////////////
class parity_seq2 extends uart_seqs;
	`uvm_object_utils(parity_seq2)

	function new(string name="parity_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//lcr[7]==0, and for enabling parity lcr[3]==1, and lcr[4]==1 for even parity and lcr[4]==0 for odd parity, here we use even parity 
		//lcr == 8'b0001_1011
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_1011;}); 
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 5
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

	//step 6
		//writing into ier
		//making ier[2]==1, enabling the receiver line status interrupt
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

	//step 7	
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd30;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 8	
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
		if(req.iir[3:1] == 3'b011)	// means there is an parity error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i==5; we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


//////////////////////////////////////////////framing error sequence 1 ///////////////////////////////////////
class framing_seq1 extends uart_seqs;
	`uvm_object_utils(framing_seq1)

	function new(string name="framing_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 5-bits soo the lcr[1:0] == 00
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);

//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd40;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
		if(req.iir[3:1] == 3'b010)	//means there is data available in receiver buffer
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
//step 10
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				

//////////////////////////////////////////////// framing error sequence 2 //////////////////////////////
class framing_seq2 extends uart_seqs;
	`uvm_object_utils(framing_seq2)

	function new(string name="framing_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0100_0001;});
		finish_item(req);

	//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

	//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

	//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd36;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 9		
		if(req.iir[3:1] == 3'b010)	//means there is data available in receiver buffer
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end

	//step 10
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				


////////////////////////////////////////////////// overrun errot sequence 1 ///////////////////////////////////////
class overrun_seq1 extends uart_seqs;
	`uvm_object_utils(overrun_seq1)

	function new(string name="overrun_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) and repeating it for more than 16 times which creates an overrun i.e., rb gets overflowed
		repeat(18)
			begin 
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 1;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

/////////////////////////////////////////////////////overrun errot sequence 2 //////////////////////////////////
class overrun_seq2 extends uart_seqs;
	`uvm_object_utils(overrun_seq2)

	function new(string name="overrun_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) and repeating it for more than 16 times which creates an overrun i.e., rb gets overflowed
		repeat(18)
			begin 
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 1;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				

		
//////////////////////////////////////////////////// break inetrrupt error sequence 1 ////////////////////////////////////////
class break_int_seq1 extends uart_seqs;
	`uvm_object_utils(break_int_seq1)

	function new(string name="break_int_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11 and lcr[6] == 1 this will break the communication and the thr will transmits all 0's
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0100_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd65;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

////////////////////////////////////////////////////////// break interrupt error sequence 2 //////////////////////////
class break_int_seq2 extends uart_seqs;
	`uvm_object_utils(break_int_seq2)

	function new(string name="break_int_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11 and lcr[6] == 1 this will break the communication and the thr will transmits all 0's
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0100_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) 			 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd50;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		


//////////////////////////////////////////////// timeout error sequence 1 /////////////////////////////////
class timeout_seq1 extends uart_seqs;
	`uvm_object_utils(timeout_seq1)

	function new(string name="timeout_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr and the reciever fifo interrupt triggers after it reveives 1 byte i.e., fcr[7:6] == 00
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2:0] == 101	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd20;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b110)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

//////////////////////////////////////////////// timeout error sequence 2 /////////////////////////////////
class timeout_seq2 extends uart_seqs;
	`uvm_object_utils(timeout_seq2)

	function new(string name="timeout_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr and the reciever fifo interrupt triggers after it reveives 4 bytes i.e., fcr[7:6] == 01
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0100_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2:0] == 101	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd24;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b110)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 0; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		


//////////////////////////////////////////////// ThrEMpty sequence 1 /////////////////////////////////
class thrempty_seq1 extends uart_seqs;
	`uvm_object_utils(thrempty_seq1)

	function new(string name="thrempty_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0010;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd40;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b001)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

//////////////////////////////////////////////// ThrEMpty sequence 1 /////////////////////////////////
class thrempty_seq2 extends uart_seqs;
	`uvm_object_utils(thrempty_seq2)

	function new(string name="thrempty_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_trans::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 3; we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 1; we_i == 1; wb_data_i == 8'b0000_0010;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 0; we_i == 1; wb_data_i == 8'd40;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_addr_i == 2; we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b001)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_addr_i == 5; we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		
