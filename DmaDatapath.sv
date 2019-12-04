
module DmaDatapath(dma_if.DP dif, DmaControlIf cif);

// Data bus logic
  always_ff@(posedge dma_if.CLK) if(cif.IDLE_CYCLE && !dif.IOW_N) cif.ioDataBuf <= dif.DB;   

// Databus DB as output 
  always_comb dif.DB = (cif.IDLE_CYCLE && ~dif.IOR_N) ? cif.ioDataBuf : 8'bz;
  
// IO Read logic
  always_comb dif.IOR_N = (cif.ACTIVE_CYCLE) ? cif.ior : 1'bz; // access data from peripheral during DMA write transfer

// IO Write logic

  always_comb dif.IOW_N = (cif.ACTIVE_CYCLE) ? cif.iow : 1'bz; // load data to peripheral during DMA read transfer

// EOP logic
  assign (pull0, pull1) dif.EOP_N = '1;   // pullup resistor logic
  always_comb dif.EOP_N = (cif.ACTIVE_CYCLE) ? cif.eop : 1'bz;

// AEN & ADSTB functionality
  always_comb dif.AEN <= cif.aen; 
  always_comb dif.ADSTB <= cif.adstb;  // when we make ADSTB = 1, MSB address from data lines DB is latched 

// Address Bus logic

  always_ff@(posedge dma_if.CLK) if(cif.IDLE_CYCLE) cif.ioAddrBuf <= dif.ADDR_L;  
  always_comb dif.ADDR_U = (cif.ACTIVE_CYCLE) ? cif.outAddrBuf : 4'bz;  
  always_comb dif.ADDR_L = (cif.ACTIVE_CYCLE) ? cif.ioAddrBuf : 4'bz;

endmodule
