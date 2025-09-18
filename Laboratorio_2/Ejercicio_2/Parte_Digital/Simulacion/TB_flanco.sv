//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 21:54:37
// Design Name: 
// Module Name: TB_flanco
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


module TB_flanco();
// Señales de entrada
    logic clk;
    logic rst;
    logic senal_entrada;
    
    // Señales de salida
    logic flanco_positivo;
    
    // Instanciar el módulo bajo prueba
    detector_flanco dut (
        .clk(clk),
        .rst(rst),
        .senal_entrada(senal_entrada),
        .flanco_positovo(flanco_positivo)
    );
    
    // Generación de reloj (10 MHz - periodo 100 ns)
    always #50 clk = ~clk;
    
    // Procedimiento de prueba
    initial begin
        // Inicializar señales
        clk = 0;
        rst = 1;
        senal_entrada = 0;
        
        // Header de la simulación
        $display("====================================================");
        $display("Testbench para detector_flanco (10 MHz)");
        $display("====================================================");
        $display("Tiempo(ns) | clk | rst | Entrada | Salida | Comentario");
        $display("----------------------------------------------------");
        
        // Reset inicial (2 ciclos)
        #100;
        rst = 0;
        #100;
        
        // Test 1: Flanco positivo simple
        senal_entrada = 1;
        #300;
        
        // Test 2: Flanco negativo (no debe detectarse)
        senal_entrada = 0;
        #300;
        
        // Test 3: Múltiples flancos positivos
        senal_entrada = 1;
        #100;
        senal_entrada = 0;
        #200;
        senal_entrada = 1;
        #100;
        senal_entrada = 0;
        #200;
        
        // Test 4: Rebotes en el flanco positivo
        senal_entrada = 1;
        #20;
        senal_entrada = 0;
        #15;
        senal_entrada = 1;
        #25;
        senal_entrada = 0;
        #10;
        senal_entrada = 1;
        #300;
        
        // Test 5: Señal mantenida en alto
        senal_entrada = 0;
        #200;
        senal_entrada = 1;
        #500;
        senal_entrada = 0;
        
        // Finalizar simulación
        #200;
        $display("====================================================");
        $display("Simulación completada");
        $display("====================================================");
        $finish;
    end
    
    // Monitoreo de resultados en cada flanco de reloj
    always @(posedge clk) begin
        $display("%9t |  %b  |  %b  |    %b     |    %b     | Flanco de reloj", 
                $time, clk, rst, senal_entrada, flanco_positivo);
    end
    
    // Monitoreo de cambios en la entrada
    always @(senal_entrada) begin
        $display("%9t |  %b  |  %b  |    %b     |    %b     | Entrada cambió", 
                $time, clk, rst, senal_entrada, flanco_positivo);
    end
    
    // Monitoreo de reset
    always @(rst) begin
        $display("%9t |  %b  |  %b  |    %b     |    %b     | Reset cambió", 
                $time, clk, rst, senal_entrada, flanco_positivo);
    end
    
endmodule
