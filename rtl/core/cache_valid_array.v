// 
// Copyright 2011-2012 Jeff Bush
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 

`include "defines.v"

//
// Array of cache valid bits.  Unlike sram_1r1w, this allows clearing the
// contents of the memory with the reset signal, which is necessary for
// proper operation of the cache.
//

module cache_valid_array
	#(parameter 	NUM_SETS = 32,
	parameter		ADDR_WIDTH = `CLOG2(NUM_SETS))
	
	(input					clk,
	input					reset,
	
	input					rd_enable,
	input[ADDR_WIDTH - 1:0] rd_addr,
	output reg				rd_is_valid,
	input[ADDR_WIDTH - 1:0] wr_addr,
	input					wr_enable,
	input					wr_is_valid);

	reg data[0:NUM_SETS - 1];

	always @(posedge clk, posedge reset)	
	begin : update
		integer i;
		
		if (reset)
		begin
`ifndef VERILATOR	
			// Disable for verilator, which chokes on the non-blocking assignments
			for (i = 0; i < NUM_SETS; i = i + 1)
				data[i] <= 0;
				
			rd_is_valid <= 0;
`endif
		end
		else
		begin
			if (rd_enable)
			begin
				if (wr_enable && rd_addr == wr_addr)
					rd_is_valid <= wr_is_valid;
				else
					rd_is_valid <= data[rd_addr];
			end

			if (wr_enable)
				data[wr_addr] <= wr_is_valid;
		end	
	end
endmodule

	
	
