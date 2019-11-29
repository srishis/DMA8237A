interface dmaControlIf(input logic CLK, RESET);
	
logic [7:0] ioAddrBuf;      
logic [7:0] writeDataBuf;
logic [7:0] readDataBuf;
//logic [3:0] addrUp;
//logic [3:0] addrLow;

// @Janisha: outputs from timing control logic
logic enIoAddrBuf;      // @Janisha: FSM output in state SI 
logic enRegAddr;        // @Janisha: FSM output in state SI
logic enIoDataBuf;      // @Janisha: FSM output in state SI
logic enAddrUp;         // @Janisha: FSM output in state SI
logic enAddrLow;        // @Janisha: FSM output in state SI
//logic enAddrOut;        // @Janisha: FSM output in state for final output 

logic enMemRead;	// @Janisha: FSM output for memory to memory transfers
logic enMemWrite;	// @Janisha: FSM output for memory to memory transfers

logic enIoRead;	        // @Janisha: FSM output for IO transfers 
logic enIoWrite;	// @Janisha: FSM output for IO transfers 

endinterface
