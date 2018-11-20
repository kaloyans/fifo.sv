`include "dual_port_mem.sv"
module fifo(
      		in_data,                
		w_req, 
		r_req,
		reset,
		clock,             
		full, 
		empty,            
		out_data
          );
	input in_data;
	input w_req;
	input r_req;
	input clock;
	input reset;
	output out_data;
	output full;
	output empty;

	reg [5:0] w_ptr;
  	reg [5:0] r_ptr;
	reg [15:0] out_data;
		
assign full = w_ptr [4:0] == r_ptr [4:0] && w_ptr[5] != r_ptr[5];
assign empty = w_ptr == r_ptr;
		// assign empty = w_ptr [4:0] == r_ptr [4:0] && w_ptr[5] == r_ptr[5];

always @ (posedge clock or posedge reset)
	begin 
		if (reset) begin
			w_ptr <= 0;
			end else if (w_req && !full) begin
			w_ptr <= w_ptr + 1;
			end
		end

always @ (posedge clock or posedge reset)
	begin 
		if (reset) begin
			r_ptr <= 0;
		end else if (r_req && !empty) begin
			r_ptr <= r_ptr + 1;
		end
	end

dual_port_mem memD(
		.wd_a(in_data),
		.addr_a(w_ptr [4:0]),
		.addr_b(r_ptr [4:0]),
		.wen_a(w_req),
		.rd_b(out_data)
		  );
endmodule             //  fifo




