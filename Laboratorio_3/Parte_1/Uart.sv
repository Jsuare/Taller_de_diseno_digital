// ===========================================================
// UART.sv
// Conversión de VHDL → SystemVerilog
// Integra UART_tx y UART_rx
// Carlos Hurtado Villalobos
// ===========================================================

module UART (
    input  logic        clk,
    input  logic        reset,
    input  logic        tx_start,
    output logic        tx_rdy,
    output logic        rx_data_rdy,
    input  logic [7:0]  data_in,
    output logic [7:0]  data_out,
    input  logic        rx,
    output logic        tx
);

    // ======================================================
    // Instancia del transmisor UART
    // ======================================================
    UART_tx #(
        .BAUD_CLK_TICKS(139)   // 16 MHz / 115200 ≈ 139
    ) transmitter (
        .clk         (clk),
        .reset       (reset),
        .tx_start    (tx_start),
        .tx_rdy      (tx_rdy),
        .tx_data_in  (data_in),
        .tx_data_out (tx)
    );

    // ======================================================
    // Instancia del receptor UART
    // ======================================================
    UART_rx #(
        .BAUD_X16_CLK_TICKS(9) // (16 MHz / 115200) / 16 ≈ 9
    ) receiver (
        .clk          (clk),
        .reset        (reset),
        .rx_data_in   (rx),
        .rx_data_rdy  (rx_data_rdy),
        .rx_data_out  (data_out)
    );

endmodule
