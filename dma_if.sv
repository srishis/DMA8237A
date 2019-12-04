
interface dma_if(input logic CLK, RESET);

	// interface to 8086 processor
	wire 	    IOR_N;		// IO read
	wire 	    IOW_N;		// IO write
	logic 	    HLDA;		// Hold acknowledge from CPU to indicate it has relinquished bus control
	logic 	    HRQ;		// Hold request from DMA to CPU for bus control

	// address and data bus interface
	logic [3:0] ADDR_U;		// upper address which connects to address A7-A4 of 8086 CPU
	wire  [3:0] ADDR_L;		// lower address which connects to address A3-A0 of 8086 CPU
	wire  [7:0] DB;			// data
	logic       CS_N; 		// Chip select 
	

	// Request and Acknowledge interface
	logic [3:0] DREQ;		// asynchronous DMA channel request lines
	logic [3:0] DACK;		// DMA acknowledge lines to indicate access granted to peripheral who has raised a request

	// interface signal to 8-bit Latch
	logic       ADSTB;		// Address strobe
	logic       AEN;		// address enable
	
	// EOP signal
	wire 	    EOP_N;		// bi-directional signal to end DMA active transfers


	// modport for design
	modport DUT(
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
			inout  IOR_N,
			inout  IOW_N,
			inout  DB,
			inout  ADDR_L,
			inout  EOP_N,
			output ADDR_U,
			output AEN,
			output ADSTB
	);
	
	// modport for Priority logic
	modport PR(
			output DACK,
			output HRQ,	
			input  DREQ,
			input  HLDA		
	);
	
	// modport for Timing Control logic
	modport TC(
			input  HLDA,
			input  CS_N,
			inout EOP_N
	);
	
	modport REG(
			inout  IOR_N,
			inout  IOW_N,
			input  CS_N
	);


endinterface

