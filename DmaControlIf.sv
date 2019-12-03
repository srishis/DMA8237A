interface DmaControlIf(input logic CLK, RESET);
	
// Datapath Buffers
logic [3:0] ioAddrBuf;      
logic [3:0] outAddrBuf;      
logic [7:0] ioDataBuf;      

// FSM control outputs
logic eop;		
logic aen;		
logic adstb;		
logic ior;		
logic iow;		
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
logic [1:0] CH0_PRIORITY; 
logic [1:0] CH1_PRIORITY;  
logic [1:0] CH2_PRIORITY; 
logic [1:0] CH3_PRIORITY; 
logic [1:0] NEXT_CH0_PRIORITY;
logic [1:0] NEXT_CH1_PRIORITY;
logic [1:0] NEXT_CH2_PRIORITY;
logic [1:0] NEXT_CH3_PRIORITY; 

endinterface
