interface inf();
	logic [2:0]in;
	logic [7:0]out;
	logic en;
	
	modport MP1(input out, output in, output en);
	modport MP2(input out, input in, input en);
endinterface
