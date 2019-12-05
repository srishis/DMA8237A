interface DmaRegIf(input logic CLK, RESET);

// DMA Registers
 logic [5:0]  modeReg[4];
 logic [7:0]  commandReg;
 logic [7:0]  requestReg;
 logic [7:0]  maskReg;
 logic [7:0]  statusReg;


modport DP(
 input  CLK,
 input  RESET,	
 output modeReg,
 output commandReg,
 output requestReg,
 output maskReg,
 output statusReg

);

modport TC(
 input  CLK,
 input  RESET,
 input modeReg,
 input commandReg,
 input statusReg
);

modport PR(
 input  CLK,
 input  RESET,
 input commandReg,
 input requestReg,
 input maskReg
);

endinterface
