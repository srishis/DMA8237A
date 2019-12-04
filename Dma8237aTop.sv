// DMA Top module

module Dma8237aTop(dma_if dif, input logic CLK, input logic RESET);


// DMA interface instantiation
DmaControlIf cif(CLK, RESET);
DmaRegIf rif(CLK, RESET);

// DMA modules instantiation
// Datapath module
DmaDatapath D1(
		dif.DP, 
		cif.DP, 
		rif.DP
);
	
	
// Timing and Control module
DmaTimingControl C1(
		     dif.TC, 
		     cif.TC, 
		     rif.TC
);

// Priority logic
DmaPriority P1(
		dif.PR,
		cif.PR,
		rif.PR 
);


endmodule
