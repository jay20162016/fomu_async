`include "tinyfpga_bx_usbserial/usb/edge_detect.v"
`include "tinyfpga_bx_usbserial/usb/serial.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_in_arb.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_in_pe.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_out_arb.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_out_pe.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_pe.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_rx.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_tx_mux.v"
`include "tinyfpga_bx_usbserial/usb/usb_fs_tx.v"
`include "tinyfpga_bx_usbserial/usb/usb_reset_det.v"
`include "tinyfpga_bx_usbserial/usb/usb_serial_ctrl_ep.v"
`include "tinyfpga_bx_usbserial/usb/usb_uart_bridge_ep.v"
`include "tinyfpga_bx_usbserial/usb/usb_uart_core.v"
`include "tinyfpga_bx_usbserial/usb/usb_uart_i40.v"

`include "something2.v"

`define BLUEPWM  RGB0PWM
`define GREENPWM RGB1PWM
`define REDPWM   RGB2PWM

module fomu (
        input        clki,

        inout        usb_dp, // USB D+ pin
        inout        usb_dn, // USB D- pin
        output       usb_dp_pu,

        output       rgb0, // SB_RGBA_DRV external pins
        output       rgb1,
        output       rgb2);

    /*
     ██████ ██      ██   ██        ██        ██████  ███████ ████████
    ██      ██      ██  ██         ██        ██   ██ ██         ██
    ██      ██      █████       ████████     ██████  ███████    ██
    ██      ██      ██  ██      ██  ██       ██   ██      ██    ██
     ██████ ███████ ██   ██     ██████       ██   ██ ███████    ██
    */

    // Connect to system clock (with buffering)
    wire clk_48mhz;
    SB_GB clk_gb (
        .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
        .GLOBAL_BUFFER_OUTPUT(clk_48mhz)
    );

    // Generate reset signal
    reg [5:0] reset_cnt = 0;
    wire reset = ~reset_cnt[5];
    always @(posedge clk_48mhz)
        reset_cnt <= reset_cnt + {5'b0, reset};

    /*
    ██    ██ ███████ ██████      ███████ ███████ ████████ ██    ██ ██████
    ██    ██ ██      ██   ██     ██      ██         ██    ██    ██ ██   ██
    ██    ██ ███████ ██████      ███████ █████      ██    ██    ██ ██████
    ██    ██      ██ ██   ██          ██ ██         ██    ██    ██ ██
     ██████  ███████ ██████      ███████ ███████    ██     ██████  ██
    */

    // uart pipeline in
    reg [7:0] uart_in_data;
    reg uart_in_valid;
    reg uart_in_ready;
    reg [7:0] uart_out_data;
    reg uart_out_valid;
    reg uart_out_ready;

    // usb uart - this instanciates the entire USB device.
    usb_uart uart (
        .clk_48mhz  (clk_48mhz),
        .reset      (reset),

        // pins
        .pin_usb_p( usb_dp ),
        .pin_usb_n( usb_dn ),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        // uart pipeline out
        .uart_out_data( uart_out_data ),
        .uart_out_valid( uart_out_valid ),
        .uart_out_ready( uart_out_ready  )
    );

    // USB Host Detect Pull Up
    assign usb_dp_pu = 1'b1;

    /*
    ██    ██ ███████ ██████       ██████  ██████  ██████  ███████
    ██    ██ ██      ██   ██     ██      ██    ██ ██   ██ ██
    ██    ██ ███████ ██████      ██      ██    ██ ██   ██ █████
    ██    ██      ██ ██   ██     ██      ██    ██ ██   ██ ██
     ██████  ███████ ██████       ██████  ██████  ██████  ███████
    */

    localparam inputlen = 64;
    localparam outputlen = 64;

    localparam col_size = 8;

    reg [inputlen-1:0] intext;
    reg [outputlen-1:0] outtext;
    wire [outputlen-1:0] outtext2;

    reg red=0, green=0, blue=1;

    reg [31:0] send_cursor = 0;
    always @(posedge clk_48mhz) begin
        if (!reset) begin
            if (!uart_in_valid) begin // not sending? send!
                if (send_cursor < outputlen) begin // something to send? send!
                    uart_in_data <= 8'd48 + {7'b0, outtext[send_cursor]};
                    send_cursor <= send_cursor + 1;
                end
                else begin // nothing to send? send end!
                    send_cursor <= 0;
                    uart_in_data <= 42;
                end
                uart_in_valid <= 1;
            end
            else if (uart_in_ready) begin // they're ready? end!
                uart_in_valid <= 0;
            end

            uart_out_ready <= 0;
            if (uart_out_valid) begin // they have something? receive!
                if (!uart_out_ready) begin
                    intext[uart_out_data[7:1]] <= uart_out_data[0];

                    green <= 1;
                end
                uart_out_ready <= 1;
            end

            outtext <= outtext2;
        end
        else begin
            outtext <= 0;
            intext  <= 0;
        end
    end

    /*
    ███████ ██   ██ ███████  ██████     ██       ██████   ██████  ██  ██████
    ██       ██ ██  ██      ██          ██      ██    ██ ██       ██ ██
    █████     ███   █████   ██          ██      ██    ██ ██   ███ ██ ██
    ██       ██ ██  ██      ██          ██      ██    ██ ██    ██ ██ ██
    ███████ ██   ██ ███████  ██████     ███████  ██████   ██████  ██  ██████
    */

    something #(.il(inputlen), .ol(outputlen), .cs(col_size)) main (intext, outtext2);

    /*
    ██      ███████ ██████  ███████
    ██      ██      ██   ██ ██
    ██      █████   ██   ██ ███████
    ██      ██      ██   ██      ██
    ███████ ███████ ██████  ███████
    */

   SB_RGBA_DRV #(
       .CURRENT_MODE("0b1"),       // half current
       .RGB0_CURRENT("0b000011"),  // 4 mA
       .RGB1_CURRENT("0b000011"),  // 4 mA
       .RGB2_CURRENT("0b000011")   // 4 mA
   ) RGBA_DRIVER (
       .CURREN(1'b1),
       .RGBLEDEN(1'b1),
       .`BLUEPWM(blue),       // Blue
       .`REDPWM(red),         // Red
       .`GREENPWM(green),     // Green
       .RGB0(rgb0),
       .RGB1(rgb1),
       .RGB2(rgb2)
   );

endmodule
