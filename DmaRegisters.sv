// DMA Registers module

module DmaRegisters(dma_if.DUT dif, DmaDatapathIf.REG drf, DmaControlIf cif);

localparam [7:0] READCURRADDR[4]         = {8'b10010000,8'b10010010,8'b10010100,8'b10010110};
localparam [7:0] WRITEBASECURRADDR[4]    = {8'b10100000,8'b10100010,8'b10100100,8'b10100110};
localparam [7:0] WRITEBASECURRCOUNT[4]   = {8'b10100001,8'b10100011,8'b10100101,8'b10100111};
localparam [7:0] READCURRCOUNT[4]        = {8'b10010001,8'b10010011,8'b10010101,8'b10010111};
localparam [7:0] MODEREGWRITE[4]         = {8'b10101011,8'b10101011,8'b10101011,8'b10101011};
localparam WRITECOMMANDREG               = 8'b10101000;
localparam WRITEREQUESTREG               = 8'b10101001;
localparam WRITESINGLEMASKREG            = 8'b10101010; 
localparam WRITEALLMASKREG               = 8'b10101111;
localparam READTEMPREG                   = 8'b10011101;
localparam READSTATUSREG                 = 8'b10011000;
localparam CLEARFF                       = 8'b10101100;
localparam CLEARMASKREG                  = 8'b10101110;
localparam MASTERCLEARREG                = 8'b10101101;



//Base Address Register


always_ff@(posedge dma_if.CLK)
      begin
 

          if(dma_if.RESET||drf.masterClear)                  //When Reset, the value is set to zero.
             begin
               drf.baseAddrReg[0] <= '0;
               drf.baseAddrReg[1] <= '0;
               drf.baseAddrReg[2] <= '0;
               drf.baseAddrReg[3] <= '0;
             end
 
  //the command code for Writing the base and current register -> base Address Reg 0     
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[0])
                  begin
                      if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                        drf.baseAddrReg[0][15:8] <= drf.writeBuf;
                      else
                        drf.baseAddrReg[0][7:0] <= drf.writeBuf;
                  end
//the command code for Writing the base and current register -> base Address Reg 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[1])
                  begin
                      if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                        drf.baseAddrReg[1][15:8] <= drf.writeBuf;
                      else
                        drf.baseAddrReg[1][7:0] <= drf.writeBuf;
                  end
//the command code for Writing the base and current register -> base Address Reg 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[2])
                  begin
                      if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                        drf.baseAddrReg[2][15:8] <= drf.writeBuf;
                      else
                        drf.baseAddrReg[2][7:0] <= drf.writeBuf;
                  end
//the command code for Writing the base and current register -> base Address Reg 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[3])
                  begin
                      if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                        drf.baseAddrReg[3][15:8] <= drf.writeBuf;
                      else
                        drf.baseAddrReg[3][7:0] <= drf.writeBuf;
                  end


          else
              begin 
               drf.baseAddrReg[0] <= drf.baseAddrReg[0];
               drf.baseAddrReg[1] <= drf.baseAddrReg[1];
               drf.baseAddrReg[2] <= drf.baseAddrReg[2];
               drf.baseAddrReg[3] <= drf.baseAddrReg[3];
              end

         
       end


//Base Word Register

always_ff@(posedge dma_if.CLK)
      begin
          if(dma_if.Reset||drf.masterClear)
             begin
               drf.baseWordReg[0] <= '0;
               drf.baseWordReg[1] <= '0;
               drf.baseWordReg[2] <= '0;
               drf.baseWordReg[3] <= '0;
             end
// command code to write the base and current word count register - base count reg 0
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[0])
                  begin
                    if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                       drf.baseWordReg[0][15:8] <= drf.writeBuf;
                    else
                       drf.baseWordReg[0][7:0] <= drf.writeBuf;
                  end
// command code to write the base and current word count register - base count reg 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[1])
                  begin
                    if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                       drf.baseWordReg[1][15:8] <= drf.writeBuf;
                    else
                       drf.baseWordReg[1][7:0] <= drf.writeBuf;
                  end
// command code to write the base and current word count register - base count reg 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[2])
                  begin
                    if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                       drf.baseWordReg[2][15:8] <= drf.writeBuf;
                    else
                       drf.baseWordReg[2][7:0] <= drf.writeBuf;
                  end

// command code to write the base and current word count register - base count reg 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[3])
                  begin
                    if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                       drf.baseWordReg[3][15:8] <= drf.writeBuf;
                    else
                       drf.baseWordReg[3][7:0] <= drf.writeBuf;
                  end

          else 
              begin 
                drf.baseWordReg[0] <= drf.baseWordReg[0] ;
                drf.baseWordReg[1] <= drf.baseWordReg[1] ;
                drf.baseWordReg[2] <= drf.baseWordReg[2] ;
                drf.baseWordReg[3] <= drf.baseWordReg[3] ;
              end

       end          


// Current Address Register

always_ff@(posedge dma_if.CLK)
      begin
 
          if(dma_if.RESET||drf.masterClear)
             begin
                  drf.currAddrReg[0] <= '0;
                  drf.currAddrReg[1] <= '0;
                  drf.currAddrReg[2] <= '0;
                  drf.currAddrReg[3] <= '0;
             end
//When TC is reached and the auto initialization is disabled, the value to be set to zero
            else if ((cif.TC[drf.requestReg[1:0]])&&(drf.modeReg[4]==0))
                begin    
                  drf.currAddrReg[drf.requestReg[1:0]] <= '0;
                end
//When TC is reached and the auto initialization is enabled, the value to be re-initialised from the base registers
          else if ((cif.TC[drf.requestReg[1:0]]) && (drf.modeReg[4]==1))        
                begin  
                  drf.currAddrReg[drf.requestReg[1:0]] <= drf.baseAddrReg[drf.requestReg[1:0]]; 
                end
//command code to write curr and base address registers     current Address Reg 0      
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[0])
                  begin
                    if(drf.FF)
                       drf.currAddrReg[0][15:8] <= drf.writeBuf;
                    else
                       drf.currAddrReg[0][7:0] <= drf.writeBuf;
                  end
//command code to write curr and base address registers     current Address Reg 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[1])
                  begin
                    if(drf.FF)
                       drf.currAddrReg[1][15:8] <= drf.writeBuf;
                    else
                       drf.currAddrReg[1][7:0] <= drf.writeBuf;
                  end
//command code to write curr and base address registers     current Address Reg 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[2])
                  begin
                    if(drf.FF)
                       drf.currAddrReg[2][15:8] <= drf.writeBuf;
                    else
                       drf.currAddrReg[2][7:0] <= drf.writeBuf;
                  end
//command code to write curr and base address registers     current Address Reg 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[3])
                  begin
                    if(drf.FF)
                       drf.currAddrReg[3][15:8] <= drf.writeBuf;
                    else
                       drf.currAddrReg[3][7:0] <= drf.writeBuf;
                  end

//Read Current Address Register 0 

          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRADDR[0])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currAddrReg[0][15:8];
                    else
                       drf.readBuf <= drf.currAddrReg[0][7:0];
                  end
//Read Current Address Register 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRADDR[1])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currAddrReg[1][15:8];
                    else
                       drf.readBuf <= drf.currAddrReg[1][7:0];
                  end
//Read Current Address Register 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRADDR[2])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currAddrReg[2][15:8];
                    else
                       drf.readBuf <= drf.currAddrReg[2][7:0];
                  end
//Read Current Address Register 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRADDR[3])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currAddrReg[3][15:8];
                    else
                       drf.readBuf <= drf.currAddrReg[3][7:0];
                  end

          else if(cif.enCurrAddr) 
                  begin         // to give the most significant 8 bits as output to the i/o data bus
                    drf.ioDataBuf <= drf.currAddrReg[drf.requestReg[1:0]][15:8];
                  end
           else if(cif.ldTempCurrAddr)      //signal to load the temporary address register to current address register value 
                  drf.currAddrReg[drf.requestReg[1:0]] <= drf.tempAddrReg;
          else
              begin
                  drf.currAddrReg[0] <= drf.currAddrReg[0];
                  drf.currAddrReg[1] <= drf.currAddrReg[1];
                  drf.currAddrReg[2] <= drf.currAddrReg[2];
                  drf.currAddrReg[3] <= drf.currAddrReg[3];
                end             
         end
          
// Current Word Register                     
always_ff@(posedge dma_if.CLK)
      begin
 
          if(drf.RESET||drf.masterClear)
            begin
               drf.currWordReg[0] <= '0; 
               drf.currWordReg[1] <= '0; 
               drf.currWordReg[2] <= '0; 
               drf.currWordReg[3] <= '0; 
            end 
       
          else if((cif.TC[drf.requestReg[1:0]])&&(drf.modeReg[4]==0))
             begin
               drf.currWordReg[drf.requestReg[1:0]] <= '0;
             end

          else if((cif.TC[drf.requestReg[1:0]]) && (drf.modeReg[4]==1))
             begin
                 drf.currWordReg[drf.requestReg[1:0]] <= drf.baseWordReg[drf.requestReg[1:0]];
             end
//write Current word 0
         else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[0])
                  begin
                    if(drf.FF)
                       drf.currWordReg[0][15:8] <= drf.writeBuf;
                    else
                       drf.currWordReg[0][7:0] <= drf.writeBuf;
                  end
//write Current word 1
         else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[1])
                  begin
                    if(drf.FF)
                       drf.currWordReg[1][15:8] <= drf.writeBuf;
                    else
                       drf.currWordReg[1][7:0] <= drf.writeBuf;
                  end
//write Current word 2
         else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[2])
                  begin
                    if(drf.FF)
                       drf.currWordReg[2][15:8] <= drf.writeBuf;
                    else
                       drf.currWordReg[2][7:0] <= drf.writeBuf;
                  end
//write Current word 3
         else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[3])
                  begin
                    if(drf.FF)
                       drf.currWordReg[3][15:8] <= drf.writeBuf;
                    else
                       drf.currWordReg[3][7:0] <= drf.writeBuf;
                  end

//read current word 0
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRCOUNT[0])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currWordReg[0][15:8];
                    else
                       drf.readBuf <= drf.currWordReg[0][7:0];
                  end
//read current word 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRCOUNT[1])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currWordReg[1][15:8];
                    else
                       drf.readBuf <= drf.currWordReg[1][7:0];
                  end
//read current word 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRCOUNT[2])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currWordReg[2][15:8];
                    else
                       drf.readBuf <= drf.currWordReg[2][7:0];
                  end
//read current word 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRCOUNT[3])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currWordReg[3][15:8];
                    else
                       drf.readBuf <= drf.currWordReg[3][7:0];
                  end
           else if(cif.ldTempCurrWord)     //signal to load the temporary address register to current address register value
                begin
                  drf.currWordReg[drf.requestReg[1:0]] <= drf.tempWordReg;
                end
          else
              begin 
               drf.currWordReg[0] <= drf.currWordReg[0];
               drf.currWordReg[1] <= drf.currWordReg[1];
               drf.currWordReg[2] <= drf.currWordReg[2];
               drf.currWordReg[3] <= drf.currWordReg[3];
              end               
                    
       end                
      
    
//Temporary Address Register and Increment or Decrement

always_ff@(posedge dma_if.CLK)
         begin
             if(dma_if.RESET||drf.masterClear)
               begin
                   drf.tempAddrReg[0] <= '0;
                   drf.tempAddrReg[1] <= '0;
                   drf.tempAddrReg[2] <= '0;
                   drf.tempAddrReg[3] <= '0;
                end 
            else if(cif.ldCurrAddrTemp)     //to load the current address into temporary register and then increment or decrement
                    begin   
                      drf.tempAddrReg <= drf.currAddrReg;
                      {drf.outAddrBuf,drf.ioAddrBuf} = drf.currWordReg[7:0];
                      if(drf.modeReg[5] == 0)
                          drf.tempAddrReg[drf.requestReg[1:0]] <= drf.tempAddrReg[drf.requestReg[1:0]]  + 16'b0000000000000001;
                      else
                          drf.tempAddrReg[drf.requestReg[1:0]] <= drf.tempAddrReg[drf.requestReg[1:0]]  - 16'b0000000000000001;
                    end
             else
                  begin
                 drf.tempAddrReg[0] <= drf.tempAddrReg[0];
                 drf.tempAddrReg[1] <= drf.tempAddrReg[1];
                 drf.tempAddrReg[2] <= drf.tempAddrReg[2];
                 drf.tempAddrReg[3] <= drf.tempAddrReg[3];
                 end
         end

// Temporary Word Register

always_ff@(posedge dma_if.CLK)
         begin
           if(dma_if.RESET||drf.masterClear)
                   begin
                   drf.tempWordReg[0] <= '0;
		   drf.tempWordReg[0] <= '0;
		   drf.tempWordReg[0] <= '0;
		   drf.tempWordReg[0] <= '0;
                     end 
            else if(cif.ldCurrWordTemp)
                begin
                 drf.tempWordReg[drf.requestReg[1:0]] <= drf.currWordReg[drf.requestReg[1:0]];
                 drf.tempWordReg[drf.requestReg[1:0]] <= drf.tempWordReg[drf.requestReg[1:0]] - 16'b0000000000000001;
               end
           if(drf.tempWordReg[drf.requestReg[1:0]] ==0)
             begin
              cif.TC[drf.requestReg[1:0]] <= 1;
              drf.tempWordReg[drf.requestReg[1:0]] <= 16'b1111111111111111;
             end
            else
               begin 
              drf.tempWordReg[0] <= drf.tempWordReg[0];
              drf.tempWordReg[0] <= drf.tempWordReg[0];
              drf.tempWordReg[0] <= drf.tempWordReg[0];
              drf.tempWordReg[0] <= drf.tempWordReg[0];
              end 
          end
 

// Mode Register
// Programmed by the CPU

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
            begin
             drf.modeReg[0] <= 16'b0;
             drf.modeReg[1] <= 16'b0;
             drf.modeReg[2] <= 16'b0;
             drf.modeReg[3] <= 16'b0;
            end
//Mode Register 0
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == MODEREGWRITE[0])
               drf.modeReg[drf.ioDataBuf[1:0]] <= drf.ioDataBuf[7:2];  
//Mode Register 1
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == MODEREGWRITE[1])
               drf.modeReg[drf.ioDataBuf[1:0]] <= drf.ioDataBuf[7:2];
//Mode Register 2
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == MODEREGWRITE[2])
               drf.modeReg[drf.ioDataBuf[1:0]] <= drf.ioDataBuf[7:2];
//Mode Register 3
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == MODEREGWRITE[3])
               drf.modeReg[drf.ioDataBuf[1:0]] <= drf.ioDataBuf[7:2];          
          else 
              begin
              drf.modeReg[0] <=  drf.modeReg[0] ;
              drf.modeReg[1] <=  drf.modeReg[1] ;
              drf.modeReg[2] <=  drf.modeReg[2] ;
              drf.modeReg[3] <=  drf.modeReg[3] ;
              end
          end
               



// Command Register

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
             drf.commandReg <= '0;
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITECOMMANDREG)
               drf.commandReg <= drf.ioDataBuf;            
          else 
              drf.commandReg <=  drf.commandReg;
          end
               


//Request Register

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
             drf.requestReg= '0;
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEREQUESTREG)
               drf.requestReg <= drf.ioDataBuf;            
          else 
              drf.requestReg <=  drf.requestReg ;
          end
               


// Mask Register

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
               drf.maskReg= '0;          
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEALLMASKREG)
              begin 
               drf.maskReg[3:0] <= drf.ioDataBuf[3:0];  
              end        
          else 
              drf.maskReg <= drf.maskReg ;
          end
                  
                       
             
//Temporary Register

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
             drf.tempReg <= 0;
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READTEMPREG)
               drf.ioDataBuf <= drf.tempReg;            
          else 
              drf.tempReg <=  drf.tempReg ;
          end


//Status Register

always_ff@(posedge dma_if.CLK)
        begin

                 drf.statusReg[0] <= (cif.TC[0])?1'b1:1'b0;
                 drf.statusReg[1] <= (cif.TC[1])?1'b1:1'b0;
                 drf.statusReg[2] <= (cif.TC[2])?1'b1:1'b0;
                 drf.statusReg[3] <= (cif.TC[3])?1'b1:1'b0;  
                 drf.statusReg[4] <= (cif.valid_DREQ[0])?1'b1:1'b0;  
                 drf.statusReg[5] <= (cif.valid_DREQ[1])?1'b1:1'b0; 
                 drf.statusReg[6] <= (cif.valid_DREQ[2])?1'b1:1'b0; 
                 drf.statusReg[7] <= (cif.valid_DREQ[3])?1'b1:1'b0; 

          if(dma_if.RESET||drf.masterClear)
             drf.statusReg <= '0;
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READSTATUSREG)
             drf.ioDataBuf <= drf.statusReg;
          else  
             drf.statusReg <= drf.statusReg;
          
                       
        end       
          
// CLEAR FF

always_ff@(posedge dma_if.CLK)
          begin

            if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == CLEARFF)
                drf.FF <= 1'b0;
             else
                drf.FF <= 1'b1;
          end


//Master Clear

always_ff@(posedge dma_if.CLK)
          begin
            drf.masterClear <= 0;
            if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == CLEARMASKREG)     
                       drf.masterClear <= 1;
              else
                       drf.masterClear <= drf.masterClear;
            end

//Clear Mask Register

always_ff@(posedge dma_if.CLK)
         begin
           
          if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == CLEARMASKREG)
                      drf.maskReg <= '0;
          else
                      drf.maskReg <= drf.maskReg ;

        end  

//Read Buffer

always_ff@(posedge dma_if.CLK)
       begin
          if(dma_if.RESET||drf.masterClear)
              begin
                 drf.readBuf <= '0;
              end
         else
            begin     
               drf.ioDataBuf <=drf.readBuf;
            end
       end

//Write Buffer

always_ff@(posedge dma_if.CLK)
       begin
          if(dma_if.RESET||drf.masterClear)
              begin
                 drf.writeBuf <= '0;
              end
          else
             begin
               drf.writeBuf <= drf.ioDataBuf;
             end
        end 
 

endmodule
           
             
