// DMA Top module

module Dma8237aTop(dma_if.DUT dif, input logic CLK, RESET);


// DMA interface instantiation
DmaControlIf cif(CLK, RESET);
DmaRegIf rif(CLK, RESET);

// DMA modules instantiation
// Datapath module
DmaDatapath D1(
		dp_if.DP, 
		cif, rif
);
	
	
// Timing and Control module
DmaTimingControl C1(
		     dif.TC, 
		     cif, 
		     rif
);

// Priority logic
DmaPriority P1(
		dif.PR,
		rif
	
);


endmodule
