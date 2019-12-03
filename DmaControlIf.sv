interface DmaControlIf(input logic CLK, RESET);

// FSM control outputs
logic eop;		//@Janisha: FSM output in S1-S4 state
logic aen;		//@Janisha: FSM output in S1 state
logic adstb;		//@Janisha: FSM output in S1 state
logic ior;		//@Janisha: FSM output in S1-S4 state
logic iow;		//@Janisha: FSM output in S1-S4 state
logic hrq;
logic validDACK;
//logic writeExtend;
logic checkWriteExtend;
logic checkEOP;
logic checkRead;
logic checkWrite;

logic ldCurrAddrTemp; 
logic ldCurrWordTemp; 
logic enCurrAddr; 
//logic enCurrWord; 
logic ldTempCurrAddr; 
logic ldTempCurrWord; 
logic Program; 
logic TC[4];

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
logic IDLE_CYCLE;	       
logic ACTIVE_CYCLE;	 	
logic DREQ0_ACTIVE_HIGH; 
logic DREQ1_ACTIVE_HIGH; 
logic DREQ2_ACTIVE_HIGH; 
logic DREQ3_ACTIVE_HIGH; 
logic DACK0_ACTIVE_HIGH; 
logic DACK1_ACTIVE_HIGH; 
logic DACK2_ACTIVE_HIGH; 
logic DACK3_ACTIVE_HIGH; 
logic DREQ0_ACTIVE_LOW;
logic DREQ1_ACTIVE_LOW;
logic DREQ2_ACTIVE_LOW;
logic DREQ3_ACTIVE_LOW;
logic DACK0_ACTIVE_LOW;
logic DACK1_ACTIVE_LOW;
logic DACK2_ACTIVE_LOW;
logic DACK3_ACTIVE_LOW;
logic CH0_SEL; 
logic CH1_SEL;
logic CH2_SEL;
logic CH3_SEL;
logic CH0_MASK;
logic CH1_MASK;
logic CH2_MASK;
logic CH3_MASK;
logic VALID_DREQ0;
logic VALID_DREQ1;
logic VALID_DREQ2;
logic VALID_DREQ3;
logic VALID_DACK0;
logic VALID_DACK1;
logic VALID_DACK2;
logic VALID_DACK3;
logic CH0_PRIORITY; 
logic CH1_PRIORITY;  
logic CH2_PRIORITY; 
logic CH3_PRIORITY; 
logic NEXT_CH0_PRIORITY;
logic NEXT_CH1_PRIORITY;
logic NEXT_CH2_PRIORITY;
logic NEXT_CH3_PRIORITY; 

endinterface
