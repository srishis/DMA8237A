interface dmaRegIf(input logic CLK ,RESET);

logic [15:0] currAddrReg[4];
logic [15:0] currWordReg[4];
logic [15:0] baseAddrReg[4];
logic [15:0] baseWordReg[4];
logic [5:0]  modeReg[4];
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
		output [15:0] currAddrReg[4],
		output [15:0] currWordReg[4],
		output [15:0] baseAddrReg[4],
		output [15:0] baseWordReg[4],
		output [5:0]  modeReg[4],
		output [7:0]  commandReg,
		output [7:0]  requestReg,
		output [7:0]  maskReg,
		output [7:0]  tempReg,
		output [7:0]  statusReg	
	);

endinterface
