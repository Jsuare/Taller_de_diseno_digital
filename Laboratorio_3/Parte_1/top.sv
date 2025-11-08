// ===========================================================
// -----------------------------------------------------------
// - Presionar BTNU → envía la letra 'A' (0x41) al PC.
// - Los LEDs [7:0] muestran el último byte recibido.
// - LED7 se enciende si se ha transmitido al menos una vez.
// - LED6 se enciende si se ha recibido algo desde el PC.
// ===========================================================

module top_uart_button (
    input  logic clk_in1_0,   // Reloj de 100 MHz (pin E3)
    input  logic btnu,        // Botón BTNU (M18)
    input  logic rx,          // Desde PC (FTDI TX)
    output logic tx,          // Hacia PC (FTDI RX)
    output logic [7:0] led    // LEDs 0-7
);

    // ----------------------------
    // Señales internas con el de la IP
    // ----------------------------
    logic clk_16MHz, pll_locked;
    logic tx_rdy, rx_data_rdy;
    logic [7:0] data_out;

    // ----------------------------
    // Instancia del Clocking Wizard
    // ----------------------------
    clk_wiz_0 clkgen (
        .clk_in1 (clk_in1_0),
        .reset   (1'b0),
        .clk_out1(clk_16MHz),
        .locked  (pll_locked)
    );

    // ----------------------------
    // Detector de flanco del botón (pulso de 1 ciclo)
    // ----------------------------
    logic btnu_sync, btnu_prev;
    always_ff @(posedge clk_16MHz) begin
        btnu_sync <= btnu;          // sincroniza con reloj interno
        btnu_prev <= btnu_sync;
    end
    wire tx_start = btnu_sync & ~btnu_prev;  // pulso cuando se presiona

    // ----------------------------
    // UART TX + RX
    // ----------------------------
    UART uart_inst (
        .clk         (clk_16MHz),
        .reset       (~pll_locked),
        .tx_start    (tx_start),
        .tx_rdy      (tx_rdy),
        .rx_data_rdy (rx_data_rdy),
        .data_in     (8'h41),      // Letra 'A'
        .data_out    (data_out),
        .rx          (rx),
        .tx          (tx)
    );

    // ----------------------------
    // Indicadores LED
    // ----------------------------
    logic tx_evt, rx_evt;
    always_ff @(posedge clk_16MHz or negedge pll_locked) begin
        if (!pll_locked) begin
            tx_evt <= 1'b0;
            rx_evt <= 1'b0;
        end else begin
            if (tx_rdy)      tx_evt <= 1'b1;   // se encendió una vez
            if (rx_data_rdy) rx_evt <= 1'b1;   // recibió algo
        end
    end

    // LEDs
    assign led[7]   = rx_evt;        // recibió algo
    assign led[6]   = tx_evt;        // transmitió algo
    assign led[5:0] = data_out[5:0]; // dato recibido

endmodule
