module DmaPriority(dma_if.PR dif, DmaRegIf.PR rif); 

	
	logic validDREQ; 
	logic [3:0] pencoderOut;
	logic enFixedPriority, enRotatingPriority;
	 
// decoding registers for valid DREQ

	// decode Request register	
	always_comb begin
		if(rif.requestReg[1:0] == 2'b00 && rif.requestReg[2]) 	        cif.CH0_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b00 && !rif.requestReg[2])     cif.CH0_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b01 && rif.requestReg[2]) 	        cif.CH1_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b01 && !rif.requestReg[2])     cif.CH1_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b10 && rif.requestReg[2])           cif.CH2_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b10 && !rif.requestReg[2])     cif.CH2_SEL = 0; 
		if(rif.requestReg[1:0] == 2'b11 && rif.requestReg[2])           cif.CH3_SEL = 1;
		else if(rif.requestReg[1:0] == 2'b11 && !rif.requestReg[2])     cif.CH3_SEL = 0; 
	end

	// decode Mask register	
	always_comb begin
		if(rif.maskReg[1:0] == 2'b00 && rif.maskReg[2]) 	 cif.CH0_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b00 && !rif.maskReg[2])    cif.CH0_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b01 && rif.maskReg[2]) 	 cif.CH1_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b01 && !rif.maskReg[2])    cif.CH1_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b10 && rif.maskReg[2])          cif.CH2_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b10 && !rif.maskReg[2])    cif.CH2_MASK = 0; 
		if(rif.maskReg[1:0] == 2'b11 && rif.maskReg[2])          cif.CH3_MASK = 1;
		else if(rif.maskReg[1:0] == 2'b11 && !rif.maskReg[2])    cif.CH3_MASK = 0; 
	end

	
	// decode Command register	
	always_comb begin
		
		// DREQ polarity
		if(!rif.commandReg[6] && cif.CH0_SEL && !cif.CH0_MASK)     cif.DREQ0_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && cif.CH0_SEL && !cif.CH0_MASK) cif.DREQ0_ACTIVE_LOW = 1;
		else begin cif.DREQ0_ACTIVE_HIGH = 0; cif.DREQ0_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && cif.CH1_SEL && !cif.CH1_MASK)     cif.DREQ1_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && cif.CH1_SEL && !cif.CH1_MASK) cif.DREQ1_ACTIVE_LOW = 1;
		else begin cif.DREQ1_ACTIVE_HIGH = 0; cif.DREQ1_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && cif.CH2_SEL && !cif.CH2_MASK)     cif.DREQ2_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && cif.CH2_SEL && !cif.CH2_MASK) cif.DREQ2_ACTIVE_LOW = 1;
		else begin cif.DREQ2_ACTIVE_HIGH = 0; cif.DREQ2_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[6] && cif.CH3_SEL && !cif.CH3_MASK)     cif.DREQ3_ACTIVE_HIGH = 1;
		else if(rif.commandReg[6] && cif.CH3_SEL && !cif.CH3_MASK) cif.DREQ3_ACTIVE_LOW = 1;
		else begin cif.DREQ3_ACTIVE_HIGH = 0; cif.DREQ3_ACTIVE_LOW = 0; end  		   		

		// DACK polarity
		if(!rif.commandReg[7] && cif.CH0_SEL && !cif.CH0_MASK)     cif.DACK0_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && cif.CH0_SEL && !cif.CH0_MASK) cif.DACK0_ACTIVE_LOW = 1;
		else begin cif.DACK0_ACTIVE_HIGH = 0; cif.DACK0_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && cif.CH1_SEL && !cif.CH1_MASK)     cif.DACK1_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && cif.CH1_SEL && !cif.CH1_MASK) cif.DACK1_ACTIVE_LOW = 1;
		else begin cif.DACK1_ACTIVE_HIGH = 0; cif.DACK1_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && cif.CH2_SEL && !cif.CH2_MASK)     cif.DACK2_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && cif.CH2_SEL && !cif.CH2_MASK) cif.DACK2_ACTIVE_LOW = 1;
		else begin cif.DACK2_ACTIVE_HIGH = 0; cif.DACK2_ACTIVE_LOW = 0; end  		   		

		if(!rif.commandReg[7] && cif.CH3_SEL && !cif.CH3_MASK)     cif.DACK3_ACTIVE_HIGH = 1;
		else if(rif.commandReg[7] && cif.CH3_SEL && !cif.CH3_MASK) cif.DACK3_ACTIVE_LOW = 1;
		else begin cif.DACK3_ACTIVE_HIGH = 0; cif.DACK3_ACTIVE_LOW = 0; end  
		
	end
	
	// Valid DREQ
	always_ff@(posedge dif.CLK) begin
		if((cif.DREQ0_ACTIVE_HIGH && dif.DREQ[0]) || (cif.DREQ0_ACTIVE_LOW  && !dif.DREQ[0]))   cif.VALID_DREQ0 <= 1;
		else					  					        cif.VALID_DREQ0 <= 0;	
		if((cif.DREQ0_ACTIVE_HIGH && dif.DREQ[1]) || (cif.DREQ0_ACTIVE_LOW  && !dif.DREQ[1]))   cif.VALID_DREQ1 <= 1;
		else					 				                cif.VALID_DREQ1 <= 0;	
		if((cif.DREQ0_ACTIVE_HIGH && dif.DREQ[2]) || (cif.DREQ0_ACTIVE_LOW  && !dif.DREQ[2]))   cif.VALID_DREQ2 <= 1;
		else					       					        cif.VALID_DREQ2 <= 0;	
		if((cif.DREQ0_ACTIVE_HIGH && dif.DREQ[3]) || (cif.DREQ0_ACTIVE_LOW  && !dif.DREQ[3]))   cif.VALID_DREQ3 <= 1;
		else					  					        cif.VALID_DREQ3 <= 0;	
	end

	// DACK output 
	always_ff@(posedge dif.CLK) begin
		if(cif.validDACK && cif.VALID_DACK0 && cif.DACK0_ACTIVE_HIGH) 	    	dif.DACK[0] <= 1;
		else if(cif.validDACK && cif.VALID_DACK0 && cif.DACK0_ACTIVE_LOW)       dif.DACK[0] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK0 && cif.DACK0_ACTIVE_HIGH)     dif.DACK[0] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK0 && cif.DACK0_ACTIVE_LOW)      dif.DACK[0] <= 1;

		if(cif.validDACK && cif.VALID_DACK1 && cif.DACK1_ACTIVE_HIGH) 	    	dif.DACK[1] <= 1;
		else if(cif.validDACK && cif.VALID_DACK1 && cif.DACK1_ACTIVE_LOW)       dif.DACK[1] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK1 && cif.DACK0_ACTIVE_HIGH)     dif.DACK[1] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK1 && cif.DACK0_ACTIVE_LOW)      dif.DACK[1] <= 1;

		if(cif.validDACK && cif.VALID_DACK2 && cif.DACK2_ACTIVE_HIGH) 	    	dif.DACK[2] <= 1;
		else if(cif.validDACK && cif.VALID_DACK2 && cif.DACK2_ACTIVE_LOW)       dif.DACK[2] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK2 && cif.DACK0_ACTIVE_HIGH)     dif.DACK[2] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK2 && cif.DACK0_ACTIVE_LOW)      dif.DACK[2] <= 1;

		if(cif.validDACK && cif.VALID_DACK3 && cif.DACK3_ACTIVE_HIGH) 	    	dif.DACK[3] <= 1;
		else if(cif.validDACK && cif.VALID_DACK3 && cif.DACK3_ACTIVE_LOW)       dif.DACK[3] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK3 && cif.DACK0_ACTIVE_HIGH)     dif.DACK[3] <= 0;
		else if(!cif.validDACK && cif.VALID_DACK3 && cif.DACK0_ACTIVE_LOW)      dif.DACK[3] <= 1;
	end
	
	// check for any valid requests on DREQ lines	
	always_comb begin
		if(cif.VALID_DREQ0 || cif.VALID_DREQ1 || cif.VALID_DREQ2 || cif.VALID_DREQ3) validDREQ = 1;
		else						       	                     validDREQ = 0;
	end

	// HRQ output
	always_comb dif.HRQ = cif.hrq;

	// select priority encoding
	always_comb begin
		if(validDREQ && rif.commandReg[4]) 	      enRotatingPriority <= 1; 
		else if(validDREQ && !rif.commandReg[4])  enFixedPriority <= 1;
	end
	
	// priority encoder
	always_comb begin
		pencoderOut = '0;
		if(enFixedPriority)
			priority case(1'b1) // reverse case
			 cif.VALID_DREQ0  : pencoderOut = 4'b0001; 	 
			 cif.VALID_DREQ1  : pencoderOut = 4'b0010; 	 
			 cif.VALID_DREQ2  : pencoderOut = 4'b0100; 	 
			 cif.VALID_DREQ3  : pencoderOut = 4'b1000; 	 
			endcase

		else if(enRotatingPriority)
			if(cif.CH0_PRIORITY == 2'b11) 	    pencoderOut = 4'b0001;
			else if(cif.CH1_PRIORITY == 2'b11)  pencoderOut = 4'b0010;
			else if(cif.CH2_PRIORITY == 2'b11)  pencoderOut = 4'b0100;
			else if(cif.CH3_PRIORITY == 2'b11)  pencoderOut = 4'b1000;
	end	

	always_comb begin
		if(pencoderOut == 4'b0001)      begin cif.VALID_DACK0 = 1'b1; cif.VALID_DACK1 = 1'b0; cif.VALID_DACK2 = 1'b0; cif.VALID_DACK3 = 1'b0; end
		else if(pencoderOut == 4'b0010) begin cif.VALID_DACK1 = 1'b1; cif.VALID_DACK2 = 1'b0; cif.VALID_DACK3 = 1'b0; cif.VALID_DACK0 = 1'b0; end
		else if(pencoderOut == 4'b0100) begin cif.VALID_DACK2 = 1'b1; cif.VALID_DACK3 = 1'b0; cif.VALID_DACK0 = 1'b0; cif.VALID_DACK0 = 1'b0; end
		else if(pencoderOut == 4'b1000) begin cif.VALID_DACK3 = 1'b1; cif.VALID_DACK0 = 1'b0; cif.VALID_DACK1 = 1'b0; cif.VALID_DACK2 = 1'b0; end
	end                                                     

	
	// Rotating priority logic 
	always_ff@(posedge dif.CLK) begin
		if(dif.RESET) {cif.CH0_PRIORITY, cif.CH1_PRIORITY, cif.CH2_PRIORITY, cif.CH3_PRIORITY} <= {8'b11100100}; // by default cif.CH0 - highest and cif.CH3 - lowest priority
		else {cif.CH0_PRIORITY, cif.CH1_PRIORITY, cif.CH2_PRIORITY, cif.CH3_PRIORITY} <= {cif.NEXT_CH0_PRIORITY, cif.NEXT_CH1_PRIORITY, cif.NEXT_CH2_PRIORITY, cif.NEXT_CH3_PRIORITY};
	end

	always_ff@(posedge dif.CLK) begin
		if(cif.VALID_DREQ0)      begin cif.NEXT_CH0_PRIORITY <= 2'b00; cif.NEXT_CH1_PRIORITY <= cif.CH1_PRIORITY + 1'b1; cif.NEXT_CH2_PRIORITY <=  cif.CH2_PRIORITY + 1'b1; cif.NEXT_CH3_PRIORITY <=  cif.CH3_PRIORITY + 1'b1; end
		else if(cif.VALID_DREQ1) begin cif.NEXT_CH1_PRIORITY <= 2'b00; cif.NEXT_CH0_PRIORITY <= cif.CH0_PRIORITY + 1'b1; cif.NEXT_CH2_PRIORITY <=  cif.CH2_PRIORITY + 1'b1; cif.NEXT_CH3_PRIORITY <=  cif.CH3_PRIORITY + 1'b1; end
		else if(cif.VALID_DREQ2) begin cif.NEXT_CH2_PRIORITY <= 2'b00; cif.NEXT_CH0_PRIORITY <= cif.CH0_PRIORITY + 1'b1; cif.NEXT_CH2_PRIORITY <=  cif.CH2_PRIORITY + 1'b1; cif.NEXT_CH3_PRIORITY <=  cif.CH3_PRIORITY + 1'b1; end
		else if(cif.VALID_DREQ3) begin cif.NEXT_CH3_PRIORITY <= 2'b00; cif.NEXT_CH0_PRIORITY <= cif.CH0_PRIORITY + 1'b1; cif.NEXT_CH2_PRIORITY <=  cif.CH2_PRIORITY + 1'b1; cif.NEXT_CH3_PRIORITY <=  cif.CH3_PRIORITY + 1'b1; end
	end

		

endmodule
