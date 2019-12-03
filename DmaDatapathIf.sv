interface DmaDatapathIf(input logic CLK ,RESET);

// Datapath Buffers
logic [7:0] ioDataBuf;
logic [3:0] ioAddrBuf;
logic [3:0] outAddrBuf;

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
		output  currAddrReg,
		output  currWordReg,
		output  baseAddrReg,
		output  baseWordReg,
		output  modeReg,
		output  commandReg,
		output  requestReg,
		output  maskReg,
		output  tempReg,
		output  statusReg,
		inout   ioDataBuf,
		inout   ioAddrBuf,
		output  outAddrBuf
	);

modport DATAPATH(
		inout ioDataBuf,
		inout ioAddrBuf,
		output outAddrBuf
);

endinterface
