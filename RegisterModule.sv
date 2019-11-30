//Few edits to be done 
module RegisterModule();

localparam [7:0] READCURRADDR[3:0]       = {8'b10010000,8'b10010010,8'b10010100,8'b10010110};
localparam [7:0] WRITEBASECURRADDR[3:0]  = {8'b10100000,8'b10100010,8'b10100100,8'b10100110};
localparam [7:0] WRITEBASECURRCOUNT[3:0] = {8'b10100001,8'b10100011,8'b10100101,8'b10100111};
localparam [7:0] READCURRCOUNT[3:0]      = {8'b10010001,8'b10010011,8'b10010101,8'b10010111};
localparam [7:0] MODEREGWRITE[3:0]       = {8'b10101011,8'b10101011,8'b10101011,8'b10101011};
localparam WRITECOMMANDREG               = 8'b10101000;
localparam WRITEREQUESTREG               = 8'b10101001;
localparam WRITESINGLEMASKREG            = 8'b10101010; 
localparam WRITEALLMASKREG               = 8'b10101111;
localparam READTEMPREG                   = 8'b10011101;
localparam READSTATUSREG                 = 8'b10011000;
localparam CLEARFLIPFLOP                 = 8'b10101100;
localparam CLEARMASKREG                  = 8'b10101110;
localparam MASTERCLEARREG                = 8'b10101101;

logic [15:0] baseAddrReg[4]; logic [15:0] baseAddrReg1[4];
logic [15:0] baseWordReg[4]; logic [15:0] baseWordReg1[4];
logic [15:0] currAddrReg[4]; logic [15:0] currAddrReg1[4];
logic [15:0] currWordReg[4]; logic [15:0] currWordReg1[4];
logic [15:0] tempAddrReg[4]; logic [15:0] tempAddrReg1[4];
logic [15:0] tempWordReg[4]; logic [15:0] tempWordReg1[4];
logic [6:0] modeReg[4];      logic [6:0] modeReg1[4];
logic [7:0] commandReg;      logic [7:0] commandReg1;
logic [7:0] requestReg;      logic [7:0] requestReg1;
logic [7:0] maskReg;         logic [7:0] maskReg1;
logic [7:0] tempReg;         logic [7:0] tempReg1;
logic [7:0] statusReg;       logic [7:0] statusReg1;
logic [7:0] DB;
logic [3:0] ADDR_L;

logic flipFlop,masterClear,enableBaseAddr,enableBaseWord,RESET,CLK,enableCurrAddr,ldTempCurrAddr,ldCurrWordTemp,decr,enablemodeReg,
      enableCommandReg,enableRequestReg,enableMaskReg,singleMask,enableTempReg,enableStatusReg,Program,CS,IOR,IOW,ldTempCurrWord,ldCurrAddrTemp,EOP;

logic TC[4];
logic DREQ[4];

//Base Address Register


always_ff@(posedge CLK,posedge RESET)
      begin
 
          if(masterClear)

             baseAddrReg1[requestReg[1:0]] <= 0;

          else if(enableBaseAddr)
               baseAddrReg[requestReg[1:0]] <= baseAddrReg1[requestReg[1:0]];

          else if({Program,CS,IOR,IOW,ADDR_L} <= WRITEBASECURRADDR[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       baseAddrReg1[requestReg[1:0]][15:8] <= DB;
                    else
                       baseAddrReg1[requestReg[1:0]][7:0] <= DB;
                    end
         
       end


//Base Word Register

always_ff@(posedge CLK,posedge RESET)
      begin
          if(masterClear)

             baseWordReg1[requestReg[1:0]] = 0;
          else if(enableBaseWord) 
               baseWordReg[requestReg[1:0]] = baseWordReg1[requestReg[1:0]] ;

          else if({Program,CS,IOR,IOW,ADDR_L} == WRITEBASECURRCOUNT[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       baseWordReg1[requestReg[1:0]][15:8] = DB;
                    else
                       baseWordReg1[requestReg[1:0]][7:0] = DB;
                    end

       end          


// Current Address Register

always_ff@(posedge CLK,posedge RESET)
      begin
 
          if((RESET||masterClear)&&(TC[requestReg[1:0]])&&(modeReg[4]==0))
               currAddrReg[requestReg[1:0]] <= 0;
          else if ((RESET||masterClear)&& (TC[requestReg[1:0]]) && (modeReg[4]==1))
                 currAddrReg[requestReg[1:0]] <= baseAddrReg[requestReg[1:0]]; 
          else if(enableCurrAddr)
               currAddrReg[requestReg[1:0]] <= currAddrReg1[requestReg[1:0]];
                             
          else if({Program,CS,IOR,IOW,ADDR_L} <= WRITEBASECURRADDR[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       currAddrReg1[requestReg[1:0]][15:8] <= DB;
                    else
                       currAddrReg1[requestReg[1:0]][7:0] <= DB;
                    end
          else if({Program,CS,IOR,IOW,ADDR_L} <= READCURRADDR[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       DB = currAddrReg1[requestReg[1:0]][15:8];
                    else
                       DB = currAddrReg1[requestReg[1:0]][7:0];
                    end
           else if(ldTempCurrAddr)
                  currAddrReg1 = tempAddrReg;          
       end
          
// Current Word Register                     
always_ff@(posedge CLK,posedge RESET)
      begin
 
          if((RESET||masterClear)&&(TC[requestReg[1:0]])&&(modeReg[4]==0))
               currWordReg[requestReg[1:0]] <= 0;
          else if ((RESET||masterClear)&& (TC[requestReg[1:0]]) && (modeReg[4]==1))
                 currWordReg[requestReg[1:0]] <= baseWordReg[requestReg[1:0]]; 

          else if(enableCurrAddr)
               currWordReg[requestReg[1:0]] <= currWordReg1[requestReg[1:0]];
                             
          else if({Program,CS,IOR,IOW,ADDR_L} <= WRITEBASECURRADDR[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       currWordReg1[requestReg[1:0]][15:8] <= DB;
                    else
                       currWordReg1[requestReg[1:0]][7:0] <= DB;
                    end
          else if({Program,CS,IOR,IOW,ADDR_L} <= READCURRADDR[requestReg[1:0]])
                  begin
                    if(flipFlop)
                       DB = currWordReg1[requestReg[1:0]][15:8];
                    else
                       DB = currWordReg1[requestReg[1:0]][7:0];
                    end
           else if(ldTempCurrWord)
                  currWordReg1 = tempWordReg;          
       end                
      
    
//Temporary Address Register and Increment or Decrement

always_ff@(posedge CLK,posedge RESET)
         begin
             if(RESET||masterClear)
                   tempAddrReg[requestReg[1:0]] <= 0; 
            else if(ldCurrAddrTemp)
                 tempAddrReg = currWordReg;

            if(modeReg[5] == 0)
                tempAddrReg[requestReg[1:0]] = tempAddrReg[requestReg[1:0]]  + 16'b0000000000000001;
            else if(modeReg[5] == 0)
                tempAddrReg[requestReg[1:0]]  = tempAddrReg[requestReg[1:0]]  - 16'b0000000000000001;
         end

// Temporary Word Register

always_ff@(posedge CLK,posedge RESET)
         begin
           if(RESET||masterClear)
                   tempWordReg[requestReg[1:0]] <= 0; 
            else if(ldCurrWordTemp)
                 tempWordReg[requestReg[1:0]] = currWordReg[requestReg[1:0]];
            else if(decr)
                tempWordReg[requestReg[1:0]] = tempWordReg[requestReg[1:0]] - 16'b0000000000000001;
           if(tempWordReg[requestReg[1:0]] ==0)
             begin
              TC[requestReg[1:0]] = 1;
              tempWordReg[requestReg[1:0]] = 16'b1111111111111111;
             end
            else 
              tempWordReg[requestReg[1:0]] = tempWordReg[requestReg[1:0]];
             
          end
 

// Mode Register
// Programmed by the CPU

always_ff@(posedge CLK, posedge RESET)
          begin
          
          if(RESET||masterClear)
             modeReg[requestReg[1:0]] = 0;
          else if(enablemodeReg) 
              modeReg[requestReg[1:0]] = modeReg1[requestReg[1:0]];
          else if({Program,CS,IOR,IOW,ADDR_L} == MODEREGWRITE[requestReg[1:0]])
               modeReg[DB[1:0]] = DB[7:2];            
          else 
              modeReg[requestReg[1:0]] =  modeReg[requestReg[1:0]] ;
          end
               



// Command Register

always_ff@(posedge CLK, posedge RESET)
          begin
          
          if(RESET||masterClear)
             commandReg1 = 0;
          else if(enableCommandReg) 
              commandReg = commandReg1;
          else if({Program,CS,IOR,IOW,ADDR_L} == WRITECOMMANDREG)
               commandReg1 = DB;            
          else 
              commandReg =  commandReg;
          end
               


//Request Register

always_ff@(posedge CLK, posedge RESET)
          begin
          
          if(RESET||masterClear)
             requestReg1= 0;
          else if(enableRequestReg) 
              requestReg = requestReg1;
          else if({Program,CS,IOR,IOW,ADDR_L} == WRITEREQUESTREG)
               requestReg1 = DB;            
          else 
              requestReg=  requestReg ;
          end
               


// Mask Register

always_ff@(posedge CLK, posedge RESET)
          begin
          
          if(RESET||masterClear)
               maskReg1= 0;
          else if(enableMaskReg) 
               maskReg= maskReg1;
          else if({Program,CS,IOR,IOW,ADDR_L} == WRITESINGLEMASKREG)
              begin
               singleMask = 1;
               maskReg1[3:0] = DB[3:0];
             end  
          else if({Program,CS,IOR,IOW,ADDR_L} == WRITEALLMASKREG)
              begin 
               singleMask = 0;
               maskReg1[3:0] = DB[3:0];  
              end        
          else 
              maskReg = maskReg ;
          end
                  
                       
             
//Temporary Register

always_ff@(posedge CLK, posedge RESET)
          begin
          
          if(RESET||masterClear)
             tempReg= 0;
          else if(enableTempReg) 
              tempReg = tempReg1;
          else if({Program,CS,IOR,IOW,ADDR_L} == READTEMPREG)
               DB = tempReg;            
          else 
              tempReg =  tempReg ;
          end


//Status Register

always_ff@(posedge CLK,posedge RESET)
        begin

                 statusReg[0] = (TC[0]||~EOP)?1'b1:1'b0;
                 statusReg[1] = (TC[1]||~EOP)?1'b1:1'b0;
                 statusReg[2] = (TC[2]||~EOP)?1'b1:1'b0;
                 statusReg[3] = (TC[3]||~EOP)?1'b1:1'b0;  
                 statusReg[4] = DREQ[0]?1'b1:1'b0;  
                 statusReg[5] = DREQ[1]?1'b1:1'b0; 
                 statusReg[6] = DREQ[2]?1'b1:1'b0; 
                 statusReg[7] = DREQ[3]?1'b1:1'b0; 

          if(RESET||masterClear)
             statusReg = 0;
         else if(enableStatusReg)
             statusReg = statusReg;
          else if({Program,CS,IOR,IOW,ADDR_L} == READSTATUSREG);
             DB = statusReg;
                       
        end       
          
// CLEAR FlipFlop

always_ff@(posedge CLK, posedge RESET)
          begin
            if({Program,CS,IOR,IOW,ADDR_L} == CLEARFLIPFLOP)
                flipFlop = 1'b0;
             else
                flipFlop = 1'b1;
          end


//Master Clear

always_ff@(posedge CLK, posedge RESET)
          begin
            masterClear = 0;
            if({Program,CS,IOR,IOW,ADDR_L} == CLEARMASKREG)     
                       masterClear = 1;
              else
                       masterClear = masterClear;
            end

//Clear Mask Register

always_ff@(posedge CLK,posedge RESET)
         begin
           
          if({Program,CS,IOR,IOW,ADDR_L} == CLEARMASKREG)
                      maskReg = 0;
          else
                      maskReg = 1;

        end  

endmodule
           
