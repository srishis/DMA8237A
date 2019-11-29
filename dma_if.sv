
interface dma_if(input logic CLK, RESET)

	// interface to 8086 processor
	logic 	    MEMR_N;   		// memory read
	logic 	    MEMW_N;		// memory write
	wire 	    IOR_N;		// IO read
	wire 	    IOW_N;		// IO write
	logic 	    HLDA;		// Hold acknowledge from CPU to indicate it has relinquished bus control
	logic 	    HRQ;		// Hold request from DMA to CPU for bus control

	// address and data bus interface
	logic [3:0] ADDR_U;		// upper address which connects to address A7-A4 of 8086 CPU
	wire  [3:0] ADDR_L;		// lower address which connects to address A3-A0 of 8086 CPU
	wire  [7:0] DB;			// data
	logic       CS_N; 		// Chip select 
	logic       AEN;		// address enable

	// Request and Acknowledge interface
	logic [3:0] DREQ;		// asynchronous DMA channel request lines
	logic [3:0] DACK;		// DMA acknowledge lines to indicate access granted to peripheral who has raised a request

	// interface signal to 8-bit Latch
	logic       ADSTB;		// Address strobe

	// EOP signal
	wire 	    EOP;		// bi-directional signal to end DMA active transfers


	// modport for design
	modport DUT(
			inout  IOR_N,
			inout  IOW_N,
			inout  DB,
			inout  ADDR_L,

			inout  EOP,

			input  DREQ,
			input  HLDA,
			input  CS_N,

			output ADDR_U,
			output MEMR_N,
			output MEMW_N,
			output DACK,
			output HRQ,
			output AEN,
			output ADSTB
	       	);

	// TODO: modport for TB and other TB components (if any)
	modport TB();

	// TODO: clocking block
	clocking cb @(posedge CLK)


	endclocking

	// TODO: tasks (if any)

	// TODO: assertions (either put here or make separate module)

endinterface

