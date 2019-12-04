interface DmaRegIf(input logic CLK, RESET);

// DMA Registers
 logic [5:0]  modeReg[4];
 logic [7:0]  commandReg;
 logic [7:0]  requestReg;
 logic [7:0]  maskReg;
 logic [7:0]  statusReg;


modport DP(
	
 output modeReg,
 output commandReg,
 output requestReg,
 output maskReg,
 output statusReg

);

modport TC(
 input modeReg,
 input commandReg,
 input statusReg
);

modport PR(
 input commandReg,
 input requestReg,
 input maskReg
)

endinterface
