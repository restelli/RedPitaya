////////////////////////////////////////////////////////////////////////////////
// AXI4-Stream multiplexer
// Authors: Iztok Jeras
// (c) Red Pitaya  http://www.redpitaya.com
////////////////////////////////////////////////////////////////////////////////

module axi4_stream_mux #(
  // select parameters
  int unsigned SN = 2,          // select number of ports
  int unsigned SW = $clog2(SN), // select signal width
  // data stream parameters
  int unsigned DW = 1,
  type DAT_T = logic [8-1:0]
)(
  // control
  input  logic [SW-1:0] sel,  // select
  // streams
  axi4_stream_if.d sti [SN-1:0],  // input
  axi4_stream_if.s sto            // output
);

logic [SN-1:0] tvalid;
DAT_T [SN-1:0] tdata ;
logic [SN-1:0] tkeep ;
logic [SN-1:0] tlast ;

generate
for (genvar i=0; i<SN; i++) begin: for_str

assign tvalid[i] = sti[i].TVALID;
assign tdata [i] = sti[i].TDATA ;
assign tkeep [i] = sti[i].TKEEP ;
assign tlast [i] = sti[i].TLAST ;

end: for_str
endgenerate

assign sto.TVALID = tvalid[sel];
assign sto.TDATA  = tdata [sel];
assign sto.TKEEP  = tkeep [sel];
assign sto.TLAST  = tlast [sel];

assign sti.TREADY = SN'(1'b0) << sel;

endmodule: axi4_stream_mux
