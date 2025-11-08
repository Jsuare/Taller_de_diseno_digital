// ===========================================================
// UART_rx.sv
// Conversión de VHDL a  SystemVerilog

// ===========================================================

module UART_rx #(
    parameter int BAUD_X16_CLK_TICKS = 9  // (clk / baud_rate) / 16 => (16 MHz / 115200) / 16 ≈ 8.68
)(
    input  logic        clk,
    input  logic        reset,
    input  logic        rx_data_in,
    output logic        rx_data_rdy,
    output logic [7:0]  rx_data_out
);

    // ======================================================
    // Estados de la FSM
    // ======================================================
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} rx_states_t;
    rx_states_t rx_state = IDLE;

    // ======================================================
    // Señales internas
    // ======================================================
    logic baud_rate_x16_clk = 1'b0;
    int   baud_x16_count = BAUD_X16_CLK_TICKS - 1;

    logic [7:0] rx_stored_data = 8'b0;

    logic rx_end = 1'b0;
    logic edge_signal = 1'b0;

    // ======================================================
    // Generador de reloj x16 del baud rate
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset) begin
            baud_rate_x16_clk <= 1'b0;
            baud_x16_count    <= BAUD_X16_CLK_TICKS - 1;
        end else begin
            if (baud_x16_count == 0) begin
                baud_rate_x16_clk <= 1'b1;
                baud_x16_count    <= BAUD_X16_CLK_TICKS - 1;
            end else begin
                baud_rate_x16_clk <= 1'b0;
                baud_x16_count    <= baud_x16_count - 1;
            end
        end
    end

    // ======================================================
    // Máquina de estados UART RX
    // ======================================================
    int bit_duration_count = 0;
    int bit_count          = 0;

    always_ff @(posedge clk) begin
        if (reset) begin
            rx_state       <= IDLE;
            rx_stored_data <= 8'b0;
            rx_data_out    <= 8'b0;
            rx_end         <= 1'b0;
            bit_duration_count <= 0;
            bit_count          <= 0;
        end else if (baud_rate_x16_clk) begin
            unique case (rx_state)
                // --------------------------------------------------
                IDLE: begin
                    rx_end         <= 1'b0;
                    rx_stored_data <= 8'b0;
                    bit_duration_count <= 0;
                    bit_count          <= 0;

                    if (rx_data_in == 1'b0)
                        rx_state <= START; // Detecta start bit
                end

                // --------------------------------------------------
                START: begin
                    rx_end <= 1'b0;
                    if (rx_data_in == 1'b0) begin
                        if (bit_duration_count == 7) begin
                            rx_state           <= DATA;
                            bit_duration_count <= 0;
                        end else
                            bit_duration_count <= bit_duration_count + 1;
                    end else
                        rx_state <= IDLE; // Falsa alarma
                end

                // --------------------------------------------------
                DATA: begin
                    if (bit_duration_count == 15) begin
                        rx_stored_data[bit_count] <= rx_data_in;
                        bit_duration_count <= 0;

                        if (bit_count == 7) begin
                            rx_state <= STOP;
                            bit_duration_count <= 0;
                        end else
                            bit_count <= bit_count + 1;
                    end else
                        bit_duration_count <= bit_duration_count + 1;
                end

                // --------------------------------------------------
                STOP: begin
                    if (bit_duration_count == 15) begin
                        rx_data_out <= rx_stored_data;
                        rx_end      <= 1'b1;
                        rx_state    <= IDLE;
                    end else
                        bit_duration_count <= bit_duration_count + 1;
                end

                // --------------------------------------------------
                default: begin
                    rx_end   <= 1'b0;
                    rx_state <= IDLE;
                end
            endcase
        end
    end

    // ======================================================
    // Señal rx_data_rdy (flanco único cuando termina recepción)
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset)
            rx_data_rdy <= 1'b0;
        else
            rx_data_rdy <= rx_end & ~edge_signal;
    end

    always_ff @(posedge clk) begin
        if (reset)
            edge_signal <= 1'b0;
        else
            edge_signal <= rx_end;
    end

endmodule
