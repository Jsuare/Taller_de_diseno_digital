`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 22:17:19
// Design Name: 
// Module Name: TB_Rebote
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module TB_Rebote();
    // Parámetros
    parameter int N = 20;
    parameter int DEBOUNCE_TIME = (2**N) * 100; // Tiempo en ns (104.8576 ms)
    
    // Señales de entrada
    logic clk;
    logic rst;
    logic ruido_entrada;
    
    // Señales de salida
    logic senal_sin_ruido;
    
    // Instanciar el módulo bajo prueba
    Rebote #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .ruido_entrada(ruido_entrada),
        .senal_sin_ruido(senal_sin_ruido)
    );
    
    // Generación de reloj (10 MHz - periodo 100 ns)
    always #50 clk = ~clk;
    
    // Procedimiento de prueba
    initial begin
        // Inicializar señales
        clk = 0;
        rst = 1;  // Reset activo
        ruido_entrada = 0;
        
        // Header de la simulación
        $display("==========================================================================");
        $display("Testbench para Módulo Anti-Rebote (%0d bits, 10 MHz)", N);
        $display("Tiempo de debounce: %0.3f ms", DEBOUNCE_TIME / 1000000.0);
        $display("==========================================================================");
        $display("Tiempo(ns)   | Entrada | Salida | Contador  | Comentario");
        $display("--------------------------------------------------------------------");
        
        // Reset inicial
        #200;
        rst = 0;  // Liberar reset
        #100;
        
        // Test 1: Cambio estable de 0 a 1 (sin rebotes)
        ruido_entrada = 1;
        #(DEBOUNCE_TIME + 100000);  // Esperar tiempo completo de debounce
        
        // Test 2: Cambio estable de 1 a 0 (sin rebotes)
        ruido_entrada = 0;
        #(DEBOUNCE_TIME + 100000);
        
        // Test 3: Rebotes típicos en botón
        ruido_entrada = 1;
        #100000;  // 100 μs de rebotes
        ruido_entrada = 0;
        #50000;
        ruido_entrada = 1;
        #30000;
        ruido_entrada = 0;
        #40000;
        ruido_entrada = 1;  // Estado final estable
        #(DEBOUNCE_TIME + 100000);
        
        // Test 4: Rebotes al soltar
        ruido_entrada = 0;
        #80000;
        ruido_entrada = 1;
        #20000;
        ruido_entrada = 0;
        #60000;
        ruido_entrada = 1;
        #30000;
        ruido_entrada = 0;  // Estado final estable
        #(DEBOUNCE_TIME + 100000);
        
        // Finalizar simulación
        #200;
        $display("==========================================================================");
        $display("Simulación completada");
        $display("==========================================================================");
        $finish;
    end
    
    // Monitoreo de resultados periódico
    always #1000000 begin // Cada 1 ms
        $display("%10t |    %b    |    %b    | %8d | Monitoreo periódico", 
                $time, ruido_entrada, senal_sin_ruido, dut.cont);
    end
    
    // Monitoreo de cambios importantes
    always @(ruido_entrada) begin
        $display("%10t |    %b    |    %b    | %8d | Entrada cambió", 
                $time, ruido_entrada, senal_sin_ruido, dut.cont);
    end
    
    always @(senal_sin_ruido) begin
        $display("%10t |    %b    |    %b    | %8d | SALIDA CAMBIÓ", 
                $time, ruido_entrada, senal_sin_ruido, dut.cont);
    end
    
endmodule
