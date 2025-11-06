///////////////////////////////////////////////////////////////////////////////////////////////////
//
// tb_uart.sv
//
// Este es el testbench de la UART del Lab 3
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_uart;

/////////////////////////////////////// Variables del DUT /////////////////////////////////////////

logic clk, btnu, btnl, btnr, btnc, btnd, uart_rx, uart_tx, tx_busy;
logic [15:0] sw, led;

/////////////////////////////////////// Otras Variables ///////////////////////////////////////////

logic [7:0] byte_aleatorio;
parameter repeticiones = 500;
parameter hasta_llenar = 20;
parameter WIDTH = 8;
parameter DEPTH = 16;
logic [WIDTH-1:0] Kirby [0:repeticiones-1];
logic [8:0] k;

//////////////////////////////////////////// Instancia DUT ///////////////////////////////////////
top_uart DUT(
            .clk     (clk),
            .btnu    (btnu),
            .btnl    (btnl),
            .btnr    (btnr),
            .btnc    (btnc),
            .btnd    (btnd),
            .sw      (sw),
            .uart_rx (uart_rx),
            .uart_tx (uart_tx),
            .led     (led)
            );

// ------------------------------------------------------------------------------------------------
// Declaratoria inicial del clk
// ------------------------------------------------------------------------------------------------
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns per cycle
end

// ------------------------------------------------------------------------------------------------
// Declaratoria inicial del Reset
// ------------------------------------------------------------------------------------------------
initial begin
    btnu = 1;
    btnl = 0;
    btnr = 0;
    btnc = 0;
    btnd = 0;
    sw = 0;
    uart_rx = 1;  // línea idle = 1
    #100;
    btnu = 0;
    k = 0;
end

// ------------------------------------------------------------------------------------------------
// Generador de byte aleatorio
// ------------------------------------------------------------------------------------------------
function logic [7:0] obtener_byte(); return $urandom_range(0,8'hFF); endfunction

// ------------------------------------------------------------------------------------------------
// Loopback UART (TX -> RX)
// ------------------------------------------------------------------------------------------------
task enviar_byte(input logic [7:0] bytea);
    begin
        // Cargar switches
        sw = {8'h00, bytea};
        // Pulsar btnl para escribir en TX FIFO
        #10;
        btnl = 1;
        #10;
        btnl = 0;
        #10;
    end
endtask

// ------------------------------------------------------------------------------------------------
// Leer Kirby
// ------------------------------------------------------------------------------------------------
task leer_Kirby();
    begin
        for (int i = 0; i < DEPTH; i = i + 1)
            $display("Leyendo Kirby[%0d]: %h", i, Kirby[i]);
    end
endtask

// ------------------------------------------------------------------------------------------------
// Vaciar Kirby
// ------------------------------------------------------------------------------------------------
task vaciar_Kirby();
    begin
        for (int i = 0; i < DEPTH; i = i + 1)
            Kirby[i] = 8'h00;
    end
endtask

// ------------------------------------------------------------------------------------------------
// Simular la línea TX -> RX
// ------------------------------------------------------------------------------------------------
task simular_uart_rx();
    integer i;
    logic bit_val;
    begin
        // Esperar que TX FIFO saque el byte
        wait (DUT.tx_busy == 1);   // tx_busy del DUT
        // Esperar el start bit
        @(posedge clk);
        // Start bit
        bit_val = 0;
        uart_rx = bit_val;
        #(8680); // CLKS_PER_BIT * 10ns
        // Data bits LSB -> MSB
        for (i=0; i<8; i=i+1) begin
            bit_val = DUT.txfifo_dout[i];
            uart_rx = bit_val;
            #(8680);
        end
        // Stop bit
        uart_rx = 1;
        #(8680);
    end
endtask

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Tester
///////////////////////////////////////////////////////////////////////////////////////////////////
initial begin

    #200;  // Esperar al reset

    // --------------------------------------------------------------------------------------------
    // Caso 1: Enviar - Leer
    // --------------------------------------------------------------------------------------------

    $display("CASO 1: Enviar - Leer");

    repeat (repeticiones) begin
        
        byte_aleatorio = obtener_byte();

        Kirby[k] = byte_aleatorio;
        k = k + 1;

        enviar_byte(byte_aleatorio);

        // Simular que el byte transmitido llega por la línea RX
        fork
            simular_uart_rx();
        join

        // Leer el byte de RX FIFO
        wait (DUT.rxfifo_count > 0);
        btnr = 1;
        @(posedge clk);
        btnr = 0;
        @(posedge clk); @(posedge clk);

        // $display("C1 | Byte aleatorio generado: %h", byte_aleatorio);
        // $display("C1 | Byte recibido: %h", DUT.last_rx_byte);

        if (DUT.last_rx_byte == Kirby[k-2])
            $display("Funcionanding: Byte recibido coincide con el enviado. ESP: %h, ACT: %h", Kirby[k-2], DUT.last_rx_byte);
        else
            $display("Fallanding: Byte recibido NO coincide con el enviado. ESP: %h, ACT: %h", Kirby[k-2], DUT.last_rx_byte);
    end

    // leer_Kirby();

    repeat (10) @(posedge clk);     // Vaciar FIFOs
    btnu = 1;
    repeat (10) @(posedge clk);
    btnu = 0;

    vaciar_Kirby();
    k = 0;
    
    repeat (500) @(posedge clk);
    
    // --------------------------------------------------------------------------------------------
    // Caso 2: Enviar - Llenar FIFO - Leer
    // --------------------------------------------------------------------------------------------
    $display("CASO 2: Enviar - Llenar FIFO - Leer");

    repeat (hasta_llenar) begin
    byte_aleatorio = obtener_byte();
    
    // $display("C2 | Byte aleatorio generado: %h", byte_aleatorio);

        Kirby[k] = byte_aleatorio;
        k = k + 1;

        enviar_byte(byte_aleatorio);

    // Simular que el byte transmitido llega por la línea RX
    fork
        simular_uart_rx();
    join
    end
    
    #10;
    k = 0;
    #10;
    
    repeat (hasta_llenar) begin
    // Leer el byte de RX FIFO
    btnr = 1;
    @(posedge clk);
    btnr = 0;
    @(posedge clk); @(posedge clk);

    if (DUT.last_rx_byte == Kirby[k-1])
            $display("Funcionanding: Byte recibido coincide con el enviado. ESP: %h, ACT: %h", Kirby[k-1], DUT.last_rx_byte);
        else
            $display("Fallanding: Byte recibido NO coincide con el enviado. ESP: %h, ACT: %h", Kirby[k-1], DUT.last_rx_byte);
    
    k = k + 1;

    // $display("C2 | Byte recibido: %h", DUT.last_rx_byte);
    end

    repeat (500) @(posedge clk);

    $finish;

/*

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                               Scoreboard
///////////////////////////////////////////////////////////////////////////////////////////////////

    if (DUT.last_rx_byte === Kirby[k-1]) begin
        $display("Funcionanding: Byte recibido coincide con el enviado");
        k = k + 1;
    end
    else
        $display("Fallanding: Byte recibido NO coincide con el enviado");


    repeat (500) @(posedge clk);
    $finish;
end

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                               GTKWAVE
///////////////////////////////////////////////////////////////////////////////////////////////////

initial begin
    $dumpfile("tb_uart.vcd");   // archivo VCD
    $dumpvars(0, tb_uart);      // volcar todas las señales del testbench
end

*/
end

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////