//  DMA Timing and Control module interface 

interface DmaControlIf(input logic CLK, RESET);    

logic hrq;
logic ldCurrAddrTemp; 
logic ldCurrWordTemp; 
logic enCurrAddr; 
logic ldTempCurrAddr; 
logic ldTempCurrWord; 
logic Program;
logic validDACK;


logic VALID_DREQ0;
logic VALID_DREQ1;
logic VALID_DREQ2;
logic VALID_DREQ3;

modport DP(
	    input CLK,
	    input RESET,
	    input VALID_DREQ0,
	    input VALID_DREQ1,
	    input VALID_DREQ2,
	    input VALID_DREQ3,
	    input ldCurrAddrTemp, 
	    input ldCurrWordTemp, 
	    input enCurrAddr,  
	    input ldTempCurrAddr, 
	    input ldTempCurrWord, 
	    input Program
);

modport TC(
	    input  CLK,
	    input  RESET,
	    input  VALID_DREQ0,
	    input  VALID_DREQ1,
	    input  VALID_DREQ2,
	    input  VALID_DREQ3,
	    output hrq,
	    output ldCurrAddrTemp, 
	    output ldCurrWordTemp, 
	    output enCurrAddr, 
	    output ldTempCurrAddr, 
	    output ldTempCurrWord, 
	    output Program,
	    output validDACK
);
modport PR(
	    input  CLK,
	    input  RESET,
	    input  hrq,
	    input  validDACK,
	    output VALID_DREQ0,
	    output VALID_DREQ1,
	    output VALID_DREQ2,
	    output VALID_DREQ3
);

endinterface
