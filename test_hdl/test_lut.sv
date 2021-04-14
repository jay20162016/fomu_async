`include "lut.sv"


module test_lut ();

  reg a, b, c, d;
  wire o;

  wire expected;
  wire mismatch;

  lut #(.LUT(16'b1110101111101110)) uut_lut (a, b, c, d, o); // ((a & ~b) ^ c) | d

  reg [63:0] xorshift64_state = 64'd88172645463325252;

  task xorshift64_next;
      begin
        // see page 4 of Marsaglia, George (July 2003). "Xorshift RNGs". Journal of Statistical Software 8 (14).
        xorshift64_state = xorshift64_state ^ (xorshift64_state << 13);
        xorshift64_state = xorshift64_state ^ (xorshift64_state >>  7);
        xorshift64_state = xorshift64_state ^ (xorshift64_state << 17);
      end
  endtask

  assign expected = (((a & ~b) ^ c) | d);
  assign mismatch = (expected ^ o);

  initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_lut);

    repeat (10000) begin // 10,000
      a = xorshift64_state[0];
      b = xorshift64_state[18];
      c = xorshift64_state[23];
      d = xorshift64_state[31];

      xorshift64_next;
      #2000;

      assert( !mismatch );
    end

    $finish;

  end

endmodule
