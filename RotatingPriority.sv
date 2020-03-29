// Hierarchical 2-bit priority selectors to be used for 4 - bit Rotating priority

// 2 bit priority selectors
module ps2(req, en, ack, req_up, clk, rst);
  
  input logic en, clk, rst;
  input logic [1:0] req;
  output logic req_up;
  output logic [1:0] ack;
  
  always_ff@(posedge clk) begin
    if(rst || ~en)  begin ack <= '0; req_up <= '0; end
    else if(en)
        priority case(1'b1) // reverse case
          req[1] : begin ack <= 2'b10; req_up <= 1'b1; end  
          req[0] : begin ack <= 2'b01; req_up <= 1'b1; end
        endcase
  end
    
endmodule


module rps4(req, en, ack, req_up, clk, rst, count);
  input logic en, clk, rst;
  input logic [3:0] req;
  output logic req_up;
  output logic [3:0] ack;

  ps2 LOW (.*, .req(req[1:0]), .ack(ack[1:0]));
  ps2 HIGH (.*, .req(req[3:2]), .ack(ack3:2]));
  ps2 TOP (.*, .req(req[1:0]), .ack(ack[1:0]));
endmodule
