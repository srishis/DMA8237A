// DMA Top module

module Dma8237aTop(dma_if.DUT dif);

// DMA interface instantiation
DmaControlIf cif(dif.CLK, dif.RESET);
DmaRegIf rif(dif.CLK, dif.RESET);

// DMA modules instantiation
// Datapath module
DmaDatapath D1(dif, cif, rif);
		
// Timing and Control module
DmaTimingControl C1(dif, cif, rif);

// Priority logic
DmaPriority P1(dif, cif, rif);

endmodule
