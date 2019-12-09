// DMA Data path module with register definitions

module DmaDatapath(dma_if.DP dif, DmaControlIf.DP cif, DmaRegIf.DP rif);

// internal registers
logic [15:0] currAddrReg[4];
logic [15:0] currWordReg[4];
logic [15:0] baseAddrReg[4];
logic [15:0] baseWordReg[4];
logic [7:0]  tempReg;
logic [7:0]  tempAddrReg;
logic [7:0]  tempWordReg;

logic TC[4];	

// Datapath Buffers
logic [3:0] ioAddrBuf;      
logic [3:0] outAddrBuf;      
logic [7:0] ioDataBuf;  	
logic [7:0] readBuf;
logic [7:0] writeBuf;
	
// Register commands
logic masterClear;
logic FF;

// DMA Registers SW command codes
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


// Reset condition
  always_ff@(posedge dif.CLK) begin
  if(dif.RESET) begin			
  	ioAddrBuf  <= '0;
  	ioDataBuf  <= '0;
  	outAddrBuf <= '0;
  	readBuf    <= '0;
  	writeBuf   <= '0;
  end
  else begin
  	ioAddrBuf  <= ioAddrBuf;
  	ioDataBuf  <= ioDataBuf;
  	outAddrBuf <= outAddrBuf;
  	readBuf    <= readBuf;
  	writeBuf   <= writeBuf;
  end
  end

// Data bus logic
  always_ff@(posedge dif.CLK) if(!dif.CS_N && !dif.IOW_N) ioDataBuf <= dif.DB;   
  assign dif.DB = (~dif.CS_N && ~dif.IOR_N) ? ioDataBuf : 8'bz;
  
// Address Bus logic
  always_ff@(posedge dif.CLK) if(!dif.CS_N && ~dif.HLDA) ioAddrBuf <= dif.ADDR_L;  
  assign dif.ADDR_L = (~dif.CS_N && dif.HLDA) ? ioAddrBuf : 4'bz;
  assign dif.ADDR_U = (~dif.CS_N && dif.HLDA) ? outAddrBuf : 4'bz;
	

// DMA Registers logic
//Base Address Register
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET||masterClear)  begin                
                 baseAddrReg[0] <= '0;
                 baseAddrReg[1] <= '0;
                 baseAddrReg[2] <= '0;
                 baseAddrReg[3] <= '0;
               end
   
    //the command code for Writing the base and current register -> base Address Reg 0     
            else if({cif.Program, dif.CS_N, dif.IOR_N, dif.IOW_N, ioAddrBuf} == WRITEBASECURRADDR[0])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          baseAddrReg[0][15:8] <= writeBuf;
                        else
                          baseAddrReg[0][7:0] <= writeBuf;
                    end
  	
  //the command code for Writing the base and current register -> base Address Reg 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[1])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          baseAddrReg[1][15:8] <= writeBuf;
                        else
                          baseAddrReg[1][7:0] <= writeBuf;
                    end
  //the command code for Writing the base and current register -> base Address Reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[2])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          baseAddrReg[2][15:8] <= writeBuf;
                        else
                          baseAddrReg[2][7:0] <= writeBuf;
                    end
  //the command code for Writing the base and current register -> base Address Reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[3])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          baseAddrReg[3][15:8] <= writeBuf;
                        else
                          baseAddrReg[3][7:0] <= writeBuf;
                    end
  
  
            else
                begin 
                 baseAddrReg[0] <= baseAddrReg[0];
                 baseAddrReg[1] <= baseAddrReg[1];
                 baseAddrReg[2] <= baseAddrReg[2];
                 baseAddrReg[3] <= baseAddrReg[3];
                end
  
           
         end
  
  
  //Base Word Register
  always_ff@(posedge dif.CLK)
        begin
            if(dif.RESET||masterClear)
               begin
                 baseWordReg[0] <= '0;
                 baseWordReg[1] <= '0;
                 baseWordReg[2] <= '0;
                 baseWordReg[3] <= '0;
               end
  // command code to write the base and current word count register - base count reg 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[0])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         baseWordReg[0][15:8] <= writeBuf;
                      else
                         baseWordReg[0][7:0] <= writeBuf;
                    end
  // command code to write the base and current word count register - base count reg 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[1])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         baseWordReg[1][15:8] <= writeBuf;
                      else
                         baseWordReg[1][7:0] <= writeBuf;
                    end
  // command code to write the base and current word count register - base count reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[2])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         baseWordReg[2][15:8] <= writeBuf;
                      else
                         baseWordReg[2][7:0] <= writeBuf;
                    end
  
  // command code to write the base and current word count register - base count reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[3])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         baseWordReg[3][15:8] <= writeBuf;
                      else
                         baseWordReg[3][7:0] <= writeBuf;
                    end
  
            else 
                begin 
                  baseWordReg[0] <= baseWordReg[0] ;
                  baseWordReg[1] <= baseWordReg[1] ;
                  baseWordReg[2] <= baseWordReg[2] ;
                  baseWordReg[3] <= baseWordReg[3] ;
                end
  
         end          
  
  
  // Current Address Register
  
  always_ff@(posedge dif.CLK)
        begin
   
            if(dif.RESET||masterClear)
               begin
                    currAddrReg[0] <= '0;
                    currAddrReg[1] <= '0;
                    currAddrReg[2] <= '0;
                    currAddrReg[3] <= '0;
               end
  //When TC is reached and the auto initialization is disabled, the value to be set to zero
              else if ((TC[rif.requestReg[1:0]])&&(rif.modeReg[4]==0))
                  begin    
                    currAddrReg[rif.requestReg[1:0]] <= '0;
                  end
  //When TC is reached and the auto initialization is enabled, the value to be re-initialised from the base registers
            else if ((TC[rif.requestReg[1:0]]) && (rif.modeReg[4]==1))        
                  begin  
                    currAddrReg[rif.requestReg[1:0]] <= baseAddrReg[rif.requestReg[1:0]]; 
                  end
  //command code to write curr and base address registers     current Address Reg 0      
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[0])
                    begin
                      if(FF)
                         currAddrReg[0][15:8] <= writeBuf;
                      else
                         currAddrReg[0][7:0] <= writeBuf;
                    end
  //command code to write curr and base address registers     current Address Reg 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[1])
                    begin
                      if(FF)
                         currAddrReg[1][15:8] <= writeBuf;
                      else
                         currAddrReg[1][7:0] <= writeBuf;
                    end
  //command code to write curr and base address registers     current Address Reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[2])
                    begin
                      if(FF)
                         currAddrReg[2][15:8] <= writeBuf;
                      else
                         currAddrReg[2][7:0] <= writeBuf;
                    end
  //command code to write curr and base address registers     current Address Reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRADDR[3])
                    begin
                      if(FF)
                         currAddrReg[3][15:8] <= writeBuf;
                      else
                         currAddrReg[3][7:0] <= writeBuf;
                    end
  
  //Read Current Address Register 0 
  
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRADDR[0])
                    begin
                      if(FF)
                         readBuf <= currAddrReg[0][15:8];
                      else
                         readBuf <= currAddrReg[0][7:0];
                    end
  //Read Current Address Register 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRADDR[1])
                    begin
                      if(FF)
                         readBuf <= currAddrReg[1][15:8];
                      else
                         readBuf <= currAddrReg[1][7:0];
                    end
  //Read Current Address Register 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRADDR[2])
                    begin
                      if(FF)
                         readBuf <= currAddrReg[2][15:8];
                      else
                         readBuf <= currAddrReg[2][7:0];
                    end
  //Read Current Address Register 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRADDR[3])
                    begin
                      if(FF)
                         readBuf <= currAddrReg[3][15:8];
                      else
                         readBuf <= currAddrReg[3][7:0];
                    end
  
            else if(cif.enCurrAddr) 
                    begin         // to give the most significant 8 bits as output to the i/o data bus
                      ioDataBuf <= currAddrReg[rif.requestReg[1:0]][15:8];
                    end
             else if(cif.ldTempCurrAddr)      //signal to load the temporary address register to current address register value 
                    currAddrReg[rif.requestReg[1:0]] <= tempAddrReg;
            else
                begin
                    currAddrReg[0] <= currAddrReg[0];
                    currAddrReg[1] <= currAddrReg[1];
                    currAddrReg[2] <= currAddrReg[2];
                    currAddrReg[3] <= currAddrReg[3];
                  end             
           end
            
  // Current Word Register                     
  always_ff@(posedge dif.CLK)
        begin
   
  	      if(dif.RESET||masterClear)
              begin
                 currWordReg[0] <= '0; 
                 currWordReg[1] <= '0; 
                 currWordReg[2] <= '0; 
                 currWordReg[3] <= '0; 
              end 
         
            else if((TC[rif.requestReg[1:0]])&&(rif.modeReg[4]==0))
               begin
                 currWordReg[rif.requestReg[1:0]] <= '0;
               end
  
            else if((TC[rif.requestReg[1:0]]) && (rif.modeReg[4]==1))
               begin
                   currWordReg[rif.requestReg[1:0]] <= baseWordReg[rif.requestReg[1:0]];
               end
  //write Current word 0
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[0])
                    begin
                      if(FF)
                         currWordReg[0][15:8] <= writeBuf;
                      else
                         currWordReg[0][7:0] <= writeBuf;
                    end
  //write Current word 1
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[1])
                    begin
                      if(FF)
                         currWordReg[1][15:8] <= writeBuf;
                      else
                         currWordReg[1][7:0] <= writeBuf;
                    end
  //write Current word 2
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[2])
                    begin
                      if(FF)
                         currWordReg[2][15:8] <= writeBuf;
                      else
                         currWordReg[2][7:0] <= writeBuf;
                    end
  //write Current word 3
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEBASECURRCOUNT[3])
                    begin
                      if(FF)
                         currWordReg[3][15:8] <= writeBuf;
                      else
                         currWordReg[3][7:0] <= writeBuf;
                    end
  
  //read current word 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRCOUNT[0])
                    begin
                      if(FF)
                         readBuf <= currWordReg[0][15:8];
                      else
                         readBuf <= currWordReg[0][7:0];
                    end
  //read current word 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRCOUNT[1])
                    begin
                      if(FF)
                         readBuf <= currWordReg[1][15:8];
                      else
                         readBuf <= currWordReg[1][7:0];
                    end
  //read current word 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRCOUNT[2])
                    begin
                      if(FF)
                         readBuf <= currWordReg[2][15:8];
                      else
                         readBuf <= currWordReg[2][7:0];
                    end
  //read current word 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READCURRCOUNT[3])
                    begin
                      if(FF)
                         readBuf <= currWordReg[3][15:8];
                      else
                         readBuf <= currWordReg[3][7:0];
                    end
             else if(cif.ldTempCurrWord)     //signal to load the temporary address register to current address register value
                  begin
                    currWordReg[rif.requestReg[1:0]] <= tempWordReg;
                  end
            else
                begin 
                 currWordReg[0] <= currWordReg[0];
                 currWordReg[1] <= currWordReg[1];
                 currWordReg[2] <= currWordReg[2];
                 currWordReg[3] <= currWordReg[3];
                end               
                      
         end                
        
      
  //Temporary Address Register and Increment or Decrement
  
  always_ff@(posedge dif.CLK)
           begin
               if(dif.RESET||masterClear)
                 begin
                     tempAddrReg <= '0;
  
                  end 
              else if(cif.ldCurrAddrTemp)     //to load the current address into temporary register and then increment or decrement
                      begin   
                        tempAddrReg <= currAddrReg[rif.requestReg[1:0]];
                        {outAddrBuf,ioAddrBuf} = currWordReg[rif.requestReg[1:0]][7:0];
                        if(rif.modeReg[5] == 0)
                            tempAddrReg <= tempAddrReg  + 16'b0000000000000001;
                        else
                            tempAddrReg <= tempAddrReg  - 16'b0000000000000001;
                      end
               else
                    begin
                   tempAddrReg <= tempAddrReg;
                    end
           end
  
  // Temporary Word Register
  
  always_ff@(posedge dif.CLK)
           begin
             if(dif.RESET||masterClear)
                     begin
                     tempWordReg <= '0;
  
                       end 
              else if(cif.ldCurrWordTemp)
                  begin
                   tempWordReg <= currWordReg[rif.requestReg[1:0]];
                   tempWordReg <= tempWordReg - 16'b0000000000000001;
                 end
             if(tempWordReg ==0)
               begin
                TC[rif.requestReg[1:0]] <= 1;
                tempWordReg <= 16'b1111111111111111;
               end
              else
                 begin 
                tempWordReg <= tempWordReg;
       
                end 
            end
   
  
  // Mode Register
  // cif.Programmed by the CPU
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||masterClear)
              begin
               rif.modeReg[0] <= 16'b0;
               rif.modeReg[1] <= 16'b0;
               rif.modeReg[2] <= 16'b0;
               rif.modeReg[3] <= 16'b0;
              end
  //Mode Register 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == MODEREGWRITE[0])
                 rif.modeReg[ioDataBuf[1:0]] <= ioDataBuf[7:2];  
  //Mode Register 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == MODEREGWRITE[1])
                 rif.modeReg[ioDataBuf[1:0]] <= ioDataBuf[7:2];
  //Mode Register 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == MODEREGWRITE[2])
                 rif.modeReg[ioDataBuf[1:0]] <= ioDataBuf[7:2];
  //Mode Register 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == MODEREGWRITE[3])
                 rif.modeReg[ioDataBuf[1:0]] <= ioDataBuf[7:2];          
            else 
                begin
                rif.modeReg[0] <=  rif.modeReg[0] ;
                rif.modeReg[1] <=  rif.modeReg[1] ;
                rif.modeReg[2] <=  rif.modeReg[2] ;
                rif.modeReg[3] <=  rif.modeReg[3] ;
                end
            end
                 
  
  
  
  // Command Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||masterClear)
               rif.commandReg <= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITECOMMANDREG)
                 rif.commandReg <= ioDataBuf;            
            else 
                rif.commandReg <=  rif.commandReg;
            end
                 
  
  
  //Request Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||masterClear)
               rif.requestReg= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEREQUESTREG)
                 rif.requestReg <= ioDataBuf;            
            else 
                rif.requestReg <=  rif.requestReg ;
            end
                 
  
  
  // Mask Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||masterClear)
                 rif.maskReg= '0;          
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITEALLMASKREG)
                begin 
                 rif.maskReg[3:0] <= ioDataBuf[3:0];  
                end        
            else 
                rif.maskReg <= rif.maskReg ;
            end
                    
                         
               
  //Temporary Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||masterClear)
               tempReg <= 0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READTEMPREG)
                 ioDataBuf <= tempReg;            
            else 
                tempReg <=  tempReg ;
            end
  
  
  //Status Register
  
  always_ff@(posedge dif.CLK)
          begin
  
                   rif.statusReg[0] <= (TC[0])?1'b1:1'b0;
                   rif.statusReg[1] <= (TC[1])?1'b1:1'b0;
                   rif.statusReg[2] <= (TC[2])?1'b1:1'b0;
                   rif.statusReg[3] <= (TC[3])?1'b1:1'b0;  
                   rif.statusReg[4] <= (cif.VALID_DREQ0)?1'b1:1'b0;  
                   rif.statusReg[5] <= (cif.VALID_DREQ1)?1'b1:1'b0; 
                   rif.statusReg[6] <= (cif.VALID_DREQ2)?1'b1:1'b0; 
                   rif.statusReg[7] <= (cif.VALID_DREQ3)?1'b1:1'b0; 
  
            if(dif.RESET||masterClear)
               rif.statusReg <= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == READSTATUSREG)
               ioDataBuf <= rif.statusReg;
            else  
               rif.statusReg <= rif.statusReg;
            
                         
          end       
            
  // CLEAR FF
  
  always_ff@(posedge dif.CLK)
            begin
  
              if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == CLEARFF)
                  FF <= 1'b0;
               else
                  FF <= 1'b1;
            end
  
  
  //Master Clear
  
  always_ff@(posedge dif.CLK)
            begin
              masterClear <= 0;
              if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == CLEARMASKREG)     
                         masterClear <= 1;
                else
                         masterClear <= masterClear;
              end
  
  //Clear Mask Register
  
  always_ff@(posedge dif.CLK)
           begin
             
            if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == CLEARMASKREG)
                        rif.maskReg <= '0;
            else
                        rif.maskReg <= rif.maskReg ;
  
          end  
  
  //Read Buffer
  
  always_ff@(posedge dif.CLK)
         begin
            if(dif.RESET||masterClear)
                begin
                   readBuf <= '0;
                end
           else
              begin     
                 ioDataBuf <=readBuf;
              end
         end
  
  //Write Buffer
  
  always_ff@(posedge dif.CLK)
         begin
            if(dif.RESET||masterClear)
                begin
                   writeBuf <= '0;
                end
            else
               begin
                 writeBuf <= ioDataBuf;
               end
          end 

endmodule
