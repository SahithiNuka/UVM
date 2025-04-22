

class uart_sb extends uvm_scoreboard;
	`uvm_component_utils(uart_sb)

	env_cfg e_cfg;
	uart_trans u_xtn1, u_xtn2, uart1_cov;

	uvm_tlm_analysis_fifo #(uart_trans)fifo[];

	int thr1size, thr2size;
	int rb1size, rb2size;

	covergroup uart_signals_cov;
		option.per_instance = 1;
		DATA: coverpoint uart1_cov.wb_data_i[7:0] { bins wb_data_i = {[0:255]};}
		ADDRESS: coverpoint uart1_cov.wb_addr_i[2:0] {bins wb_addr_i = {[0:7]};}
		WE_ENB: coverpoint uart1_cov.we_i {bins rd = {0};
							bins wr = {1};}
	endgroup

	covergroup uart_lcr_cov;
		option.per_instance = 1;
		NO_OF_BITS: coverpoint uart1_cov.lcr[1:0] { bins five = {2'b00};
							    bins six = {2'b01};
							    bins seven = {2'b10};
							    bins eight = {2'b11};}

		STOP_BIT: coverpoint uart1_cov.lcr[2] { bins one = {1'b0};
							bins more = {1'b1};
							}
 
		PARITY: coverpoint uart1_cov.lcr[3] { bins no_parity = {1'b0};
							bins parity_en = {1'b1};
							}

		EVEN_ODD_PARITY: coverpoint uart1_cov.lcr[4] { bins odd_parity = {1'b0};
								bins even_parity = {1'b1};
								}

		STICK_PARITY: coverpoint uart1_cov.lcr[5] {bins no_stick_parity = {1'b0};
								bins stick_parity = {1'b1}; 
								}

		BREAK: coverpoint uart1_cov.lcr[6] {bins low = {1'b0};
							bins high = {1'b1};
							}
		
		DIV_LATCH: coverpoint uart1_cov.lcr[7] {bins low = {1'b0};
							bins high = {1'b1};
							}
		
		NO_OF_BITS_X_STOP_BIT_X_EVEN_ODD_PARITY: cross NO_OF_BITS,STOP_BIT,EVEN_ODD_PARITY;
	endgroup

	covergroup uart_ier_cov;
		option.per_instance = 1;
		RCVD_INT: coverpoint uart1_cov.ier[0] {bins dis = {1'b0};
							bins en = {1'b1};}

		THRE_INT: coverpoint uart1_cov.ier[1] {bins dis = {1'b0};
							bins en = {1'b1};}

		LSR_INT: coverpoint uart1_cov.ier[2] {bins dis = {1'b0};
							bins en = {1'b1};}
	endgroup

	covergroup uart_fcr_cov;
		option.per_instance = 1;
		RFIFO: coverpoint uart1_cov.fcr[1] {bins dis = {1'b0};
							bins clr = {1'b1};}
		TFIFO: coverpoint uart1_cov.fcr[2] {bins dis = {1'b0};
							bins clr = {1'b1};}

		TRIGGER_LEVEL: coverpoint uart1_cov.fcr[7:6] {bins one = {2'b00};
								bins four = {2'b01};
								bins eight = {2'b10};
								bins fourteen = {2'b11};
								}
	endgroup

	covergroup uart_mcr_cov;
		option.per_instance = 1;
		LOOP_BACK: coverpoint uart1_cov.mcr[4] {bins dis = {1'b0};
							bins en = {1'b1};}
	endgroup

	covergroup uart_iir_cov;
		option.per_instance = 1;
		IIR: coverpoint uart1_cov.iir[3:1] {bins lsr = {3'b011};
							bins rd = {3'b010};
							bins ti_o = {3'b110};
							bins threm = {3'b001};
							}
	endgroup

	covergroup uart_lsr_cov;
		option.per_instance = 1;
		DATA_READY: coverpoint uart1_cov.lsr[0] {bins fifoempty = {1'b0};
							bins datarvd = {1'b1};}
	
		OVER_RUN: coverpoint uart1_cov.lsr[1] {bins no_overrun = {1'b0};
							bins overrun = {1'b1};}
	
		PARITY_ERROR: coverpoint uart1_cov.lsr[2] {bins no_parity_err = {1'b0};
							bins parity_err = {1'b1};}

		FRAMING_ERROR: coverpoint uart1_cov.lsr[3] {bins no_framing_err = {1'b0};
							bins framing_err = {1'b1};}

		BREAK_INT: coverpoint uart1_cov.lsr[4] {bins no_break_int = {1'b0};
							bins break_int = {1'b1};}

		THR_EMP: coverpoint uart1_cov.lsr[5] {bins no_thr_emp = {1'b0};
							bins thr_emp = {1'b1};}

	endgroup


	function new(string name="uart_sb",uvm_component parent);
		super.new(name,parent);
		uart_signals_cov = new();
		uart_lcr_cov = new();
		uart_ier_cov = new();
		uart_fcr_cov = new();
		uart_mcr_cov = new();
		uart_iir_cov = new();
		uart_lsr_cov = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal("SCOREBOARD","Can't get env_cfg")
		fifo = new[e_cfg.no_of_agents];
		foreach(fifo[i])
			begin
				fifo[i] = new($sformatf("fifo[%0d]",i),this);
			end
	endfunction

	task run_phase(uvm_phase phase);
		fork
			forever
				begin
					fifo[0].get(u_xtn1);
					`uvm_info("SCOREBOARD",$formatf("printing from scoreboard of UART1 \n %s",u_xtn1.sprint()),UVM_LOW)
					uart1_cov = u_xtn1;
					uart_signals_cov.sample();
					uart_lcr_cov.sample();			
					uart_ier_cov.sample();			
					uart_fcr_cov.sample();			
					uart_mcr_cov.sample();			
					uart_iir_cov.sample();			
					uart_lsr_cov.sample();			
				end
			forever
				begin
					fifo[1].get(u_xtn2);
					`uvm_info("SCOREBOARD",$formatf("printing from scoreboard of UART2 \n %s",u_xtn2.sprint()),UVM_LOW)
					uart1_cov = u_xtn2;
					uart_signals_cov.sample();
					uart_lcr_cov.sample();			
					uart_ier_cov.sample();			
					uart_fcr_cov.sample();			
					uart_mcr_cov.sample();			
					uart_iir_cov.sample();			
					uart_lsr_cov.sample();			
		
				end	
		join
	endtask
	

	function void check_phase(uvm_phase phase);
//		super.check_phase(phase);
		thr1size = u_xtn1.thr.size();
		rb1size = u_xtn1.rb.size();
		thr2size = u_xtn2.thr.size();
		rb2size = u_xtn2.rb.size();
/*
	//full duplex
		if(thr1size != 0 && thr2size != 0 && u_xtn1.thr == u_xtn2.rb && u_xtn2.thr == u_xtn1.rb)
			`uvm_info(get_type_name(), $sformatf("\n Full duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)


	//half duplex
		else if(thr1size != 0 && thr2size == 0 && u_xtn1.thr == u_xtn2.rb)
			`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)

	
	//loop back
		else if(thr1size != 0 && thr2size != 0 && u_xtn1.mcr[4] == 1 && u_xtn2.mcr[4] == 1 && u_xtn1.thr == u_xtn1.rb && u_xtn2.thr == u_xtn2.rb)	
			`uvm_info(get_type_name(), $sformatf("\n Loop Back test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)


	//parity error
		else if(u_xtn1.lcr[3] == 1 && u_xtn2.lcr[3] == 1 && u_xtn1.ier[2] == 1 && u_xtn2.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn2.iir[3:1] == 3 && u_xtn1.lsr[2] == 1 && u_xtn2.lsr[2] == 1)	
			`uvm_info(get_type_name(), $sformatf("\n Parity Error test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
	
	//framing error
		else if(u_xtn1.ier[2] == 1 && u_xtn2.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn2.iir[3:1] == 3 && u_xtn1.lsr[3] == 1 && u_xtn2.lsr[3] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
			
	//overrun error 
		else if(u_xtn1.ier[2] == 1 && u_xtn2.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn2.iir[3:1] == 3 && u_xtn1.lsr[1] == 1 && u_xtn2.lsr[1] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)

	//break interrupt error
		else if(u_xtn1.lcr[6] == 1 && u_xtn2.lcr[6] == 1 && u_xtn1.ier[2] == 1 && u_xtn2.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn2.iir[3:1] == 3 && u_xtn1.lsr[4] == 1 && u_xtn2.lsr[4] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt Error test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
	
	//timeout error
		else if(u_xtn1.fcr[7:6] != u_xtn2.fcr[7:6])
			begin
				if(u_xtn1.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 1: \n %s",u_xtn1.sprint()),UVM_LOW)	
				if(u_xtn2.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 2: \n %s",u_xtn2.sprint()),UVM_LOW)
			end

	//thrempty error
		else if(u_xtn1.ier[1] == 1 && u_xtn2.ier[1] == 1 && u_xtn1.iir[3:1] == 1 && u_xtn2.iir[3:1] == 1 && u_xtn1.lsr[5] == 1 && u_xtn2.lsr[5] == 1)
			`uvm_info(get_type_name(), $sformatf("\n ThrEMpty test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
			
	//data mismatch
		else if(thr1size != 0 && thr2size != 0 && u_xtn1.thr != u_xtn2.rb && u_xtn2.thr != u_xtn1.rb)
			`uvm_info(get_type_name(), $sformatf("\n test failed \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)


		else
			`uvm_info(get_type_name(), $sformatf("\n no data found   \n from sb uart1: \n%s \n from sb uart2: \n%s", u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
*/
		$display("size of thr1 = %p \n",thr1size);
		$display("size of thr2 = %p \n",thr2size);
		$display("size of rb1 = %p \n",rb1size);
		$display("size of rb2 = %p \n",rb2size);
		$display("values sent by uart1 = %p \n",u_xtn1.thr);
		$display("values sent by uart2 = %p \n",u_xtn2.thr);
		$display("values received by uart1 = %p \n",u_xtn1.rb);
		$display("values received by uart2 = %p \n",u_xtn2.rb);
		
		//FULL DUPLEX
		if(thr1size != 0 && thr2size != 0 && u_xtn1.thr == u_xtn2.rb && u_xtn2.thr == u_xtn1.rb)
			`uvm_info(get_type_name(), $sformatf("\n Full duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
		else
			$display("Full duplex is failed \n");

	
		//HALF DUPLEX
		if((thr1size != 0) && (thr2size == 0))
			begin
				if(u_xtn1.thr == u_xtn2.rb)
					`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",u_xtn1.sprint(),u_xtn2.sprint()),UVM_LOW)
				else
					$display("Half duplex failed \n");
			end
	
		if((thr1size == 0) && (thr2size != 0))
			begin
				if(u_xtn2.thr == u_xtn1.rb)
					`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart2:\n %s \n from sb uart2:\n %s",u_xtn2.sprint(),u_xtn1.sprint()),UVM_LOW)
				else
					$display("Half duplex failed \n");
			end

		//LOOPBACK
		if(u_xtn1.mcr[4] == 1)
			begin
				if(thr1size != 0)
					begin
						if(u_xtn1.thr == u_xtn1.rb)
							`uvm_info(get_type_name(), $sformatf("\n Loopback in UART1 is successful:\n %s",u_xtn1.sprint()),UVM_LOW)
						else
							$display("Loopback in UART1 failed");
					end
			end							
	
		if(u_xtn2.mcr[4] == 1)
			begin
				if(thr2size != 0)
					begin
						if(u_xtn2.thr == u_xtn2.rb)
							`uvm_info(get_type_name(), $sformatf("\n Loopback in UART2 is successful:\n %s",u_xtn2.sprint()),UVM_LOW)
						else
							$display("Loopback in UART2 failed");
					end
			end							

	
		//PARITY ERROR
		if(u_xtn1.lcr[3] == 1 && u_xtn1.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn1.lsr[2] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Parity Error in UART 1:\n %s",u_xtn1.sprint()),UVM_LOW)
			
		if(u_xtn2.lcr[3] == 1 && u_xtn2.ier[2] == 1 && u_xtn2.iir[3:1] == 3 && u_xtn2.lsr[2] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Parity Error in UART 2:\n %s",u_xtn2.sprint()),UVM_LOW)


		//FRAMING ERROR
		
		if(u_xtn1.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn1.lsr[3] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error in UART 1:\n %s",u_xtn1.sprint()),UVM_LOW)

		if(u_xtn2.ier[2] == 1 && u_xtn2.iir[3:1] == 3 && u_xtn2.lsr[3] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error in UART 2:\n %s",u_xtn2.sprint()),UVM_LOW)

	
		//OVERRUN ERROR
		if(u_xtn1.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn1.lsr[1] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error in UART 1:\n %s",u_xtn1.sprint()),UVM_LOW)

		if(u_xtn2.ier[2] == 1 && u_xtn2.iir[3:1] == 3 && u_xtn2.lsr[1] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error in UART 2:\n %s",u_xtn2.sprint()),UVM_LOW)
	

		//BREAK INTERRUPT
		if(u_xtn1.lcr[6] == 1 && u_xtn1.ier[2] == 1 && u_xtn1.iir[3:1] == 3 && u_xtn1.lsr[4] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt in UART 1:\n %s",u_xtn1.sprint()),UVM_LOW)
			
		if(u_xtn2.lcr[6] == 1 && u_xtn2.ier[2] == 1 && u_xtn2.iir[3:1] == 3 && u_xtn2.lsr[4] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt in UART 2:\n %s",u_xtn2.sprint()),UVM_LOW)

		
		//TIMEOUT
		if(u_xtn1.fcr[7:6] != u_xtn2.fcr[7:6])
			begin
				if(u_xtn1.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 1: \n %s",u_xtn1.sprint()),UVM_LOW)	
				if(u_xtn2.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 2: \n %s",u_xtn2.sprint()),UVM_LOW)
			end
		

		//THREMPTY
		if(u_xtn1.ier[1] == 1 && u_xtn1.iir[3:1] == 1 && u_xtn1.lsr[5] == 1)
			`uvm_info(get_type_name(), $sformatf("\n THR empty in UART 1:\n %s",u_xtn1.sprint()),UVM_LOW)

		if(u_xtn2.ier[1] == 1 && u_xtn2.iir[3:1] == 1 && u_xtn2.lsr[5] == 1)
			`uvm_info(get_type_name(), $sformatf("\n THR Empty in UART 2:\n %s",u_xtn2.sprint()),UVM_LOW)
		
	endfunction

endclass
