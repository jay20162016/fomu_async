`include "mullerc.v"


module test_mullerc ();

  localparam Rval = 1'b1;

  reg a, b;
  wire o;
  reg rst;

  wire expected;
  wire mismatch;

  mullerc #(.Rval(Rval)) uut_mullerc (a, b, o, rst);

  reg [63:0] xorshift64_state = 64'd88172645463325252;

  task xorshift64_next;
      begin
        // see page 4 of Marsaglia, George (July 2003). "Xorshift RNGs". Journal of Statistical Software 8 (14).
        xorshift64_state = xorshift64_state ^ (xorshift64_state << 13);
        xorshift64_state = xorshift64_state ^ (xorshift64_state >>  7);
        xorshift64_state = xorshift64_state ^ (xorshift64_state << 17);
      end
  endtask

  assign expected = ((((a&b) | (o & (a|b))) & ~rst) & ~Rval)
                  | ((((a&b) | (o & (a|b))) |  rst) &  Rval);
  assign mismatch = (expected ^ o);

  initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_mullerc);

    repeat (10000) begin // 10,000
      a   = xorshift64_state[0];
      b   = xorshift64_state[18];
      rst = xorshift64_state[31];

      xorshift64_next;
      #2000;

      assert( !mismatch );
    end

    $finish;

  end

endmodule
