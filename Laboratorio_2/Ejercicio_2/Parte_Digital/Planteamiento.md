# Módulos utilizados para la implementación del sistema de anti rebote de forma digital.

## a) Filtro anti rebote:

  Este módulo recibe la señal directa del pulsador, la idea es que esper un tiempo definido, hasta que la señal se logre estabilizar antes de ser considerado valor.

## b) Sincronizador:

  En sí la señal al provenir de un botón que es un instrumento asincrónico, es necesario sincronizarlo para que este funcione correctamente en la FPGA. Esto se logra utilizando dos flip-flop en serie, el primero se encarga de tomar la señal asincrónica, y el segundo la entrega ya estabilizada al dominio del reloj. Con esto se asegura que la señal queda sincronizada con el reloj.

## c) Detector de flanco:

  Se utiliza para que detecte el flanco de subida, de la señal de anti rebote y genere un pulso corto, se utiliza para el contador.

## d) Contador de pruebas:

  Cuenta el número de pulsos limpios que llegan desde el módulo de anti rebote, permitiendo comprobar una pulsación realizando un incremento al contador, luego si no hay incrementos extras, lo que permite confirmar que el anti rebote funciona como debería.

## e) Utilización del IP Catal (Clock Wizard):

  Ya el módulo esta guardado con las especificaciones necesarias, antes de correr el programa, es necesario ir a source, buscar el que tenga el nombre de clk_wiz, se debe dar click derecho y en Re-Custimize y darle  darle OK, luego click derecho y luego en # Generate Outputs Productos, para que genere todo lo necesario para que lo demás funcione.

## f)El module top:

  Es utilizado para realizar todas las conexiones necesarias 

# Resultados importantes 
