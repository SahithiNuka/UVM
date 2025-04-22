

class uart_trans extends uvm_sequence_item;
	`uvm_object_utils(uart_trans)

	//properties
	bit wb_rst_i;
	rand bit[7:0]wb_addr_i;
	rand bit[7:0]wb_data_i;
	rand bit we_i;
	bit [7:0]wb_data_o;
	bit [3:0]wb_sel_i;
	bit wb_stb_i;
	bit wb_cyc_i;
	bit wb_ack_o;
	bit int_o;

	//registers
	bit [7:0]ier,iir,fcr,lcr,dlr_lsb,dlr_msb,msr,mcr,lsr;	
	bit [7:0] thr[$];
	bit [7:0] rb[$];

	function new(string name="uart_trans");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("wb_rst_i",this.wb_rst_i,1,UVM_BIN);
		printer.print_field("wb_addr_i",this.wb_addr_i,8,UVM_BIN);
		printer.print_field("wb_data_i",this.wb_data_i,8,UVM_BIN);
		printer.print_field("we_i",this.we_i,1,UVM_BIN);
		printer.print_field("we_sel_i",this.wb_sel_i,4,UVM_BIN);
//		printer.print_field("wb_stb_i",this.wb_stb_i,1,UVM_BIN);
//		printer.print_field("wb_cyc_i",this.wb_cyc_i,1,UVM_BIN);
//		printer.print_field("wb_data_o",this.wb_data_o,8,UVM_BIN);
//		printer.print_field("wb_ack_o",this.wb_ack_o,1,UVM_BIN);
//		printer.print_field("int_o",this.int_o,1,UVM_BIN);

		//registers
		printer.print_field("ier",this.ier,8,UVM_BIN);
		printer.print_field("iir",this.iir,8,UVM_BIN);
		printer.print_field("fcr",this.fcr,8,UVM_BIN);
		printer.print_field("lcr",this.lcr,8,UVM_BIN);
		printer.print_field("dlr_lsb",this.dlr_lsb,8,UVM_BIN);
		printer.print_field("dlr_msb",this.dlr_msb,8,UVM_BIN);
		printer.print_field("msr",this.msr,8,UVM_BIN);
		printer.print_field("mcr",this.mcr,8,UVM_BIN);
		printer.print_field("lsr",this.lsr,8,UVM_BIN);

		foreach(thr[i])
			printer.print_field("thr",this.thr[i],8,UVM_BIN);
		
		foreach(rb[i])
			printer.print_field("rb",this.rb[i],8,UVM_BIN);
		
	endfunction


endclass
