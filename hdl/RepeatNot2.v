`include "async/async.v"

module RepeatNot2 #(
  parameter N = 8
  ) (
  input A_i,
  output R_o,
  output [N-1:0] D_o,
  input rst);

  wire s0;
  wire s1;
  wire [N-1:0] s2;
  wire s3;
  wire s4;
  wire [N-1:0] s5;
  wire s6;
  wire s7;
  wire [N-1:0] s8;
  wire s9;
  wire s10;
  wire [N-1:0] s11;
  wire s12;
  wire s13;
  wire s14;
  wire [N-1:0] s15;
  wire s16;
  wire s17;
  wire [N-1:0] s18;
  // H6
  hlatch #(.N(N)) hlatch_i0 (
    .r_i( s17 ),
    .a_o( A_i ),
    .d_i( s18 ),
    .a_i( s16 ),
    .r_o( R_o ),
    .d_o( D_o ),
    .rst( rst )
  );
  // H5
  hlatch #(.N(N)) hlatch_i1 (
    .r_i( s14 ),
    .a_o( s16 ),
    .d_i( s15 ),
    .a_i( s12 ),
    .r_o( s17 ),
    .d_o( s18 ),
    .rst( rst )
  );
  // H4
  hlatch #(.N(N)) hlatch_i2 (
    .r_i( s10 ),
    .a_o( s12 ),
    .d_i( s11 ),
    .a_i( s13 ),
    .r_o( s14 ),
    .d_o( s15 ),
    .rst( rst )
  );
  // JOIN_H1_H4__H3
  mullerc mullerc_i3 (
    .a( s3 ),
    .b( s13 ),
    .o( s9 ),
    .rst( rst )
  );
  // H3_VALID_1
  hlatch #(.RhandshakeVal(1'b1), .N(N), .RdataVal(128'b1)) hlatch_i4 (
    .r_i( s7 ),
    .a_o( s9 ),
    .d_i( s8 ),
    .a_i( s6 ),
    .r_o( s10 ),
    .d_o( s11 ),
    .rst( rst )
  );
  // assign s2 = ~ s11;
  assign s2 = s11 + 1;
  // delay
  delay #(.T(N * 2 + 2)) delay_i5 (
    .i( s10 ),
    .o( s0 ),
    .rst( rst )
  );
  // H1
  hlatch #(.N(N)) hlatch_i6 (
    .r_i( s0 ),
    .a_o( s1 ),
    .d_i( s2 ),
    .a_i( s3 ),
    .r_o( s4 ),
    .d_o( s5 ),
    .rst( rst )
  );
  // H2
  hlatch #(.N(N)) hlatch_i7 (
    .r_i( s4 ),
    .a_o( s6 ),
    .d_i( s5 ),
    .a_i( s1 ),
    .r_o( s7 ),
    .d_o( s8 ),
    .rst( rst )
  );
endmodule
