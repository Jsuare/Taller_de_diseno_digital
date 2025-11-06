// uart_tx.sv
module uart_tx #(
    // 100_000_000 / 115200 = 868.055 -> 868
    parameter integer CLKS_PER_BIT = 868
)(
    input  logic clk,
    input  logic rst,

    input  logic       tx_start,    // pulso: quiero mandar un byte
    input  logic [7:0] tx_data,
    output logic       tx_serial,
    output logic       tx_busy
);

    typedef enum logic [2:0] {
        S_IDLE,
        S_START,
        S_DATA,
        S_STOP
    } state_t;

    state_t state;
    logic [9:0] clk_cnt;
    logic [2:0] bit_idx;
    logic [7:0] data_reg;

    // línea en reposo es 1
    assign tx_serial = (state == S_IDLE) ? 1'b1 :
                       (state == S_START) ? 1'b0 :
                       (state == S_DATA)  ? data_reg[bit_idx] :
                       1'b1; // stop

    assign tx_busy   = (state != S_IDLE);

    always_ff @(posedge clk) begin
        if (rst) begin
            state   <= S_IDLE;
            clk_cnt <= 0;
            bit_idx <= 0;
            data_reg<= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    clk_cnt <= 0;
                    bit_idx <= 0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        state    <= S_START;
                    end
                end

                S_START: begin
                    if (clk_cnt == CLKS_PER_BIT-1) begin
                        clk_cnt <= 0;
                        state   <= S_DATA;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                S_DATA: begin
                    if (clk_cnt == CLKS_PER_BIT-1) begin
                        clk_cnt <= 0;
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
                        state   <= S_IDLE;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule

