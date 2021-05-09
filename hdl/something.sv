`include "async/async.sv"
`include "RepeatNot2.sv"

module something #(parameter il = 64, parameter ol = 64, parameter cs = 8)
  (input [il-1:0] intext, output [ol-1:0] outtext);

  localparam col_size = cs;

  localparam N = 6;

  // wire a_i1, a_i2;
  //
  // RepeatNot2 #(.N(N)) main (a_i2, outtext[0], outtext[col_size +: N], intext[63]);
  // assign a_i2 = a_i1 & intext[0];
  // sink sinker (outtext[0], a_i1);

  wire r_o, a_o;
  wire [N-1:0] d_o;

  a_xor #(.N(N)) main (
    intext[0], outtext[0], intext[cs +: N],
    intext[cs*2 + 0], outtext[cs*2 + 0], intext[cs*3 +: N],
    // r_o, a_o, d_o,
    outtext[cs*4 + 0], intext[cs*4 + 0], outtext[cs*5 +: N],
    intext[63]
    );
  //
  // hlatch #(.N(N)) main2 (
  //   r_o, a_o, d_o,
  //   outtext[cs*4 + 0], intext[cs*4 + 0], outtext[cs*5 +: N],
  //   rst
  //   );

  // mullerc main (intext[0], intext[1], outtext[0], intext[63]);

endmodule
