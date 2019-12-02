//-------------------------------------------------
// Priority encoder and Rotating priority logic
//-------------------------------------------------

module priorityTop(clk, dma_if.DUT dif, commandReg, maskReg, requestReg);

	import DmaPackage::*;
	input [7:0] commandReg;
	input [3:0] maskReg, requestReg;

			
	
	logic validDREQ;
	logic rotatingPriority, enFixedPriorityEncoder, enRotatingPriorityEncoder;
	logic [7:0] chPriorityReg; 
	 
// decoding registers for valid DREQ

	// decode Request register	
	always_ff@(posedge clk) begin
		if(requestReg[1:0] == 2'b00 && requestReg[2]) 	       CH0_SEL <= 1;
		else if(requestReg[1:0] == 2'b00 && !requestReg[2]     CH0_SEL <= 0; 
		if(requestReg[1:0] == 2'b01 && requestReg[2]) 	       CH1_SEL <= 1;
		else if(requestReg[1:0] == 2'b01 && !requestReg[2]     CH1_SEL <= 0; 
		if(requestReg[1:0] == 2'b10 && requestReg[2])          CH2_SEL <= 1;
		else if(requestReg[1:0] == 2'b10 && !requestReg[2]     CH2_SEL <= 0; 
		if(requestReg[1:0] == 2'b11 && requestReg[2])          CH3_SEL <= 1;
		else if(requestReg[1:0] == 2'b11 && !requestReg[2]     CH3_SEL <= 0; 
	end

	// decode Mask register	
	always_ff@(posedge clk) begin
		if(maskReg[1:0] == 2'b00 && maskReg[2]) 	 CH0_MASK <= 1;
		else if(maskReg[1:0] == 2'b00 && !maskReg[2]     CH0_MASK <= 0; 
		if(maskReg[1:0] == 2'b01 && maskReg[2]) 	 CH1_MASK <= 1;
		else if(maskReg[1:0] == 2'b01 && !maskReg[2]     CH1_MASK <= 0; 
		if(maskReg[1:0] == 2'b10 && maskReg[2])          CH2_MASK <= 1;
		else if(maskReg[1:0] == 2'b10 && !maskReg[2]     CH2_MASK <= 0; 
		if(maskReg[1:0] == 2'b11 && maskReg[2])          CH3_MASK <= 1;
		else if(maskReg[1:0] == 2'b11 && !maskReg[2]     CH3_MASK <= 0; 
	end

	// setting priority scheme
	always_ff@(posedge clk) begin
		if(commandReg[4]) rotatingPriority <= 1;
		else		  rotatingPriority <= 0;
	end

	// decode Command register	
	always_ff@(posedge clk) begin
		
		// DREQ polarity
		if(!commandReg[6] && CH0_SEL && !CH0_MASK)     DREQ0_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH0_SEL && !CH0_MASK) DREQ0_ACTIVE_LOW <= 1;
		else begin DREQ0_ACTIVE_HIGH <= 0; DREQ0_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[6] && CH1_SEL && !CH1_MASK)     DREQ1_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH1_SEL && !CH1_MASK) DREQ1_ACTIVE_LOW <= 1;
		else begin DREQ1_ACTIVE_HIGH <= 0; DREQ1_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[6] && CH2_SEL && !CH2_MASK)     DREQ2_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH2_SEL && !CH2_MASK) DREQ2_ACTIVE_LOW <= 1;
		else begin DREQ2_ACTIVE_HIGH <= 0; DREQ2_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[6] && CH3_SEL && !CH3_MASK)     DREQ3_ACTIVE_HIGH <= 1;
		else if(commandReg[6] && CH3_SEL && !CH3_MASK) DREQ3_ACTIVE_LOW <= 1;
		else begin DREQ3_ACTIVE_HIGH <= 0; DREQ3_ACTIVE_LOW <= 0; end  		   		

		// DACK polarity
		if(!commandReg[7] && CH0_SEL && !CH0_MASK)     DACK0_ACTIVE_HIGH <= 1;
		else if(commandReg[7] && CH0_SEL && !CH0_MASK) DACK0_ACTIVE_LOW <= 1;
		else begin DACK0_ACTIVE_HIGH <= 0; DACK0_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[7] && CH1_SEL && !CH1_MASK)     DACK1_ACTIVE_HIGH <= 1;
		else if(commandReg[7] && CH1_SEL && !CH1_MASK) DACK1_ACTIVE_LOW <= 1;
		else begin DACK1_ACTIVE_HIGH <= 0; DACK1_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[7] && CH2_SEL && !CH2_MASK)     DACK2_ACTIVE_HIGH <= 1;
		else if(commandReg[7] && CH2_SEL && !CH2_MASK) DACK2_ACTIVE_LOW <= 1;
		else begin DACK2_ACTIVE_HIGH <= 0; DACK2_ACTIVE_LOW <= 0; end  		   		

		if(!commandReg[7] && CH3_SEL && !CH3_MASK)     DACK3_ACTIVE_HIGH <= 1;
		else if(commandReg[7] && CH3_SEL && !CH3_MASK) DACK3_ACTIVE_LOW <= 1;
		else begin DACK3_ACTIVE_HIGH <= 0; DACK3_ACTIVE_LOW <= 0; end  
		
	end
	
	// setting valid DREQ
	always_ff@(posedge clk) begin
		if(DREQ0_ACTIVE_HIGH || DREQ0_ACTIVE_LOW) VALID_DREQ0 <= 1;
		else					  VALID_DREQ0 <= 0;	
		if(DREQ1_ACTIVE_HIGH || DREQ1_ACTIVE_LOW) VALID_DREQ1 <= 1;
		else					  VALID_DREQ1 <= 0;	
		if(DREQ2_ACTIVE_HIGH || DREQ2_ACTIVE_LOW) VALID_DREQ2 <= 1;
		else					  VALID_DREQ2 <= 0;	
		if(DREQ3_ACTIVE_HIGH || DREQ3_ACTIVE_LOW) VALID_DREQ3 <= 1;
		else					  VALID_DREQ3 <= 0;	
	end

	// setting DACK output if valid DREQ based on polarity
	// TODO: update DACK based on output from Priority Encoder
	always_ff@(posedge clk) begin
		if(cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_HIGH) 	   dif.DACK[0] <= 1;
		else if(cif.validDACK && VALID_DACK0 && DACK0_ACTIVE_LOW)  dif.DACK[0] <= 0;
		if(cif.validDACK && VALID_DACK1 && DACK1_ACTIVE_HIGH) 	   dif.DACK[1] <= 1;
		else if(cif.validDACK && VALID_DACK1 && DACK1_ACTIVE_LOW)  dif.DACK[1] <= 0;
		if(cif.validDACK && VALID_DACK2 && DACK2_ACTIVE_HIGH) 	   dif.DACK[2] <= 1;
		else if(cif.validDACK && VALID_DACK2 && DACK2_ACTIVE_LOW)  dif.DACK[2] <= 0;
		if(cif.validDACK && VALID_DACK3 && DACK3_ACTIVE_HIGH) 	   dif.DACK[3] <= 1;
		else if(cif.validDACK && VALID_DACK3 && DACK3_ACTIVE_LOW)  dif.DACK[3] <= 0;
	end
	
	// check for any valid requests on DREQ lines	
	always_ff@(posedge clk) begin
		if(VALID_DREQ0 || VALID_DREQ1 || VALID_DREQ2 || VALID_DREQ3) validDREQ <= 1;
		else						       	     validDREQ <= 0;
	end

	always_comb dif.HRQ = 	cif.hrq;
	// setting HRQ output if valid DREQ based on polarity and select priority encoding
	//TODO: how many encoders?
	always_ff@(posedge clk) begin
		//if(validDREQ && HLDA)	
		//if(validDREQ)	
		//dif.HRQ <= 1;
			if(validDREQ && rotatingPriority) 			enRotatingPriorityEncoder <= 1; 
			else if(validDREQ && !rotatingPriority)		        enFixedPriorityEncoder <= 1;
	//else	dif.HRQ <= 0;
	end
	
	// Fixed priority encoder
	// TODO: verify priority encoder
	always_comb begin
		if(enFixedPriorityEncoder)
			priority case(1'b1) // reverse case
			 //VALID_DREQ0  :  encoderOut <= 4'b0001; 	 
			 //VALID_DREQ1  :  encoderOut <= 4'b0010; 	 
			 //VALID_DREQ2  :  encoderOut <= 4'b0100; 	 
			 //VALID_DREQ3  :  encoderOut <= 4'b1000; 	 

			 VALID_DREQ0  : encoderOut = VALID_DREQ0; 	 
			 VALID_DREQ1  : encoderOut = VALID_DREQ1; 	 
			 VALID_DREQ2  : encoderOut = VALID_DREQ2; 	 
			 VALID_DREQ3  : encoderOut = VALID_DREQ3; 	 
			endcase
		else if(enRotatingPriorityEncoder)
			if(CH0_PRIORITY == 2'b11) encoderOut = VALID_DREQ0;
			else if(CH1_PRIORITY == 2'b11) encoderOut = VALID_DREQ0;
			else if(CH2_PRIORITY == 2'b11) encoderOut = VALID_DREQ0;
			else if(CH3_PRIORITY == 2'b11) encoderOut = VALID_DREQ0;
	end	

	always_comb begin
		if(encoderOut == VALID_DREQ0) VALID_DACK0 = 1'b1;
		else if(encoderOut == VALID_DREQ1) VALID_DACK1 = 1'b1;
		else if(encoderOut == VALID_DREQ2) VALID_DACK2 = 1'b1;
		else if(encoderOut == VALID_DREQ3) VALID_DACK3 = 1'b1;
	end                                                     

	
	// TODO: Rotating priority logic 
	always_ff@(posedge dma_if.CLK) begin
		if(dma_if.RESET) {CH0_PRIORITY, CH1_PRIORITY, CH2_PRIORITY, CH3_PRIORITY} <= {8'b11100100}; //3,2,1,0
		else {CH0_PRIORITY, CH1_PRIORITY, CH2_PRIORITY, CH3_PRIORITY} <= {NEXT_CH0_PRIORITY, NEXT_CH1_PRIORITY, NEXT_CH2_PRIORITY, NEXT_CH3_PRIORITY};

	always_ff@(posedge dma_if.CLK) begin
		if(VALID_DREQ0)      begin NEXT_CH0_PRIORITY <= 2'b00; NEXT_CH1_PRIORITY <= CH1_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end
		else if(VALID_DREQ1) begin NEXT_CH1_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end
		else if(VALID_DREQ2) begin NEXT_CH2_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end
		else if(VALID_DREQ3) begin NEXT_CH3_PRIORITY <= 2'b00; NEXT_CH0_PRIORITY <= CH0_PRIORITY + 1'b1; NEXT_CH2_PRIORITY <=  CH2_PRIORITY + 1'b1; NEXT_CH3_PRIORITY <=  CH3_PRIORITY + 1'b1; end
	end

		

	



endmodule



