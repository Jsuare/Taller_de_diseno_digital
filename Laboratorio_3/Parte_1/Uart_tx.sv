// ===========================================================
// UART_tx.sv
// Conversión de VHDL → SystemVerilog
// Carlos Hurtado Villalobos
// ===========================================================

module UART_tx #(
    parameter int BAUD_CLK_TICKS = 139   // clk/baud_rate (16 MHz / 115200 = 138.89)
)(
    input  logic        clk,
    input  logic        reset,
    input  logic        tx_start,
    output logic        tx_rdy,
    input  logic [7:0]  tx_data_in,
    output logic        tx_data_out
);

    // ======================================================
    // Estados del transmisor
    // ======================================================
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} tx_states_t;
    tx_states_t tx_state = IDLE;

    // ======================================================
    // Señales internas
    // ======================================================
    logic baud_rate_clk = 1'b0;
    int   baud_count = BAUD_CLK_TICKS - 1;

    int   data_index = 0;
    logic data_index_reset = 1'b1;
    logic [7:0] stored_data = 8'b0;

    logic start_detected = 1'b0;
    logic start_reset = 1'b0;

    logic tx_end = 1'b0;
    logic edge_signal = 1'b0;

    // ======================================================
    // Generador de reloj de baudios
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset) begin
            baud_rate_clk <= 1'b0;
            baud_count    <= BAUD_CLK_TICKS - 1;
        end else begin
            if (baud_count == 0) begin
                baud_rate_clk <= 1'b1;
                baud_count    <= BAUD_CLK_TICKS - 1;
            end else begin
                baud_rate_clk <= 1'b0;
                baud_count    <= baud_count - 1;
            end
        end
    end

    // ======================================================
    // Detector de inicio de transmisión
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset || start_reset) begin
            start_detected <= 1'b0;
        end else if (tx_start && !start_detected) begin
            start_detected <= 1'b1;
            stored_data    <= tx_data_in;
        end
    end

    // ======================================================
    // Contador de bits de datos
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset || data_index_reset) begin
            data_index <= 0;
        end else if (baud_rate_clk) begin
            data_index <= data_index + 1;
        end
    end

    // ======================================================
    // Máquina de estados UART TX
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset) begin
            tx_state         <= IDLE;
            data_index_reset <= 1'b1;
            start_reset      <= 1'b1;
            tx_data_out      <= 1'b1;
            tx_end           <= 1'b0;
        end else if (baud_rate_clk) begin
            unique case (tx_state)

                IDLE: begin
                    tx_end           <= 1'b0;
                    data_index_reset <= 1'b1;
                    start_reset      <= 1'b0;
                    tx_data_out      <= 1'b1;
                    if (start_detected)
                        tx_state <= START;
                end

                START: begin
                    tx_end           <= 1'b0;
                    data_index_reset <= 1'b0;
                    tx_data_out      <= 1'b0; // start bit
                    tx_state         <= DATA;
                end

                DATA: begin
                    tx_data_out <= stored_data[data_index];
                    if (data_index == 7) begin
                        data_index_reset <= 1'b1;
                        tx_state         <= STOP;
                    end
                end

                STOP: begin
                    tx_data_out <= 1'b1; // stop bit
                    start_reset <= 1'b1;
                    tx_end      <= 1'b1;
                    tx_state    <= IDLE;
                end

                default: begin
                    tx_end   <= 1'b0;
                    tx_state <= IDLE;
                end
            endcase
        end
    end

    // ======================================================
    // Generación de señal TX_RDY
    // ======================================================
    always_ff @(posedge clk) begin
        if (reset) begin
            tx_rdy      <= 1'b0;
            edge_signal <= 1'b0;
        end else begin
            tx_rdy      <= tx_end & ~edge_signal;
            edge_signal <= tx_end;
        end
    end

endmodule
