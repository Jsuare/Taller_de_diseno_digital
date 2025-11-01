
//  - Auto TX 'A' cada ~0.5 s 
//  - LED de evento TX listo y RX listo
//  - LEDs[7:0] muestran el byte recibido
// ===========================================================
module top_uart_diag (
    input  logic clk_in1_0,   // 100 MHz (E3)
    input  logic rx,          
    output logic tx,          
    output logic [7:0] led    // LEDs 
);

    // ----------------------------
    // Reloj 16 MHz
    // ----------------------------
    logic clk_16MHz, pll_locked;
    clk_wiz_0 clkgen (
        .clk_in1 (clk_in1_0),
        .reset   (1'b0),
        .clk_out1(clk_16MHz),
        .locked  (pll_locked)
    );

    // ----------------------------
    // Heartbeat (~1 Hz) en LED6
    // ----------------------------
    logic hb;
    localparam int HB_DIV = 16_000_000/2; // ~0.5 s por flanco → ~1 Hz
    int hb_cnt;
    always_ff @(posedge clk_16MHz or negedge pll_locked) begin
        if (!pll_locked) begin
            hb_cnt <= 0; hb <= 1'b0;
        end else begin
            if (hb_cnt == HB_DIV-1) begin hb_cnt <= 0; hb <= ~hb; end
            else hb_cnt <= hb_cnt + 1;
        end
    end

    // ----------------------------
    // Genera pulso tx_start cada ~0.5 s
    // ----------------------------
    logic tx_start;
    logic [7:0] data_out;
    logic tx_rdy, rx_data_rdy;

    // Un pulso de 1 ciclo al comienzo de cada periodo de 0.5 s
    // (cuando hb_cnt vuelve a 0)
    always_ff @(posedge clk_16MHz or negedge pll_locked) begin
        if (!pll_locked) tx_start <= 1'b0;
        else             tx_start <= (hb_cnt == 0); // un ciclo
    end

    // ----------------------------
    // UART TX+RX (a 16 MHz)
    // ----------------------------
    UART uart_inst (
        .clk         (clk_16MHz),
        .reset       (~pll_locked),
        .tx_start    (tx_start),
        .tx_rdy      (tx_rdy),
        .rx_data_rdy (rx_data_rdy),
        .data_in     (8'h41),      // 'A'
        .data_out    (data_out),
        .rx          (rx),
        .tx          (tx)
    );
 
    assign led[7:0] = data_out;
    

endmodule
