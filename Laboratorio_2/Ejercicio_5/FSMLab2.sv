///////////////////////////////////////////////////////////////////////////////////////////////////
//
// FSMLab2.sv
//
// Este modulo sirve como la Máquina de Estados Finita (FSM) de la Mini Unidad de Cálculo
//
///////////////////////////////////////////////////////////////////////////////////////////////////

module FSMLab2  (
                input logic clk, rst, sw, WE,
                output logic Read_mode, Mux,
                output logic [2:0] leds
                );

// Se crea una estructura de datos numerada para definir con mayor facilidad los estados de la FSM
typedef enum logic [2:0] {
        Inicio  = 3'b000,
        Data_A  = 3'b001,
        Data_B  = 3'b010,
        Data_Op = 3'b011,
        Read    = 3'b100
    } estado;

// Se crean 2 variables del tipo estado, las cuales 
// representan el estado actual y el estado siguiente
estado estado_actual, estado_siguiente;


always @(posedge clk or posedge rst) begin
    if (rst)
        estado_actual <= Inicio; // Si se activa 'rst' se pone el sistema en el estado 'Inicio'
    else
        estado_actual <= estado_siguiente;  // Si no, el estado actual va a ser el mismo que
                                            // el estado siguiente
end

always_comb begin
    
    estado_siguiente = estado_actual;

    Read_mode     = 1'b0;
    Mux         = 1'b0;     // Se inicializan las salidas en 0
    leds[2:0]   = 3'b000;
    

    case (estado_actual)

        Inicio: begin

            Read_mode = 1'b0;
            Mux     = 1'b0;
            
            if (!sw)
                estado_siguiente = Data_A;
            else if (sw)
                estado_siguiente = Read;
            else
                estado_siguiente = Inicio;
        end

        Data_A: begin

            Read_mode   = 1'b0;
            Mux         = 1'b0;
            leds[2:0]   = 3'b001;

            if (WE)
                estado_siguiente = Data_B;
            else if (sw)
                estado_siguiente = Read;
            else
                estado_siguiente = Data_A;
        end

        Data_B: begin

            Read_mode     = 1'b0;
            Mux         = 1'b0;
            leds[2:0]   = 3'b100;

            if (WE)
                estado_siguiente = Data_Op;
            else
                estado_siguiente = Data_B;
        end

        Data_Op: begin

            Read_mode     = 1'b0;
            Mux         = 1'b1;
            leds[2:0]   = 3'b010;

            if (WE)
                estado_siguiente = Data_A;
            else
                estado_siguiente = Data_Op;
        end

        Read: begin

            Read_mode = 1'b1;
            Mux     = 1'b0;
            leds[2:0]   = 3'b000;

            if (!sw)
                estado_siguiente = Data_A;
            else
                estado_siguiente = Read;
        end
        
    endcase
end

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////