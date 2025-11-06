// uart_rx.sv
module uart_rx #(
    parameter integer CLKS_PER_BIT = 868
)(
    input  logic clk,
    input  logic rst,
    input  logic rx_serial,
    output logic rx_valid,      // pulso 1 clk cuando hay dato
    output logic [7:0] rx_data
);

    typedef enum logic [2:0] {
        S_IDLE,
        S_START,
        S_DATA,
        S_STOP,
        S_DONE
    } state_t;

    state_t state;
    logic [9:0] clk_cnt;
    logic [2:0] bit_idx;
    logic [7:0] data_reg;
    logic       rx_d1;

    // sincronizar
    always_ff @(posedge clk) begin
        rx_d1 <= rx_serial;
    end

    assign rx_data  = data_reg;
    assign rx_valid = (state == S_DONE);

    always_ff @(posedge clk) begin
        if (rst) begin
            state   <= S_IDLE;
            clk_cnt <= 0;
            bit_idx <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (rx_d1 == 1'b0) begin
                        // start detectado
                        state   <= S_START;
                        clk_cnt <= 0;
                    end
                end

                S_START: begin
                    // ir al centro del start bit
                    if (clk_cnt == (CLKS_PER_BIT/2)) begin
                        clk_cnt <= 0;
                        state   <= S_DATA;
                        bit_idx <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_DATA: begin
                    if (clk_cnt == CLKS_PER_BIT-1) begin
                        clk_cnt           <= 0;
                        data_reg[bit_idx] <= rx_d1;
                        if (bit_idx == 3'd7) begin
                            state <= S_STOP;
                        end else begin
                            bit_idx <= bit_idx + 1;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_STOP: begin
                    if (clk_cnt == CLKS_PER_BIT-1) begin
                        clk_cnt <= 0;
                        state   <= S_DONE;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_DONE: begin
                    // 1 ciclo con rx_valid = 1
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
