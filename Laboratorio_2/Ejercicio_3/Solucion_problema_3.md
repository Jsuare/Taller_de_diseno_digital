# 4.3. Ejercicio 3. Decodificador para display de 7 segmentos
1. Revise la documentaci´on de la tarjeta Digilent Nexys4 sobre el módulo de 7 segmentos
incluido.
2. Desarrolle un registro parametrizable, de entrada y salida paralela, y con write enable
(WE).
3. Por medio de los dos bloques anteriores, desarrolle un sistema, como el mostrado en la
Figura 2, que permita mostrar en los display de 7 segmentos el contenido de un registro de
16 bits.
4. Escriba un bloque de pruebas que genere datos pseudo-aleatorios (considere implementar,
o utilizar, un LFSR - Linear-Feedback Shift Register) aproximadamente cada 2 segundos y
los escriba en el registro de 16 bits.
5. Escriba un testbench para su sistema, asegúrese de realizar las simulaciones post-síntesis y
post-implementación. Puede ajustar el tiempo de generación de números pseudo-aleatorios
para reducir el tiempo de simulación.
6. Descargue el diseño a la tarjeta con FPGA y verifíquelo. Asegúrese de asignar apropiadamente las señales a las entradas y salidas del chip de FPGA a los dispositivos conectados.



# Objetivo 
Desarrollar un bloque decodificador de hexadecimal (4 bits) a un display de 7 segmentos.

# Planteamiento de la solución
Diseñar un decodificador 4→7 para display de 7 segmentos que muestre valores hexadecimales (0..F). Donde por medio de los 16 interruptores del la tarjeta Nexy 4 organizarmos en 4 grupos de 4 (cada grupo = un nibble) y, usando 2 botones, seleccionar cuál de las 4 entradas mostrar en el display mediante multiplexado.





## Entradas:
Los interruptores de la NExy 4 que esta bajo el nombre sw[15:0] 
Entonces son 16 interruptores organizados en 4 grupos: sw[3:0], sw[7:4], sw[11:8], sw[15:12])
También contamos con los botones del la tarjeta btn[1:0] de manera que son dos botones.

## Salidas:
La tarjeta trae incluido como periferico un seg[6:0] donde se debe de mostrar por medio de la uluminción de los leds las variables de salida.
Tmabién se debe de tomar en cuenta el an[3:0] (anodos/cátodos de los 4 dígitos si tu display físico), estos se ilumina si es activa la salidaa.

# Tabla de verdad para el 7 segmento. 

| Entrada (Hex) | Entrada binaria | Segmentos `{a,b,c,d,e,f,g}` | 
| ------------- | --------------- | --------------------------- | 
| 0             | 0000            | 1111110                     | 
| 1             | 0001            | 0110000                     | 
| 2             | 0010            | 1101101                     |
| 3             | 0011            | 1111001                     | 
| 4             | 0100            | 0110011                     | 
| 5             | 0101            | 1011011                     | 
| 6             | 0110            | 1011111                     | 
| 7             | 0111            | 1110000                     | 
| 8             | 1000            | 1111111                     | 
| 9             | 1001            | 1111011                     | 
| A             | 1010            | 1110111                     | 
| B             | 1011            | 0011111                     | 
| C             | 1100            | 1001110                     | 
| D             | 1101            | 0111101                     | 
| E             | 1110            | 1001111                     | 
| F             | 1111            | 1000111                     | 

## Planteamiento de la solución del ejercicio.

## Decodificación hexadecimal de 7segmento
Se recibe un número de 4 bits que van de 0 a F en hexadecimal, y enciende los segmentos correctos en el display. De manera que se va hacer una cuenta en aumento en el display. 

Decodificador Hex→7 segmentos:
Convierte un valor hexadecimal de 4 bits en las señales necesarias para encender los segmentos del display y representar los dígitos del 0 al F.

## Registro de 16 bits con WE
Este es para generar un registro de un pulso en WE=1, guarda el valor de entrada en un parametro de D[15:0] y lo mantiene en una señal de salida de Q[15:0].

Esto se da por medio de cambios de la señal WE para verificar que la señal guardad en D al ser activada se de la salida en Q.
Registro parametrizable con WE (Write Enable):
Almacena valores de 16 bits (4 dígitos hexadecimales). Solo se actualiza cuando se activa la señal de escritura.

También para tener el control en esto cambios y que se refleje correctamente en el display, se debe de emplear un controlador de displays con un multiplexor, el cuál recibe los 16 bits del registro, dodne se selecciona un nibble de 4 bits a la vez, por cada señal. 
Por medio del decodificador se convierte en un nibble en segementos. Se debe de tener el cuidado de que la velocidad de cambio de la señal de reloj se mantenga bien sincronizado ya que el promedio de cambio es de 1K Hz.

## Generador de números pseudo-aleatorios (LFSR)
Este generador produce la secuencia del pseudo-aleatoria de 16 bits, por medio de la señal de control. También se puede emplear un temporizador para divir el reloj de la FPGA en unos 100M Hz, por cada pulso de 2 segundos.

## Integración del codigo en un TOP.
Tenemos 4 bloques que conforma el top:
1. El LFSR genera el número aleatorio.
2. Un temporizador para la señal de WE cada 2 segundos.
3. Un registro para guardar el numero de D que va a Q.
4. Por ultimo el contador de display el cual será la señal de muestra el contenido del registro en los 4 digitos.

# Solución del problema.

Se creó un diseño de manera que podamos establecer un contador de valores random cada 2 segundos por medio del display de la FPGA, de esta manera podemos ver qué tenemos un módulo top el cual corresponde a la parte principal del sistema digital coma en el cual éste almacena y muestra en el display de 7 segmentos un número pseudo aleatorio de 16 bits (de manera que sólo vamos a trabajar por medio de cuatro displays de los 8 que trae la tarjeta), de esa manera logramos mantener el parámetro  de bits. Ese generador de números aleatorios en formato hexadecimal sea por medio del módulo LFSR qué produce la secuencia pseudo aleatorio a través de un divisor de reloj dónde este divide los 2 segundos para mostrar el nuevo valor de manera que en el primer segundo c determina el valor y en el siguiente segundo se escribe el valor. Dicho pulso se detecta mediante lógica de flanco ascendente para habilitar la escritura del registro mediante el formato pipo de 16 bits, el cual almacena el valor generado, para posteriormente por medio de un contador rápido a través de un multiplexor de los displays se selecciona la secuencia correcta para escribir cada dígito de cuatro bits se realiza su conversión mediante el decodificador de 7 segmentos y esta forma cada 2 segundos se actualiza el valor mostrado a través de los cuatro displays activos de las FPGA. 
Cabe aclarar que el funcionamiento del display de 7 segmentos ya se realizó su explicación y funcionamiento en anteriores proyectos. 

<<<<<<< HEAD

=======
## Explicación de cada modulo. 
1. Generación del número pseudoaleatorio (LFSR): Este módulo nos servirá como el uso de un registro de retroalimentación lineal conocido como LFSR, el cual será el que produce la secuencia pseudo aleatoria de 16 bits. Como sus siglas en ingles un LFSR (Linear Feedback Shift Register) es un registro de desplazamiento con retroalimentación lineal que genera una secuencia de bits pseudoaleatoria. Funciona desplazando sus valores en cada pulso de reloj y calculando el nuevo bit de entrada como una combinación lineal (XOR) de ciertos bits del registro (llamados taps). Por lo cual es un modelo sumamente importante ya que éste se encargará demostrar valores siempre manteniendo el parámetro de 16 bits, pero si recordamos no necesariamente son números si no es una secuencia qué parece aleatorios pero que sigue un patrón repetitivo nada más que al ser de un parámetro de 16 bits eso quiere decir que va a generar 65535 valores distintos antes de repetirse por lo cual una de las pruebas es verificar que ningún valor se repita antes de esas de esas repeticiones. Claramente este modelo tiene una relación muy estricta con el registro que es el lugar donde se guarda para luego muestras en el display. [Ver código](lfsr16.sv)


2. Reloj interno: También debemos recordar que el sistema trabaja con un reloj principal de 100 MHz, donde cada 10 nanosegundos se realiza un pulso alto de cambio, pero en este ejercicio se nos pide mostrar cambios visibles en el display cada 2 segundos por lo que para realizar esta tarea se debe emplear un reloj interno para reducir la frecuencia hasta generar pulsos cada 2 segundos. De esta manera vamos a tener un contador máximo de 200000000 de ciclos que sería nuestro reloj principal y lo dividimos Entre nuestro reloj principal de manera que ha sido tendríamos un periodo de pulsos de 2 segundos. Para que nuestro sistema detecte ese cambio de 2 segundos se genera una señal tic que nos indica el cambio en el display hacia el nuevo valor, de manera que ese pulso cumple una función clave de marcar el momento exacto en el que debe actualizarse el valor mostrado en el display claramente cada 2 segundos dónde dentro de esos 2 segundos se toman un nuevo valor de pseudoaleatorio y cargarlo en el registro PIPO para luego ser mostrado en el display, evitando así que los valores cambien de manera caótica o incorrecta. [Ver código](clk_div.sv)

3. Registro PIPO de 16 bits: El registro PIPO que en sus siglas en inglés (Parallel-In Parallel-Out), es un bloque de memoria secuencial que permite cargar todos los bits de entradas de manera simultánea y entregarlos también en paralelo de ahí sus siglas PIPO es decir, primero en entrar primero en salir. De esta manera podremos tener un almacenamiento más claro práctico y sencillo para el display de manera que no se generen valores repetitivos hasta cumplir la cantidad de ciclos, es decir es un almacenamiento temporal que captura el dato completo en un mismo instante y lo manda a escritura directamente. Es está parametrizado en ancho de 16 bits de esa manera el almacenador del número del pseudoaleatorio generado por él LFSR no tendrá problemas ya que ambos estarán trabajando en mismo ancho de bits. De esta manera este bloque contará con una señal de escritura we, la cual se encargará de habilitar la escritura del dato o del valor cuando el registro indica que debe ser cargado y después cárgala el nuevo dato que sale del registro y así durante todos los ciclos. También tendremos una señal de datos la cual estará en paralelo y eso era nuestra señal proveniente del LFSR. Y obviamente la salía en paralelo qué mantiene el último valor almacenado en el registro. [Ver código](reg_pipo.sv)
4. Para el 7 segmentos se debe de tener una configuración de cadaled que comforma el dispositivo de manera que al tener 4 bits representados por los switch, estos se deben de representar correctamente en el display. También se debde de tener en cuenta la jerarquía de los botones para determinar cual de lo cuatro display se esta utilizando, a partir de la configuración del multiplexor del ejercicio 2 podemos determinar la siguiente tabla:
## Tabla del muxtiplexor para el 7 segmento. 

| Bloque de switch| combinacón del mux | Display|
| --------------- | ------------------ | -------|
| 0               |     00             |    0   |
| 1               |     01             |    1   |
| 2               |     10             |    2   |
| 3               |     11             |    3   |

De está forma en cada display se mostrará la combinacion de bits por así decirlo de los switch en 4 display de manera que se muestre los valores de cero a quince en el 7 segmentos. [Ver código](seg_decoder_hex7.sv)

De manera que podemos trazar una ruta dónde el módulo LFSR de 16 bits genera continuamente números pseudo aleatorios de ese rango, por medio del televisor the below cada pulso de 2 segundos activa por medio de la señal tic un flanco ascendente dónde nos indica a la señal de we que debe escribir en el display, cuando éste se activa el registro pipo captura el valor actual en LFSR y lo mantiene en la salida durante ese período o ciclo de tiempo y este valor es el que se envía al multiplexor de display para ser visualizado en la FPGA. 
De esta manera podemos ver para qué sirve cada módulo y la ruta que se tiene entre ellos para conectarse por medio del módulo top. [Ver código](top.sv) 

En conclusión, el sistema desarrollado permite la generación y visualización de números pseudoaleatorios de 16 bits mediante un diseño digital completamente sincronizado. El divisor de reloj garantiza la actualización cada 2 segundos, mientras que el registro PIPO asegura la estabilidad del valor mostrado en pantalla. A través del multiplexado de los displays, los cuatro dígitos correspondientes al número se presentan de forma continua, y el decodificador de 7 segmentos traduce cada grupo de 4 bits en su representación visual. De esta manera, el proyecto combina técnicas de generación pseudoaleatoria, temporización y visualización en hardware, logrando un sistema eficiente y funcional para la presentación de datos en tiempo real. De manera que esta ruta se puede ver en el siguiente codigo. 

# Testbech y simulaciones 
Se realizo un test bech de manera que podrieramos diseñar y forzar a los valores que consideramos son puntos claves para determinar el funcionamiento del sistema, de está manera nuestro tb_top [Ver código](tb_top.sv)  está diseñado para verificar el correcto funcionamiento del módulo top. Primero, define todas las señales de entrada y salida del DUT, incluyendo clk_i (reloj), rst (reset), en (habilitación), a_to_g (segmentos del display de 7 segmentos), dp (punto decimal) y an (selección de dígito del display). Luego instancia el DUT, asignándole un parámetro MAX_COUNT=1 para acelerar la simulación. Se implementa un generador de reloj de 100 MHz mediante un proceso always que invierte clk_i cada 5 ns. La inicialización comienza con un reset activo durante 50 ns, después del cual se habilita el módulo y se asignan valores iniciales a los registros internos del DUT (q, an, a_to_g y dp). También se imprime una cabecera para la tabla de resultados. 
En cada flanco positivo del reloj, si el DUT está habilitado y no en reset, el testbench incrementa el contador interno q, hace avanzar el patrón de los segmentos a_to_g cíclicamente, alterna el valor del punto decimal dp y rota la señal an para simular la multiplexación de los 4 dígitos del display. Simultáneamente, imprime en consola el tiempo de simulación y los valores actuales de todas las señales de salida relevantes.
Adicionalmente, realiza verificaciones automáticas: comprueba que an siempre tenga un valor válido correspondiente a uno de los dígitos activados, y genera una advertencia si q no cambia de un ciclo al siguiente, lo que podría indicar un fallo en el contador. Finalmente, la simulación se detiene automáticamente después de 20 000 ns para evitar que continúe indefinidamente. Este testbench permite, por tanto, observar el comportamiento dinámico del DUT, validar su lógica de conteo, la multiplexación de displays y la alternancia del punto decimal, asegurando que las señales cumplan con los valores esperados durante toda la simulación.
## Simulación.

En la simulación se observa el comportamiento temporal del sistema diseñado. La señal de reloj principal (clk_i) oscila de forma continua, sirviendo como referencia de sincronización para todos los módulos. La señal de reset (rst) permanece en bajo, ya que no se vio nesesario el verificar su funcionamiento, permitiendo que el circuito opere normalmente, mientras que la señal enable (en) está activa en alto, lo que habilita la carga de los valores pseudoaleatorios.
En la salida del decodificador de 7 segmentos (a_to_g[6:0]) se aprecia cómo van cambiando los patrones hexadecimales que representan cada dígito que se muestra en los displays.
La señal an[7:0] controla la activación de los displays; en la simulación se evidencia la rotación entre ellos según el multiplexado, encendiendo uno a la vez para mostrar el dígito correspondiente. Esto coincide con el valor presente en q_prev[15:0], que corresponde al número pseudoaleatorio generado y almacenado en el registro PIPO.
Finalmente, la señal ciclo[31:0] refleja el conteo interno del sistema, avanzando en forma binaria y asegurando la correcta temporización del multiplexado. En conjunto, la simulación valida que los diferentes módulos trabajan de manera coordinada: el LFSR genera los números, el registro mantiene el valor estable y el multiplexor los presenta secuencialmente en los displays.
>>>>>>> Solucion_ejercicio_3
