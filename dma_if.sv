
interface dma_if(input logic CLK, input logic RESET);

	/* interface to 8086 processor */
	logic 	    MEMR_N;   	// memory read
	logic 	    MEMW_N;		// memory write
	wire 	    IOR_N;		// IO read
	wire 	    IOW_N;		// IO write
	logic 	    HLDA;		// Hold acknowledge from CPU to indicate it has relinquished bus control
	logic 	    HRQ;		// Hold request from DMA to CPU for bus control

	/* address and data bus interface */
	logic [3:0] ADDR_U;		// upper address which connects to address A7-A4 of 8086 CPU
	wire  [3:0] ADDR_L;		// lower address which connects to address A3-A0 of 8086 CPU
	wire  [7:0] DB;			// data
	logic       CS_N; 		// Chip select
	logic       AEN;		// address enable

	/* Request and Acknowledge interface */
	logic  [3:0] DREQ;		// asynchronous DMA channel request lines
	logic  [3:0] DACK;		// DMA acknowledge lines to indicate access granted to peripheral who has raised a request

	/* interface signal to 8-bit Latch */
	logic       ADSTB;		// Address strobe

	/* EOP signal */
	wire 	    EOP_N;		// bi-directional signal to end DMA active transfers
	
	// modport for design top
	modport DUT(
			input  CLK,
			input  RESET,
			inout  IOR_N,
			inout  IOW_N,
			inout  DB,
			inout  ADDR_L,

			inout  EOP_N,

			input  DREQ,
			input  HLDA,
			input  CS_N,

			output ADDR_U,
			output DACK,
			output HRQ,
			output AEN,
			output ADSTB
	       	);

	// modport for Datapath
	modport DP(
			input  CLK,
			input  RESET,
			input  IOR_N,
			input  IOW_N,
			input  HLDA,		
			input  CS_N,
			inout  DB,
			inout  ADDR_L,
			output ADDR_U		
	);
	
	// modport for Priority logic
	modport PR(
			input  CLK,
			input  RESET,
			output DACK,
			output HRQ,	
			input  DREQ,
			input  HLDA		
	);
	
	// modport for Timing Control logic
	modport TC(
			input   CLK,
			input   RESET,
			input   HLDA,
		   	output  IOR_N,
			output  IOW_N,
			output 	MEMR_N,	
			output 	MEMW_N,		
			input   CS_N,
			inout   EOP_N,
			output  AEN,
			output  ADSTB
	);
	
	/* Modport for Test Bench */
	modport TB(clocking cb);
	
	/* Clocking Block to drive stimulus at cycle level */
	clocking cb @(posedge CLK);
			
			default input #0 output #0;
			
			inout  	IOR_N;
			inout  	IOW_N;
			inout   DB;
			inout  	ADDR_L;
			inout  	EOP_N;
			output  DREQ;
			output  HLDA;
			output	CS_N;
			input 	ADDR_U;
			input 	MEMR_N;
			input 	MEMW_N;
			input 	DACK;
			input 	HRQ;
			input 	AEN;
			input 	ADSTB;
			
	endclocking

endinterface
