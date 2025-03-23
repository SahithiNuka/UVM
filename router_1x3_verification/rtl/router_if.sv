

interface router_if(input bit clock);
	
	logic [7:0] data_in;
	logic pkt_vld;
	logic rstn;
	logic error;
	logic busy;
	logic read_eb;
	logic [7:0]data_out;
	logic vld_out;

	clocking s_drv_cb@(posedge clock);
		default input #1 output #1;
		input busy;
		input error;
		output data_in;
		output pkt_vld;
		output rstn;
	endclocking

	clocking s_mon_cb@(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_vld;
		input error;
		input busy;
		input rstn;
	endclocking

	clocking d_drv_cb@(posedge clock);
		default input #1 output #1;
		input vld_out;
		output read_eb;
	endclocking

	clocking d_mon_cb@(posedge clock);
		default input #1 output #1;
		input data_out;
		input read_eb;
		input vld_out;
	endclocking

	modport SDRV_MP(clocking s_drv_cb);
	modport SMON_MP(clocking s_mon_cb);
	modport DDRV_MP(clocking d_drv_cb);
	modport DMON_MP(clocking d_mon_cb);

endinterface














