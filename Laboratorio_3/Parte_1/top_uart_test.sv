// ===========================================================
// top_uart_test.sv
// Top-level UART - Nexys4 DDR
// ===========================================================
module top_uart_test (
    input  logic clk_in1_0,    // 100 MHz
    input  logic btnu,         // botón: envía 'A'
    input  logic rx,           // desde PC
    output logic tx,           // hacia PC
    output logic [7:0] led     // muestra byte recibido
);

    logic rst = 0;
    logic tx_start;
    logic tx_done;
    logic [7:0] rx_data;
    logic rx_done;

    // Genera pulso de envío al presionar el botón
    logic btn_prev;
    always_ff @(posedge clk_in1_0) begin
        btn_prev <= btnu;
        tx_start <= (btnu && !btn_prev);
    end

    // UART TX instancia
    UART_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) tx_inst (
        .clk(clk_in1_0),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(8'h41),  // letra 'A'
        .tx(tx),
        .tx_done(tx_done)
    );

    // UART RX instancia
    UART_rx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) rx_inst (
        .clk(clk_in1_0),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Mostrar byte recibido en LEDs
    assign led[0]=rx;
    assign led[1]=tx;
    always_ff @(posedge clk_in1_0) begin
    if (rx_done)
      led[7:2]<=rx_data[5:0];
   end
endmodule