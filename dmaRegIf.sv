interface dmaRegIf(input logic CLK ,RESET);

logic [15:0] currAddrReg[0];
logic [15:0] currAddrReg[1];
logic [15:0] currAddrReg[2];
logic [15:0] currAddrReg[3];
logic [15:0] currWordReg[0];
logic [15:0] currWordReg[1];
logic [15:0] currWordReg[2];
logic [15:0] currWordReg[3];
logic [15:0] baseAddrReg[0];
logic [15:0] baseAddrReg[1];
logic [15:0] baseAddrReg[2];
logic [15:0] baseAddrReg[3];
logic [15:0] baseWordReg[0];
logic [15:0] baseWordReg[1];
logic [15:0] baseWordReg[2];
logic [15:0] baseWordReg[3];
logic [7:0]  modeReg[0];
logic [7:0]  modeReg[1];
logic [7:0]  modeReg[2];
logic [7:0]  modeReg[3];
logic [7:0]  commandReg;
logic [7:0]  requestReg;
logic [7:0]  maskReg;
logic [7:0]  tempReg;
logic [7:0]  statusReg;

modport PRIORITY(
		input commandReg,
		input requestReg,
		input maskReg	
	);

modport FSM(
		input commandReg,
		input modeReg,
		input statusReg	
	);

modport REG(
		output [15:0] currAddrReg[0];
		output [15:0] currAddrReg[1];
		output [15:0] currAddrReg[2];
		output [15:0] currAddrReg[3];
		output [15:0] currWordReg[0];
		output [15:0] currWordReg[1];
		output [15:0] currWordReg[2];
		output [15:0] currWordReg[3];
		output [15:0] baseAddrReg[0];
		output [15:0] baseAddrReg[1];
		output [15:0] baseAddrReg[2];
		output [15:0] baseAddrReg[3];
		output [15:0] baseWordReg[0];
		output [15:0] baseWordReg[1];
		output [15:0] baseWordReg[2];
		output [15:0] baseWordReg[3];
		output [5:0]  modeReg[0];
		output [5:0]  modeReg[1];
		output [5:0]  modeReg[2];
		output [5:0]  modeReg[3];
		output [7:0]  commandReg;
		output [7:0]  requestReg;
		output [7:0]  maskReg;
		output [7:0]  tempReg;
		output [7:0]  statusReg;	
	);

endinterface
