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
      #100 rst = 0; #6_000_000;

        ///////////////////////////////////////////////////////////////////////////////////////////

        repeat (5) begin

            // SUMA ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Primer WE en %t", $time);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Segundo WE en %t", $time);

            // Activar botón
            repeat (5) @(posedge clk);
            boton = 4'b0001;  // operación SUMA
            $display("Botón activado en %t", $time);

            // Esperar al WE de la operación
            wait (dut.WE == 1'b1);
            $display("Tercer WE (operación) en %t", $time);

            // Soltar botón
            repeat (5) @(posedge clk);
            boton = 4'b0000;
            $display("Botón desactivado en %t", $time);

            // RESTA ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Primer WE en %t", $time);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Segundo WE en %t", $time);

            // Activar botón
            repeat (5) @(posedge clk);
            boton = 4'b0010;  // operación RESTA
            $display("Botón activado en %t", $time);

            // Esperar al WE de la operación
            wait (dut.WE == 1'b1);
            $display("Tercer WE (operación) en %t", $time);

            // Soltar botón
            repeat (5) @(posedge clk);
            boton = 4'b0000;
            $display("Botón desactivado en %t", $time);

            // AND ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Primer WE en %t", $time);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Segundo WE en %t", $time);

            // Activar botón
            repeat (5) @(posedge clk);
            boton = 4'b0100;  // operación AND
            $display("Botón activado en %t", $time);

            // Esperar al WE de la operación
            wait (dut.WE == 1'b1);
            $display("Tercer WE (operación) en %t", $time);

            // Soltar botón
            repeat (5) @(posedge clk);
            boton = 4'b0000;
            $display("Botón desactivado en %t", $time);

            // OR ///////////////////////////////////////////////////////////////////////////////////

            // primer WE (Data_A)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Primer WE en %t", $time);

            // segundo WE (Data_B)
            wait (dut.WE == 1'b1);
            @(posedge clk);
            $display("Segundo WE en %t", $time);

            // Activar botón
            repeat (5) @(posedge clk);
            boton = 4'b1000;  // operación OR
            $display("Botón activado en %t", $time);

            // Esperar al WE de la operación
            wait (dut.WE == 1'b1);
            $display("Tercer WE (operación) en %t", $time);

            // Soltar botón
            repeat (5) @(posedge clk);
            boton = 4'b0000;
            $display("Botón desactivado en %t", $time);

        end

        ///////////////////////////////////////////////////////////////////////////////////////////

        // Activar modo lectura
        sw = 1; #6_000_000;

        $display("Simulación terminada correctamente.");
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