`include "async/async.v"
`include "RepeatNot2.v"

module something #(parameter il = 64, parameter ol = 64, parameter cs = 8)
  (input [il-1:0] intext, output [ol-1:0] outtext);

  localparam col_size = cs;

  localparam N = 32;


  RepeatNot2 #(.N(N)) main (a_i2, outtext[0], outtext[col_size +: N], intext[63]);
  assign a_i2 = a_i1 & intext[0];
  sink sinker (outtext[0], a_i1);

endmodule
