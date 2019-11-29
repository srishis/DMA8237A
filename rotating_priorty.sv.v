// Code your design here
module rotatingpriorty;
 logic clock , reset;
 logic [3:0] valid_DREQ;
 logic [3:0] encoderoutput;

enum {iIDLE = 0,
       iCH0 = 1,
	   iCH1 = 2,
	   iCH2 = 3,
	   iCH3 = 4} stateindex;
	  
enum logic[4:0] { IDLE = 5'b00001<<iIDLE,
                   CH0 = 5'b00001<<iCH0,
				   CH1 = 5'b00001<<iCH1,
				   CH2 = 5'b00001<<iCH2,
				   CH3 = 5'b00001<<iCH3 } state , nextstate;
				   
  always_ff@(posedge clock) begin
     if(!reset)
           state <= IDLE;
     else
        state <= nextstate;
	end
	
	always_comb begin
	   encoderoutput = '0;
	   
	   unique case(1'b1)
	   
	      state[IDLE] : encoderoutput = 4'b0000;
		  state[CH0] : encoderoutput = 4'b1000;
		  state[CH1] : encoderoutput = 4'b0100;
          state[CH2] : encoderoutput = 4'b0010;
		  state[CH3] : encoderoutput = 4'b0001;
		  
		  endcase
		  end
		  
		  always_comb begin
            
            valid_DREQ = 'b0000;
		  
		   unique case(1'b1)
		   
		     state[IDLE] :  begin 
								if (valid_DREQ[0]) 
									nextstate = CH0;
								else if (valid_DREQ[1])
									nextstate = CH1;
								else if(valid_DREQ[2])
									nextstate = CH2;
								else if(valid_DREQ[3])
									nextstate = CH3;
								else
									nextstate = IDLE;									 
							end		  
             state[CH0]	 : 	begin 
								if (valid_DREQ[1]) 
									nextstate = CH1;
								else if (valid_DREQ[2])
									nextstate = CH2;
								else if(valid_DREQ[3])
									nextstate = CH3;			
								else if(valid_DREQ[0])
								   nextstate = CH0;
								else
								  nextstate = IDLE;                                  
                            end 
             state[CH1] :	begin 
								if(valid_DREQ[2]) 
									nextstate = CH2;
								else if(valid_DREQ[3])
									nextstate = CH3;
								else if(valid_DREQ[0])
									nextstate = CH0;
								 else if(valid_DREQ[1])
                                     nextstate = CH1;
                                 else
                                     nextstate =  IDLE;                                									
                   			end
               state[CH2] : begin
                                 if(valid_DREQ[3])
                                      nextstate = CH3;
                              else if(valid_DREQ[0])
                                      nextstate = CH0;
                              else if(valid_DREQ[1])
                                      nextstate = CH1;
                              else if(valid_DREQ[2])
                                      nextstate = CH2;
                               else
                                    nextstate = IDLE;
                            end
                state[CH3]: begin 
                                 if (valid_DREQ[3]) 
								   nextstate = CH3;
								 else 
                                   nextstate = IDLE;
						    end
                 endcase
          end
endmodule
				 
				   
       