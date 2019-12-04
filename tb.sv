
module top;

bit CLK, RESET;
	
dma_if dif(CLK, RESET);
	
Dma8237aTop DMT (dif);

// CLock
initial #10 forever  CLK = ~CLK; 

// Reset
initial begin
	RESET = 1;
	repeat(50)@(negedge CLK) RESET = 0;
end

endmodule




