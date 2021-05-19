`include "async/async.sv"

module something #(parameter il = 64, parameter ol = 64, parameter cs = 8)
  (input [il-1:0] intext, output [ol-1:0] outtext);

    localparam col_size = cs;

    // wire req_i1, ack_i1;
    // wire req_i2, ack_i2;

    // source main_source (
    //   req_i1, ack_i1
    //   );

    // hlatch #(.RhandshakeVal(1'b1)) main (
    //   intext[0], outtext[1], intext[2],
    //   // req_i1, ack_i1, intext[2],
    //   // outtext[0], intext[1], outtext[2],
    //   req_i2, ack_i2, outtext[2],
    //   intext[63]);
    //
    // sink main_sink (
    //   req_i2, ack_i2
    //   );


    wire req_i1, ack_i1, dat_i1;
    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main0 (
      intext[0], outtext[0], intext[1],
      req_i1, ack_i1, dat_i1,
      intext[63]);

    wire req_i2, ack_i2, dat_i2;
    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main1 (
      intext[col_size+0], outtext[col_size+0], intext[col_size+1],

      // req_i1, ack_i1, dat_i1,
      req_i2, ack_i2, dat_i2,
      intext[63]);

    wire req_i12_3, ack_i12_3, dat_i12_3;

    // combine join01_2 (
    //   req_i1, ack_i1,
    //   req_i2, ack_i2,
    //   req_i12_3, ack_i12_3,
    //   intext[63]
    //   );
    //
    // assign dat_i12_3 = dat_i2;

    // merge merge01_2 (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   req_i12_3, ack_i12_3, dat_i12_3,
    //   rst
    //   );

    // merge2 merge01_2 (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   req_i12_3, ack_i12_3, dat_i12_3,
    //   intext[63]
    //   );

    // arbiter merge01_2 (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   req_i12_3, ack_i12_3, dat_i12_3,
    //   intext[63]
    //   );

    // mux mux01_2 (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   intext[4], intext[5], outtext[4],
    //   req_i12_3, ack_i12_3, dat_i12_3,
    //   intext[63]
    //   );

    // mux2 mux01_2 (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   intext[4], intext[5], outtext[4],
    //   req_i12_3, ack_i12_3, dat_i12_3,
    //   intext[63]
    //   );

    wire req_i3, ack_i3, dat_i3;
    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main2 (
      req_i12_3, ack_i12_3, dat_i12_3,
      req_i3, ack_i3, dat_i3,
      intext[63]);

    wire req_i4, ack_i4, dat_i4;
    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main3 (
      req_i3, ack_i3, dat_i3,
      req_i4, ack_i4, dat_i4,
      intext[63]);

    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main4 (
      req_i4, ack_i4, dat_i4,
      req_i4_56, ack_i4_56, dat_i4_56,
      intext[63]);

    wire req_i4_56, ack_i4_56, dat_i4_56;

    // split fork4_56 (
    //   req_i4_56, ack_i4_56,
    //   req_i5, ack_i5,
    //   req_i6, ack_i6,
    //   intext[63]
    //   );
    //
    // assign dat_i5 = dat_i4_56;
    // assign dat_i6 = dat_i4_56;

    // demux demux4_56 (
    //   req_i4_56, ack_i4_56, dat_i4_56,
    //   intext[col_size + 4], intext[col_size + 5], outtext[col_size + 4],
    //   req_i5, ack_i5, dat_i5,
    //   req_i6, ack_i6, dat_i6,
    //   intext[63]
    //   );

    // demux2 demux4_56 (
    //   req_i4_56, ack_i4_56, dat_i4_56,
    //   intext[col_size + 4], intext[col_size + 5], outtext[col_size + 4],
    //   req_i5, ack_i5, dat_i5,
    //   req_i6, ack_i6, dat_i6,
    //   intext[63]
    //   );

    // cond_sink csink4_5 (
    //   req_i4_56, ack_i4_56, dat_i4_56,
    //   intext[col_size + 4], intext[col_size + 5], outtext[col_size + 4],
    //   req_i5, ack_i5, dat_i5,
    //   intext[63]
    //   );

    // cond_sink2 csink4_5 (
    //   req_i4_56, ack_i4_56, dat_i4_56,
    //   intext[col_size + 4], intext[col_size + 5], outtext[col_size + 4],
    //   req_i5, ack_i5, dat_i5,
    //   intext[63]
    //   );

    // swap swappy (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   intext[4], intext[5], outtext[4],
    //   req_i5, ack_i5, dat_i5,
    //   req_i6, ack_i6, dat_i6,
    //   intext[63]);

    // swap2 swappy (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   intext[4], intext[5], outtext[4],
    //   req_i5, ack_i5, dat_i5,
    //   req_i6, ack_i6, dat_i6,
    //   intext[63]);

    // swap_sink swappy (
    //   req_i1, ack_i1, dat_i1,
    //   req_i2, ack_i2, dat_i2,
    //   intext[4], intext[5], outtext[4],
    //   req_i5, ack_i5, dat_i5,
    //   intext[63]);

    swap_sink2 swappy (
      req_i1, ack_i1, dat_i1,
      req_i2, ack_i2, dat_i2,
      intext[4], intext[5], outtext[4],
      req_i5, ack_i5, dat_i5,
      intext[63]);

    // assign {req_i5, dat_i5, req_i6, dat_i6} = {req_i1, dat_i1, req_i2, dat_i2};
    // assign {ack_i1, ack_i2} = {ack_i5, ack_i6};

    wire req_i5, ack_i5, dat_i5;
    wire req_i6, ack_i6, dat_i6;
    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main5 (
      req_i5, ack_i5, dat_i5,
      // req_i6, ack_i6, dat_i6,
      outtext[col_size*2+0], intext[col_size*2+0], outtext[col_size*2+1],
      intext[63]);

    hlatch #(.RhandshakeVal(1'b0), .RdataVal(1'b0)) main6 (
      req_i6, ack_i6, dat_i6,
      outtext[col_size*3+0], intext[col_size*3+0], outtext[col_size*3+1],
      intext[63]);

endmodule
