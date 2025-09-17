`timescale 1ns/1ps

module tb_top;

    // Señales del DUT
    logic        clk_i;
    logic        rst;
    logic        en;
    logic [6:0]  a_to_g;
    logic        dp;
    logic [7:0]  an;

    // Instancia del DUT
    top #(.MAX_COUNT(1)) dut ( // MAX_COUNT pequeño para la simulacion
        .clk_i(clk_i),
        .rst(rst),
        .en(en),
        .a_to_g(a_to_g),
        .dp(dp),
        .an(an)
    );

    // Generador de reloj: 100 MHz
    always #5 clk_i = ~clk_i;

    //verificacion
    logic [15:0] q_prev;
    integer cycle = 0;

    // Inicialización
    initial begin
        clk_i = 0;
        rst   = 1;
        en    = 0;

        // Reset inicial
        #50;
        rst = 0;
        en  = 1;

        //inicializar valores 
        dut.q = 16'h0000;
        dut.an = 8'b1110_1111;
        dut.a_to_g = 7'b0000000;
        dut.dp = 0;

        //cabecera para la tabla.
        $display("Tiempo(ns)\tq(hex)\tan(bin)\ta_to_g(bin)\tdp");
    end

    //casos especiales para determinar
    always @(posedge clk_i) begin
        if (!rst && en) begin
            cycle++;
            dut.q <= dut.q + 1;

            //incrementacion
            if (dut.a_to_g == 7'b1111111)
                dut.a_to_g <= 7'b0000000;
            else
                dut.a_to_g <= dut.a_to_g + 1;

            // altena el dp
            dut.dp <= ~dut.dp;

            //rotar el valor de los display
            case (dut.an)
                8'b1110_1111: dut.an <= 8'b1101_1111;
                8'b1101_1111: dut.an <= 8'b1011_1111;
                8'b1011_1111: dut.an <= 8'b0111_1111;
                8'b0111_1111: dut.an <= 8'b1110_1111;
                default:      dut.an <= 8'b1110_1111;
            endcase

            //imprimir valores
            $display("%0t\t%h\t%b\t%b\t%b", $time, dut.q, an, a_to_g, dp);

            //verificación automática
            if (!(an == 8'b1110_1111 || 
                  an == 8'b1101_1111 || 
                  an == 8'b1011_1111 || 
                  an == 8'b0111_1111)) begin
                $error("AN inválido = %b en t=%0t", an, $time);
            end

            if (dut.q == q_prev) begin
                $warning("q no cambia en t=%0t", $time);
            end
            q_prev <= dut.q;
        end
    end
    initial begin //terminar al final de N ciclos
        #20000; // tiempo para correr cada parte
        $finish;
    end

endmodule