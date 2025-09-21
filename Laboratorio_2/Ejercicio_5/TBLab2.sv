///////////////////////////////////////////////////////////////////////////////////////////////////
//
// TBLab2.sv
//
// Este es el testbench de la Mini Unidad de Cálculo del Lab 2.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module MiniUnidadCalculo_tb;

    // ---------------------------------------------
    // Señales del DUT
    // ---------------------------------------------
    logic clk, rst, sw;
    logic [3:0] boton;
    logic dp;
    logic [6:0] leds, a_to_g;
    logic [7:0] an;

    // ---------------------------------------------
    // Instancia del DUT
    // ---------------------------------------------
    MiniUnidadCalculo dut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .boton(boton),
        .dp(dp),
        .leds(leds),
        .a_to_g(a_to_g),
        .an(an)
    );

    // ---------------------------------------------
    // Reloj de simulación
    // ---------------------------------------------
    initial clk = 0;
    always #50 clk = ~clk; // Reloj de 100 MHz (simulación rápida)

    // ---------------------------------------------
    // Variables internas para Scoreboard
    // ---------------------------------------------
    logic [15:0] expected_result;

    // ---------------------------------------------
    // Inicialización y estímulos
    // ---------------------------------------------
    initial begin
        // Dump de señales para GTKWave
        $dumpfile("sim_lab2.vcd");
        $dumpvars(0, MiniUnidadCalculo_tb);

        // Reset inicial
        rst = 1; sw = 0; boton = 0;
      #100 rst = 0; #1000;

        ///////////////////////////////////////////////////////////////////////////////////////////

        repeat (5) begin

            // SUMA ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            boton = 4'b0001;  // operación SUMA
            @(posedge clk); @(posedge clk);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);

            // tercer WE (Op_result)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);
            boton = 4'b0000;    // Soltar botón
            expected_result = dut.rs1 + dut.rs2;
            check_alu();

            // RESTA ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            boton = 4'b0010;  // operación RESTA
            @(posedge clk); @(posedge clk);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);

            // tercer WE (Op_result)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);
            boton = 4'b0000;    // Soltar botón
            expected_result = dut.rs1 - dut.rs2;
            check_alu();

            // AND ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            boton = 4'b0100;  // operación AND
            @(posedge clk); @(posedge clk);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);

            // tercer WE (Op_result)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);
            boton = 4'b0000;    // Soltar botón
            expected_result = dut.rs1 & dut.rs2;
            check_alu();

            // OR ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            boton = 4'b1000;  // operación OR
            @(posedge clk); @(posedge clk);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);

            // tercer WE (Op_result)
            wait (dut.WE == 1'b1);
            @(posedge clk); @(posedge clk);
            boton = 4'b0000;    // Soltar botón
            expected_result = dut.rs1 | dut.rs2;
            check_alu();

        end

        ///////////////////////////////////////////////////////////////////////////////////////////

        // Activar modo lectura
        sw = 1; #125_000;

        $display("Simulacion terminada correctamente.");
        $stop;

    end

    // ---------------------------------------------
    // Task para verificar resultados de ALU
    // ---------------------------------------------
    task check_alu;
        if (dut.Op_result !== expected_result) begin
            $display("ERROR: ALU mismatch at time %t, rs1=%h, rs2=%h, got=%h, expected=%h",
                     $time, dut.rs1, dut.rs2, dut.Op_result, expected_result);
        end else begin
            $display("ALU OK at time %t, result=%h", $time, dut.Op_result);
        end
    endtask

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////
