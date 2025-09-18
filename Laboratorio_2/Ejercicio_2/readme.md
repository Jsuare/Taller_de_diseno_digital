# Ejercicio 2- Diseño anti rebotes y sincronizador
 1. Escriba los bloques digitales necesarios para eliminar rebotes y sincronizar entradas provenientes de pulsadores (push button) e interruptores. Elabore un diagrama de bloques.
 2. Incluya en su diseño y diagrama de bloques contador de pruebas de la Figura 1, el cual
 le será dado. El bloque está sincronizado con el reloj por medio de la entrada clk. Además,
 hace uso de un reset rst activo en bajo. Una señal habilitadora activa en alto, EN,
 permite realizar un incremento cada vez que se da un flanco positivo en esta señal. Una
 señal con rebotes puede causar conteos indeseados.
 3
Figura 1: Contador de pruebas para sistema anti rebote.
 3. Genere pruebas en la tarjeta con FPGA empleando un bloque de pruebas que reciba como
 entrada uno de los pulsadores presentes en la tarjeta y lo use como EN de su circuito
 contador. La señal proveniente del botón debe ser procesada por su bloque sincronizador
 y anti rebote.
 4. En su bloque (módulo) superior (top) haga uso de los LED incluidos en la tarjeta para
 mostrar la salida de su contador.
 5. Escriba un testbench para su sistema. Elabore una prueba con el escenario de un pulso
 contaminado por rebotes y que se repita varias veces. Asegúrese de realizar las mismas
 simulaciones en post-implementación.
 6. Descargue el diseño a la tarjeta con FPGA y verifique su diseño. Asegúrese de asignar
 apropiadamente las señales.   
 7. Reemplace el uso de pulsadores integrados en la tarjeta con FPGA y utilice pulsadores
 externos que tendrá que implementar con una protoboard. Utilice un circuito analógico para
 eliminar los rebotes. Emplee un osciloscopio para validar el filtrado de los rebotes y validar
 la señal con y sin rebotes. Utilice los pulsadores externos para interactuar con el contador
 de pruebas proveído.

# Explicación general del problema 
La idea es poder usar pulsadores o interruptores mecánicos para dar entradas a una FPGA o a cualquier sistema digital, el detalle es que hay un problema importante al implementar esto.
Uno de ellos es relacionado con los contactos mecánicos, puesto que estos al ser accionados y al volverse a levantar generar rebotes, estos rebotes no son deseados cuando se requiere tener un estado lógico de 0 o 1. Esto no provoca falsos pulsos, haciendo que la FPGA interprete que se acciono varias veces los botones.
Por lo tanto, el diseño debe eliminar los rebotes y entregar a la FPGA un único pulso por cada que se presione el botón.
Otro de las cosas que debe realizar el diseño es relacionado con la sincronización de esta señal a la frecuencia de reloj propiamente dado en la FPGA, para evitar problemas de metastabilidad.
Y otro es contar los eventos para verificar que el sistema detecta correctamente las pulsaciones.
