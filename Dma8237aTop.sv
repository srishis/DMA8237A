// DMA Top module

module Dma8237aTop(dma_if.DUT dif, input logic CLK, RESET);

// DMA modules instantiation
	DmaDatapath D1(dif.DP, CLK, RESET);
	DmaTimingControl C1(dif.TC, CLK, RESET);
	DmaRegisters R1(dif.REG, CLK, RESET);
	DmaPriority P1(dif.PR, CLK, RESET);

endmodule
