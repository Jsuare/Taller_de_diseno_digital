Instituto Tecnológico de Costa Rica

Taller de Diseño Digital
Grupo 20


# Laboratorio 2: Cuestionario Previo


Profesor Luis Carlos Rosales Alpizar


## Estudiante:

Carlos Daniel Hurtado Villalobos || 2021067615
Jean Paul Dobrosky Espinoza || 2021079467
Victor Alejandro Sánchez Cáceres || 2021079432
Francisco Javier Suárez Sarmiento || 201333949
Luis Pablo Vargas Muñoz || 2021490483


ll Semestre || 02/09/2025




### 1.Investigue cuál es el funcionamiento de las máquinas de estado finito. Explique la diferencia entre una máquina de Moore y una de Mealy, y muestre la diferencia por medio de diagramas de estados y señales.
 Una máquina de estados finitos (FSM) es un modelo matemático que describe el comportamiento de un sistema secuencial mediante un conjunto finito de estados. Estas máquinas funcionan con un estado actual, un conjunto de entradas, un conjunto de salidas, y un conjunto de reglas de transición que definen cómo pasar de un estado a otro según las entradas. Siempre existe un estado inicial y, dependiendo de la entrada recibida, la máquina cambia de estado y genera una salida
En una máquina de Mealy, la salida depende tanto del estado actual como de la entrada. Esto permite que la salida cambie de manera inmediata cuando cambia la entrada, sin necesidad de esperar una transición de estado. Como resultado, las máquinas de Mealy suelen requerir menos estados y reaccionan más rápido, aunque sus salidas pueden ser menos estables, ya que están directamente influenciadas por las variaciones de la entrada. [1]

Figura 1. Máquina de estados Mealy
En una máquina de Moore, la salida depende únicamente del estado actual en el que se encuentra el sistema. Esto significa que la salida sólo cambia cuando ocurre una transición de estado. La consecuencia es que las salidas son más estables, aunque presentan un retardo porque requieren que el sistema cambie de estado para que se actualicen. Generalmente, estas máquinas necesitan más estados para implementar un mismo comportamiento en comparación con una máquina de Mealy. [2]


Figura 2. Máquina de estados Moore

### 2.Explique los conceptos de setup time y hold time. ¿Qué importancia tienen en el diseño de sistemas digitales?

El setup time o tiempo de preparación es el tiempo mínimo que la señal de entrada debe permanecer estable antes del flanco activo del reloj. Es decir, el dato tiene que estar listo antes de que llegue el reloj, para que el flip-flop lo capture correctamente.
Por otro lado, el hold time o tiempo de retención es el tiempo mínimo que la señal debe mantenerse estable después del flanco activo del reloj, evitando que un cambio demasiado rápido posterior al reloj genere errores de captura. [3]

El cumplimiento de estas restricciones es crucial para el diseño de sistemas digitales porque garantiza la sincronización correcta de los datos y evita fallos lógicos, metaestabilidad o comportamiento impredecible. Además, el setup y el hold determinan la frecuencia máxima de operación de un sistema digital: el setup time, junto con los retardos de la lógica combinacional, fija el período mínimo del reloj, mientras que el hold time asegura que los datos se mantengan estables el tiempo necesario después del flanco de captura.

### 3. Explique los conceptos de tiempos de propagación y tiempos de contaminación en circuitos combinacionales. Investigue sobre la ruta crítica y cómo esta afecta en el diseño de sistemas digitales complejos; por ejemplo, un procesador con pipeline. Investigue su relación con la frecuencia máxima de operación de un circuito.

Para iniciar con esta pregunta debemos de saber qué es un circuito combinacional, este es un sistema digital en el cual las salidas dependen únicamente de los valores actuales de la entrada. Donde podemos ver conceptos como que no tiene una memoria interna coma si cambia las entradas inmediatamente cambia las salidas y está compuesto por compuertas lógicas como lo pueden ser la AND, OR, NOT o XOR. Podríamos decir que sabe frente a un circuito secuencial ya que éste sí posee una memoria en los registros o flip flops y depende tanto de las entradas actuales como el estado pasado, cosa que no pasa con los circuitos secuenciales. [4]
Como ejemplos comunes de circuitos secuenciales tenemos los circuitos sumadores como los multiplexores, los decodificadores o los comparadores de magnitud y codificadores.
Ahora bien el tiempo de propagación o de delay, es el tiempo máximo que tarda la señal en propagarse desde la entrada al circuito  combinacional hasta que la salía alcanza un valor estable y válido esperado para el circuito, esto se puede medir entre el instante en que la entrada cambia y el momento de la salida alcanza el valor esperado, de ahí su nombre ya que es un retraso en el tiempo entre ambas señales por lo cual es la representación del retardo más largo posible de una compuerta o de un conjunto de ellas.
En el caso del tiempo de contaminación este es el tiempo mínimo que tarda un cambio de la entrada en empezar a afectar la salida, es decir ese retardo más corto posible desde que la entrada cambia hasta que la salida empieza a cambiar no sé comparar con el ruido provocado por diferentes señales, pero su nombre nos determina que es una contaminación entre las dos señales tanto de entrada como de salida. También se puede terminar por medio del momento más temprano en que la salida puede dejar de ser válida, esto debido a algún cambio en el circuito secuencial o por una combinación extraña o algún rebote de la señal.
Una ruta crítica en un circuito digital como lo es en la secuencia de compuertas lógicas o secuencial es la ruta o el cableado que interconecta todas estas compuertas con el mayor tiempo de propagación total entre un registro de inicio y un registro destino, es decir es el camino que atraviesa la señal por medio de varias compuertas lógicas hasta llegar a su destino. Se define también como el retraso máximo que necesita un circuito para que una señal viaje desde un punto inicial hasta un punto final [5], esto debe tomar importancia ya que el factor principal para delimitar la velocidad de operación en un sistema digital es esta ruta crítica. Si tomamos el ejemplo de un procesador con pipeline, éste posee varias etapas de secuencias lógicas combinacionales más diferentes registros, por lo cual desde una etapa uno hasta una etapa cinco, debe de haber una ruta que interconecte todas las partes de este procesador, por lo cual esta ruta crítica dependiendo de su longitud para atravesar todas estas etapas determinará el tiempo de velocidad de procesamiento del circuito digital por lo cual si en la etapa uno la ruta crítica es rápida pero en la etapa tres se presenta una velocidad más lenta esto se verá reflejado en la ruta crítica total del circuito. [6] Definiendo así el ciclo de reloj mínimo que se puede usar en todo el procesador, si una etapa tarda demasiado puede reducir la ganancia del pipeline y obligar a usar un reloj más lento.
Claramente si estamos hablando del tiempo este estará ligado a la frecuencia, por lo cual vamos a tener una relación con la frecuencia máxima al instalar ando de los circuitos combinacionales y claramente su ruta crítica. La frecuencia máxima de operación de un circuito sin errores o ideal esta por la siguiente ecuación:

Con 
dónde él pidió mínimo corresponde al período mínimo de tiempo que puede ejecutar un reloj para alcanzar la velocidad esperada en la ruta crítica como dijimos anteriormente. De esta manera sabiendo el tiempo propagación máxima de la lógica combinacional entre registros, más el tiempo de preparación que necesita el flip flop nos dará la frecuencia a la que puede trabajar en circuito de manera que respete los tiempos y evitando fallas en las rutas críticas del circuito convencional. A lo que podemos decir, mientras más larga y compleja sea la ruta crítica más grande será el tiempo de propagación y menor será la frecuencia máxima del reloj. Por lo que si queremos aumentar la frecuencia de un procesador se deben de emplear etapas más optimizadas en la lógica combinacional.

### 4. Investigue sobre las mejores prácticas para la asignación de relojes y división de frecuencia en FPGAs. En este apartado haga énfasis en el uso de las entradas habilitadoras de reloj (clock enables) presentes en las celdas de la FPGA, para lograr tener tiempos de ejecución diferentes a lo largo del sistema mientras se utiliza un solo reloj. 

A la hora de trabajar con relojes dentro de una FPGA, lo ideal es utilizar únicamente una señal de reloj a la frecuencia deseada, preferiblemente lo suficientemente alta como para que pueda cumplir con los requisitos del sistema, y a partir de la frecuencia del reloj principal, realizar contadores o divisiones que permitan “retrasar” la señal de reloj para las partes del circuito que requieren un reloj con menor frecuencia. Esto debido a que crear diferentes señales de reloj independientes entre sí puede llegar a causar problemas de timing, ya que la FPGA sólo reconoce 1 señal como la señal de clk, por lo que las demás señales las asume como variables lógicas, lo cual puede afectar el comportamiento del sistema y llegar a provocar un mayor consumo de energía. Es por este motivo que los flip-flops de las FPGAs tienen una entrada de enable llamada “clock enable”, la cual permite decidir si el registro debe o no tomar datos como entrada. Esto permite dividir la frecuencia a la que trabaja el clk principal para así poder ajustarla a la frecuencia que requiera todo o una parte del circuito. Un ejemplo de cómo aplicar esto es mediante un contador, que recibe una señal de clk de 100 MHz, y por cada ciclo suma 1 a su variable interna, de forma que cuando la variable interna del contador llegue a 9 (10 ciclos porque se empieza desde 0), se active la señal de “clock enable” y así permitir cambios en el circuito. De esta forma, se utilizó un mismo clk principal (que está a 100 MHz) para hacer funcionar una parte del circuito que necesita trabajar a 10 MHz. Es por esto que se recomienda trabajar con un clk principal a una frecuencia alta, para así poder alimentar clks secundarios que necesiten una menor frecuencia, permitiendo así eliminar errores de clk por ir más rápido que lo que necesita el circuito, además de mantener de forma consistente una única señal de clk.
### 5. Investigue sobre el fenómeno de rebotes y ruido en pulsadores e interruptores. Defina qué técnicas digitales y analógicas (circuitos) se utilizan para cancelar este fenómeno. Además, investigue sobre los problemas de metastabilidad cuando se tienen entradas asíncronas en circuitos digitales. Finalmente, presente circuitos que permitan la sincronización de entradas como pulsadores e interruptores

 Fenómeno de rebotes y ruido en pulsadores e interruptores
Según Horowitz y Hill (2015), los contactos mecánicos de un pulsador no realizan una transición limpia entre abierto y cerrado, sino que generan múltiples oscilaciones rápidas conocidas como rebotes, con una duración típica de algunos milisegundos. Esto produce que un sistema digital pueda interpretar varios pulsos cuando en realidad solo ocurrió una pulsación. Además, autores como Tocci et al. (2014) señalan que a este problema se suma el ruido eléctrico, producto de interferencia electromagnética o acoplamientos, que también altera la señal esperada.
 Técnicas analógicas para cancelar el rebote
De acuerdo con Sedra y Smith (2015), una forma clásica de eliminar los rebotes es usar un filtro RC junto con un disparador Schmitt Trigger (por ejemplo, el 74HC14). Este circuito atenúa las oscilaciones de alta frecuencia y asegura transiciones limpias gracias a la histéresis. Por su parte, Floyd (2012) explica que también se pueden usar circuitos monoestables como el temporizador 555 o el 74HC123 para generar un pulso único de duración fija al detectar la pulsación, sin importar el ruido inicial.
 Técnicas digitales para cancelar el rebote
Según Wakerly (2005), una técnica digital común es el muestreo periódico del botón: la señal se lee a intervalos regulares y se acepta el cambio solo si permanece estable durante un número definido de muestras consecutivas. Otra técnica descrita por Mano y Ciletti (2013) es el uso de contadores integradores, donde un registro se incrementa o decrementa con la señal, filtrando así transiciones espurias.
 Metastabilidad en entradas asíncronas
Cummings (2008) explica que la metastabilidad ocurre cuando una señal que no está sincronizada con el reloj llega a un flip-flop y viola los tiempos de setup o hold. En ese caso, la salida del flip-flop puede quedar en un estado indefinido por un tiempo arbitrario. Como indican Wakerly (2005) y también documentos de Xilinx (2009), este problema no se puede eliminar completamente, pero se puede reducir su probabilidad mediante técnicas de sincronización.
 Circuitos para la sincronización de entradas
Según Xilinx (2009), el método más usado para señales de un bit es el sincronizador de dos flip-flops en cascada, que da tiempo a la señal para estabilizarse antes de ser usada por la lógica. En el caso de pulsadores, Horowitz y Hill (2015) recomiendan combinar la sincronización con un debouncer analógico o digital, de manera que la señal final sea tanto estable como libre de rebotes.
sincronizador de dos flip-flops

Figura 3.sincronizador de dos flip-flops
El circuito mostrado es un sincronizador de dos flip-flops, aplicado a la entrada de un pulsador o interruptor. La señal (btn_in) pasa primero por el registro ff1_reg y luego por btn_sync_reg, ambos gobernados por el reloj (clk). De esta forma, la salida (btn_sync) se obtiene estable y libre de problemas de señales asíncronas, cumpliendo con la sincronización necesaria para el uso de pulsadores e interruptores en sistemas digitales.
debouncer digital

Figura 4. debouncer digita
El circuito mostrado es un debouncer digital para pulsadores e interruptores. La señal (btn_in) pasa primero por un contador que mide si el cambio se mantiene estable durante cierto tiempo. Cuando la entrada deja de rebotar, el valor se guarda en el registro de estado y se entrega a la salida (btn_out). De esta forma se eliminan los rebotes mecánicos y se obtiene una señal limpia y confiable para el sistema digital.


### 6. Investigue sobre el concepto de IP-Core. Revise la documentación relativa al uso de las herramientas de IP-Core en Vivado, en particular sobre el Clocking-Wizard, y los IPs de verificación física: ILA (Integrated Logic Analizer) y VIO (Virtual Input/Output). Sobre estos IPs, resuma para qué se utilizan, cómo configurarlos y cómo utilizarlos en su proyecto
Un núcleo de propiedad intelectual (IP), es un bloque funcional de lógica o datos que se utiliza para fabricar una matriz de diversas compuertas programables en campo (como puede ser la FPGA) o un circuito integrado específico de la aplicación para un productos.
En sí el núcleo IP, suele ser un módulo independiente que forma parte de un dispositivo o sistema más grande como un procesador y otro CI complejo, este suele incorporar circuitos electrónicos, que son pertenecientes a un individuo u organización. Ahora bien, dichos núcleos suelen desarrollarse utilizando lenguajes de descripción de hardware, en nuestro caso usando un SystemVerilog. [15]

Así mismo, esto se puede hacer para un Clocking-Wizard, para realizarlo en Vivado, es necesario seguir los siguientes pasos [16]:
Primero se debe ir IP Catalog, que está en la parte izquierda del panel de FLOW MANAGER,
Luego, se debe buscar el apartado que diga FPGA Features and Desing > Clocking y luego a Clocking Wizard
Darle a Customized IP, el cual será añadido. Y se abre la pestaña del clocking wiizard.
Una vez abierto se debe configurar el reloj con la frecuencia en el apartado de INPUT CLOCK FREQUENCY (100MHz) sea la acorde a la palanca que se utiliza y que deba utilizar MMCM en la parte de Primitive, qué es lo más común.
Seleccionar la pestaña de output clocks, se debe revisar que el check de la casilla dos esté seleccionada para poder configurarla también con base a lo que se va a utilizar.
Luego en la pestaña summary verificar que la información sea correcta.
Después se le da a la pestaña de aceptar y generar producto de salida.
Crear instancia del núcleo de reloj generado.
Expandir la rama IP. Se deben de observar dos entradas. La Char fifo IO es la que se incluyó al crear el proyecto. El segundo es clk_core
Expanda el clk_wiz_o > Instantiation Template y doble click sobre clk_core.veo.
Luego configurar la programación según las entradas y salidas.
El núcleo de ILA es un analizador lógico personalizable que se puede utilizar para monitorear cualquier señal interna del diseño. Los pasos a seguir son los siguiente:
Se abre el IP catalog y se busca ILA
Configurar la venta de las opciones generales, sobre todo los Number of probes, que son las señales a monitorear, sample data depth, que sería la profundidad, dicha profundidad determina cuánto tiempo puedes capturar muestras, el otro es relacionado con el modo de captura. Otras a configurar es el Probe_Ports, que depende del puerto que se quiera dar, en su mayoría es el ancho de la primera y segunda señal las que se quieren configurar. Luego la opción de Trigger Options, tenemos el trigger port el número de señales y el trigger width: Ancho total de bits de trigger.
Luego click en Ok y luego generate [17] 

El núcleo de VIO, es una interfaz virtual para estimular y monitorear señales del diseño en tiempo real. Los pasos para llevar a cabo esto son lo siguientes:
Agregar VIO por medio del IP catalog
Configurar sus opciones generales:
PROBE_IN PORTS:
Input probe count: que sería el número de señales a monitorear (depende de la aplicación).
Output probe count: Número de señales a controlar
PROBE_IN PORTS:
Probe_in0: ancho de la señal de entrada (depende de bitstream de mi señal)
Probe_in1: ancho de otras señales
Probe_OUT PORTS:
Probe_out0: la cual sería el ancho de la salida de la señal
Probe_out1: lo mismo pero para otras señales. [18]
		
 


## Referencias:

[1] Mealy, G. H. (1955). A method for synthesizing sequential circuits. Bell System Technical Journal, 34(5), 1045–1079

[2] Moore, E. F. (1956). Gedanken-experiments on Sequential Machines. In C. E. Shannon & J. McCarthy (Eds.), Automata Studies (pp. 129–154). Princeton, NJ: Princeton University Press

[3] IDC Online. (s.f.). Setup and hold time definition. Recuperado de https://www.idc-online.com/technical_references/pdfs/electronic_engineering/Setup_and_hold_time_definition.pdf

[4] 1.4. Circuitos combinacionales: puertas lógicas,” Google.com. [Online]. Available: https://sites.google.com/site/sistemasdemultiplexado/principios-de-electrnica-digital-y-puertas-lgicas/1-4-circuitos-combinacionales-puertas-logicas. [Accessed: 28-Aug-2025].

[5] Mohanram, K. Sequential Circuit Analysis. University of Pittsburgh. Recuperado de: http://www.pitt.edu/ kmram/0132/lectures/sequential-circuit-analysis.pdf

[6] E. e. I. de T. de D. D. P. un M. De propósito general, “Instituto Tecnológico de Costa Rica Escuela de Ingeniería Electrónica,” Tec.ac.cr. [Online]. Available: https://repositoriotec.tec.ac.cr/bitstream/handle/2238/10411/diseno_estudio_implementacion_tecnicas_diseno.pdf?sequence=1&isAllowed=y. [Accessed: 28-Aug-2025]

[7] P. Horowitz y W. Hill, The Art of Electronics, 3rd ed. Cambridge University Press, 2015.

[8] R. L. Tocci, N. S. Widmer y G. L. Moss, Digital Systems: Principles and Applications, 11th ed. Pearson, 2014.

[9] A. S. Sedra y K. C. Smith, Microelectronic Circuits, 7th ed. Oxford University Press, 2015.

[10] T. L. Floyd, Principios de Circuitos Eléctricos, 8va ed. Pearson, 2012.

[11] J. F. Wakerly, Digital Design: Principles and Practices, 4th ed. Pearson, 2005.

[12] M. M. Mano y M. D. Ciletti, Digital Design, 5th ed. Pearson, 2013.

[13] C. E. Cummings, “Clock Domain Crossing (CDC) Design & Verification Techniques Using SystemVerilog,” SNUG 2008 Proceedings, Synopsys, 2008.

[14] Xilinx Inc., “Metastability in FPGAs,” Application Note XAPP094, 2009.

[15] R. Awati, «intellectual property core (IP core)», WhatIs, 2 de noviembre de 2022. https://www.techtarget.com/whatis/definition/IP-core-intellectual-property-core

[16] «Using the IP Catalog and IP Integrator», FPGA Design With Vivado. https://xilinx.github.io/xup_fpga_vivado_flow/lab4.html

[17] «AMD Technical Information Portal». 
https://docs.amd.com/r/en-US/ug994-vivado-ip-subsystems/Validating-the-System-ILA

[18] «AMD Technical Information Portal». https://docs.amd.com/r/en-US/ug936-vivado-tutorial-programming-debugging/Step-1-Creating-a-Project-with-the-Vivado-New-Project-Wizard?tocId=cmfuknoZnzUSews_HlR2PA



