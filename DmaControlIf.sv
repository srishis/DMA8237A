
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
               drf.baseAddrReg[drf.requestReg[1:0]] <= '0;
             end
 
  //the command code for Writing the base and current register       
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[drf.requestReg[1:0]])
                  begin
                      if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                        drf.baseAddrReg[drf.requestReg[1:0]][15:8] <= drf.writeBuf;
                      else
                        drf.baseAddrReg[drf.requestReg[1:0]][7:0] <= drf.writeBuf;
                  end

          else
              begin 
               drf.baseAddrReg[drf.requestReg[1:0]] <= drf.baseAddrReg[drf.requestReg[1:0]];
              end

         
       end


//Base Word Register

always_ff@(posedge dma_if.CLK)
      begin
          if(dma_if.Reset||drf.masterClear)
             begin
               drf.baseWordReg[drf.requestReg[1:0]] <= '0;
             end
// command code to write the base and current word count register
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[drf.requestReg[1:0]])
                  begin
                    if(drf.FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                       drf.baseWordReg[drf.requestReg[1:0]][15:8] <= drf.writeBuf;
                    else
                       drf.baseWordReg[drf.requestReg[1:0]][7:0] <= drf.writeBuf;
                  end

          else 
              begin 
                drf.baseWordReg[drf.requestReg[1:0]] <= drf.baseWordReg[drf.requestReg[1:0]] ;
              end

       end          


// Current Address Register

always_ff@(posedge dma_if.CLK)
      begin
 
          if(dma_if.RESET||drf.masterClear)
             begin
                  drf.currAddrReg[drf.requestReg[1:0]] <= '0;
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
//command code to write curr and base address registers          
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRADDR[drf.requestReg[1:0]])
                  begin
                    if(drf.FF)
                       drf.currAddrReg[drf.requestReg[1:0]][15:8] <= drf.writeBuf;
                    else
                       drf.currAddrReg[drf.requestReg[1:0]][7:0] <= drf.writeBuf;
                  end
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRADDR[drf.requestReg[1:0]])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currAddrReg[drf.requestReg[1:0]][15:8];
                    else
                       drf.readBuf <= drf.currAddrReg[drf.requestReg[1:0]][7:0];
                  end
          else if(cif.enCurrAddr) 
                  begin         // to give the most significant 8 bits as output to the i/o data bus
                    drf.ioDataBuf <= drf.currAddrReg[drf.requestReg[1:0]][15:8];
                  end
           else if(cif.ldTempCurrAddr)      //signal to load the temporary address register to current address register value 
                  drf.currAddrReg <= drf.tempAddrReg;

                             
         end
          
// Current Word Register                     
always_ff@(posedge dma_if.CLK)
      begin
 
          if(drf.RESET||drf.masterClear)
            begin
               drf.currWordReg[drf.requestReg[1:0]] <= '0; 
            end 
       
          else if((cif.TC[drf.requestReg[1:0]])&&(drf.modeReg[4]==0))
             begin
               drf.currWordReg[drf.requestReg[1:0]] <= '0;
             end

          else if((cif.TC[drf.requestReg[1:0]]) && (drf.modeReg[4]==1))
             begin
                 drf.currWordReg[drf.requestReg[1:0]] <= drf.baseWordReg[drf.requestReg[1:0]];
             end
 
         else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == WRITEBASECURRCOUNT[drf.requestReg[1:0]])
                  begin
                    if(drf.FF)
                       drf.currWordReg[drf.requestReg[1:0]][15:8] <= drf.writeBuf;
                    else
                       drf.currWordReg[drf.requestReg[1:0]][7:0] <= drf.writeBuf;
                  end
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == READCURRCOUNT[drf.requestReg[1:0]])
                  begin
                    if(drf.FF)
                       drf.readBuf <= drf.currWordReg[drf.requestReg[1:0]][15:8];
                    else
                       drf.readBuf <= drf.currWordReg[drf.requestReg[1:0]][7:0];
                  end
           else if(cif.ldTempCurrWord)     //signal to load the temporary address register to current address register value
                begin
                  drf.currWordReg <= drf.tempWordReg;
                end
          else
              begin 
               drf.currWordReg[drf.requestReg[1:0]] <= drf.currWordReg[drf.requestReg[1:0]];
              end               
                    
       end                
      
    
//Temporary Address Register and Increment or Decrement

always_ff@(posedge dma_if.CLK)
         begin
             if(dma_if.RESET||drf.masterClear)
               begin
                   drf.tempAddrReg[drf.requestReg[1:0]] <= '0;
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
                 drf.tempAddrReg <= drf.tempAddrReg;
         end

// Temporary Word Register

always_ff@(posedge dma_if.CLK)
         begin
           if(dma_if.RESET||drf.masterClear)
                   drf.tempWordReg[drf.requestReg[1:0]] <= '0; 
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
              drf.tempWordReg[drf.requestReg[1:0]] <= drf.tempWordReg[drf.requestReg[1:0]];
             
          end
 

// Mode Register
// Programmed by the CPU

always_ff@(posedge dma_if.CLK)
          begin
          
          if(dma_if.RESET||drf.masterClear)
             drf.modeReg[drf.requestReg[1:0]] <= 16'b0;
          else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,drf.ioAddrBuf} == MODEREGWRITE[drf.requestReg[1:0]])
               drf.modeReg[drf.ioDataBuf[1:0]] <= drf.ioDataBuf[7:2];            
          else 
              drf.modeReg[drf.requestReg[1:0]] <=  drf.modeReg[drf.requestReg[1:0]] ;
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
           
             
