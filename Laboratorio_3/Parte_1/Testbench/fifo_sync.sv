// fifo_sync.sv
module fifo_sync #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,              // 16 bytes
    localparam ADDR_W = $clog2(DEPTH)
) (
    input  logic              clk,
    input  logic              rst,

    // write side
    input  logic              wr_en,
    input  logic [WIDTH-1:0]  wr_data,

    // read side
    input  logic              rd_en,
    output logic [WIDTH-1:0]  rd_data,

    output logic              full,
    output logic              empty,
    output logic [ADDR_W:0]   count   // cuánto hay dentro
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_W-1:0] w_ptr, r_ptr;
    logic [ADDR_W:0]   cnt;

    // write
    always_ff @(posedge clk) begin
        if (rst) begin
            w_ptr <= '0;
        end else begin
            if (wr_en && !full) begin
                mem[w_ptr] <= wr_data;
                w_ptr <= w_ptr + 1'b1;
            end
        end
    end

    // read
    always_ff @(posedge clk) begin
        if (rst) begin
            r_ptr <= '0;
            rd_data <= '0;
        end else begin
            if (rd_en && !empty) begin
                rd_data <= mem[r_ptr];
                r_ptr   <= r_ptr + 1'b1;
            end
        end
    end

    // counter
    always_ff @(posedge clk) begin
        if (rst) begin
            cnt <= '0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: cnt <= cnt + 1'b1;    // solo escribo
                2'b01: cnt <= cnt - 1'b1;    // solo leo
                default: ;                   // nada o las dos
            endcase
        end
    end

    assign count = cnt;
    assign full  = (cnt == DEPTH);
    assign empty = (cnt == 0);

endmodule

