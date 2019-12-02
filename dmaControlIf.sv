interface dmaControlIf(input logic CLK, RESET);
	
// Datapath Buffers
logic [3:0] ioAddrBuf;      
logic [3:0] outAddrBuf;      
logic [7:0] ioDataBuf;      

// FSM control outputs
logic eop;		//@Janisha: FSM output in S1-S4 state
logic aen;		//@Janisha: FSM output in S1 state
logic adstb;		//@Janisha: FSM output in S1 state
logic ior;		//@Janisha: FSM output in S1-S4 state
logic iow;		//@Janisha: FSM output in S1-S4 state
logic hrq;
logic validDACK;
logic writeExtend;
logic checkWriteExtend;
logic checkEOP;
logic checkReadWrite;

logic ldCurrAddrTemp; 
logic ldCurrWordTemp; 
logic enCurrAddr; 
logic enCurrWord; 
logic ldtempCurrAddr; 
logic ldtempCurrWord; 
logic Program; 


//modport DATAPATH(
//		inout ioAddrBuf,
//		inout ioDataBuf,
//		output outAddrBuf
//);
//
//modport REG(
//		inout ioAddrBuf,
//		inout ioDataBuf,
//		output outAddrBuf
//);

endinterface
