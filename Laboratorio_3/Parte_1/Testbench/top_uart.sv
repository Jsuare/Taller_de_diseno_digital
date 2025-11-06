// top_uart.sv
module top_uart(
    input  logic        clk,       // 100 MHz
    input  logic        btnu,      // reset
    input  logic        btnl,      // escribir desde switches -> FIFO_TX
    input  logic        btnr,      // leer desde FIFO_RX -> LEDs
    input  logic        btnc,      // limpiar leds
    input  logic        btnd,      // limpiar fifos (opcional)

    input  logic [15:0] sw,        // sw[7:0] = dato a enviar

    input  logic        uart_rx,
    output logic        uart_tx,

    output logic [15:0] led
);

    // reset síncrono
    logic rst;
    assign rst = btnu;

    // -------------------------------------------------
    // FIFOs
    // -------------------------------------------------
    // TX FIFO: lo que FPGA quiere mandar al PC
    logic        txfifo_wr;
    logic  [7:0] txfifo_din;
    logic        txfifo_rd;
    logic  [7:0] txfifo_dout;
    logic        txfifo_full, txfifo_empty;
    logic  [4:0] txfifo_count;

    fifo_sync #(.WIDTH(8), .DEPTH(16)) u_fifo_tx (
        .clk    (clk),
        .rst    (rst | btnd),
        .wr_en  (txfifo_wr),
        .wr_data(txfifo_din),
        .rd_en  (txfifo_rd),
        .rd_data(txfifo_dout),
        .full   (txfifo_full),
        .empty  (txfifo_empty),
        .count  (txfifo_count)
    );

    // RX FIFO: lo que llega del PC
    logic        rxfifo_wr;
    logic  [7:0] rxfifo_din;
    logic        rxfifo_rd;
    logic  [7:0] rxfifo_dout;
    logic        rxfifo_full, rxfifo_empty;
    logic  [4:0] rxfifo_count;

    fifo_sync #(.WIDTH(8), .DEPTH(16)) u_fifo_rx (
        .clk    (clk),
        .rst    (rst | btnd),
        .wr_en  (rxfifo_wr),
        .wr_data(rxfifo_din),
        .rd_en  (rxfifo_rd),
        .rd_data(rxfifo_dout),
        .full   (rxfifo_full),
        .empty  (rxfifo_empty),
        .count  (rxfifo_count)
    );

    // -------------------------------------------------
    // UART TX: saca de FIFO_TX cuando esté libre
    // -------------------------------------------------
    logic tx_start;
    logic tx_busy;

    uart_tx #(.CLKS_PER_BIT(868)) u_tx (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (txfifo_dout),
        .tx_serial(uart_tx),
        .tx_busy  (tx_busy)
    );

    // cuando TX no esté ocupado y FIFO tenga datos, sacamos 1
    assign txfifo_rd = (!tx_busy) && (!txfifo_empty);
    assign tx_start  = txfifo_rd;   // mismo pulso

    // escritura desde los switches
    assign txfifo_din = sw[7:0];
    assign txfifo_wr  = btnl && !txfifo_full;

    // -------------------------------------------------
    // UART RX: cada vez que llegue un byte lo meto a la FIFO_RX
    // -------------------------------------------------
    logic rx_valid;
    logic [7:0] rx_byte;

    uart_rx #(.CLKS_PER_BIT(868)) u_rx (
        .clk      (clk),
        .rst      (rst),
        .rx_serial(uart_rx),
        .rx_valid (rx_valid),
        .rx_data  (rx_byte)
    );

    assign rxfifo_wr  = rx_valid && !rxfifo_full;
    assign rxfifo_din = rx_byte;

    // -------------------------------------------------
    // Leer desde RX FIFO y mostrar en LEDs
    // -------------------------------------------------
    logic [7:0] last_rx_byte;

    assign rxfifo_rd = btnr && !rxfifo_empty;

    always_ff @(posedge clk) begin
        if (rst || btnc) begin
            last_rx_byte <= 8'h00;
        end else begin
            if (rxfifo_rd) begin
                last_rx_byte <= rxfifo_dout;
            end
        end
    end

    // -------------------------------------------------
    // LEDs
    // -------------------------------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            led <= 16'h0000;
        end else begin
            // 0..7 = último dato leído
            led[7:0]  <= last_rx_byte;
            // indicadores de FIFO
            led[8]    <= txfifo_full;
            led[9]    <= txfifo_empty;
            led[10]   <= rxfifo_full;
            led[11]   <= rxfifo_empty;
            // resto a 0
            led[15:12]<= 4'b0000;
        end
    end

endmodule
