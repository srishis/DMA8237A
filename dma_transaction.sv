class dma_transaction;
  
  rand bit ior;
  rand bit iow;
  rand bit [7:0] data;
  //rand bit [7:0] data_out;
  rand bit [3:0] addr_lo;
  //rand bit [3:0] out_addr;
  rand bit eop;
  rand bit [3:0] dreq;
  rand bit hlda;
  rand bit cs;
  
  bit [3:0] addr_hi;
	bit [3:0] dack;
	bit hrq;
	bit aen;
	bit adstb;
  
  // deep copy method
  function void copy(output dma_transaction tx);
    tx = new;
    tx.ior = this.ior;
    tx.iow = this.iow;
    tx.data = this.data;
    tx.addr_lo = this.addr_lo;
    tx.eop = this.eop
    tx.dreq = this.dreq;
    tx.hlda = this.hlda;
    tx.cs = this.cs;
    tx.addr_hi = this.addr_hi;
    tx.dack = this.dack;
    tx.hrq = this.hrq;
    tx.aen = this.aen;
    tx.adstb = this.adstb;
  endfunction
  
  function void compare(input dma_transaction tx);
    if(
      tx.ior != this.ior ||
      tx.iow != this.iow ||
      tx.data != this.data ||
      tx.addr_lo != this.addr_lo ||
      tx.eop != this.eop ||
      tx.dreq != this.dreq ||
      tx.hlda != this.hlda ||
      tx.cs != this.cs ||
      tx.addr_hi != this.addr_hi ||
      tx.dack != this.dack ||
      tx.hrq != this.hrq ||
      tx.aen != this.aen ||
      tx.adstb != this.adstb)
        return 0;         // compare failed
    else
        return 1;         // compare passed
  endfunction
  
  function void print();
      $display("-----PRINTING TRANSACTION CLASS PROPERTIES---------");
      
  endfunction
endclass
