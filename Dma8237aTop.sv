// DMA Top module

module Dma8237aTop(dma_if.DUT dif, input logic CLK, RESET);


// DMA interface instantiation
DmaControlIf cif(CLK, RESET);

logic [5:0]  modeReg[4];
logic [7:0]  commandReg;
logic [7:0]  requestReg;
logic [7:0]  maskReg;

// DMA modules instantiation
// Datapath module
DmaDatapath D1(
		dp_if.DP, 
		cif, 
		modeReg,
		commandReg,
		requestReg,
		maskReg
);
	
	
// Timing and Control module
DmaTimingControl C1(
		     dif.TC, 
		     cif, 
		     modeReg,
		     commandReg
);

// Priority logic
DmaPriority P1(
		dif.PR, 
		commandReg,
		requestReg,
		maskReg
);


endmodule
