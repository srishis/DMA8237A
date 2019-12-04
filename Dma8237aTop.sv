// DMA Top module

`timescale 100ns/10ns
module Dma8237aTop;

parameter CLK_PERIOD = 200;
parameter CLK_CYCLES = 20;

logic CLK, RESET;

// Interface instantiation
dma_if dif(CLK, RESET);
DmaControlIf cif(CLK, RESET);
DmaDatapathIf drf(CLK, RESET);


// DMA modules
DmaDatapath D1(dif, cif, drf);
DmaTimingControl C1(dif, cif, drf);
DmaRegisters R1(dif, cif, drf);
DmaPriority P1(dif, drf);

// Clock generation 
initial begin
	CLK = 0;
	forever #(CLK_PERIOD) CLK = ~CLK;
end


endmodule
