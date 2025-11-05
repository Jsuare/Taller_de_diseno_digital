# Investigación previa
Para el desarrollo de este proyecto se debe indagar sobre los siguiente aspectos:
1. Investigue sobre la arquitectura RISC-V. Preste especial atención a las instrucciones que
forman parte del conjunto básico de instrucciones para números enteros de 32 bits, rv32i.
## Respuesta:  
La arquitectura RISC-V (Reduced Instruction Set Computing - V) es una arquitectura de conjunto de instrucciones ISA, abierta y libre que está diseñada para ser simple, flexible y extensible. Convirtiéndose en una de las arquitecturas más importantes y prometedoras en el campo de la computación personalizada.

### Características Generales de RISC-V
1. Abierto y libre: Cualquier persona puede utilizar y modificar el diseño de la ISA sin restricciones.
2. Modularidad: La arquitectura RISC-V permite agregar extensiones, se pueden agregar instrucciones y características adicionales sin romper la compatibilidad con el conjunto de instrucciones básico.

### Conjunto de Instrucciones Básico:
El conjunto de instrucciones rv32i es la implementación básica de 32 bits de RISC-V, y define un conjunto mínimo de instrucciones necesarias para la programación de enteros de 32 bits.

### El conjunto rv32i está compuesto por las siguientes categorías de instrucciones:
1. Instrucciones de Carga/Almacenamiento:
1.1 LB (Load Byte): Carga un byte desde memoria.
1.2 LH (Load Half): Carga una mitad de palabra (2 bytes).
1.3 LW (Load Word): Carga una palabra (4 bytes).
1.4 SB (Store Byte): Almacena un byte en memoria.
1.5 SW (Store Word): Almacena una palabra (4 bytes) en memoria.

2. Instrucciones de Aritmética Entera:
2.1 ADD (Addition): Suma dos operandos.
2.2 SUB (Subtraction): Resta dos operandos.
2.3 SLL (Shift Left Logical): Desplazamiento lógico hacia la izquierda.
2.4 XOR (Exclusive OR): Operación XOR.
2.5 SRL (Shift Right Logical): Desplazamiento lógico hacia la derecha.
2.6 OR (OR): Operación lógica OR.
2.7 AND (AND): Operación lógica AND.

3. Instrucciones de Comparación y Salto:
3.1 BEQ (Branch if Equal): Salto si los dos registros son iguales.
3.2 BNE (Branch if Not Equal): Salto si los dos registros no son iguales.
3.3 BGEU (Branch if Greater or Equal Unsigned): Salto sin signo.
3.4 JAL (Jump and Link): Salta a una dirección y almacena la dirección de retorno.

4. Instrucciones de Control de Flujo:
4.1 JAL (Jump and Link): Realiza un salto a una dirección especificada y almacena la dirección de retorno.
4.2 JALR (Jump and Link Register): Similar a JAL, pero la dirección de salto se calcula con un registro y una constante.

5. Instrucciones de Control de Programa:
5.1 ECALL: Llama al sistema operativo para realizar una llamada de sistema.

6. Instrucciones de Registro Inmediato:
6.1 ADDI (Add Immediate): Suma un valor inmediato a un registro.
6.2 XORI (XOR Immediate): Realiza una operación XOR con un valor inmediato.
6.3 SLLI (Shift Left Logical Immediate): Desplazamiento lógico hacia la izquierda con un valor inmediato.
6.4 SRLI (Shift Right Logical Immediate): Desplazamiento lógico hacia la derecha con un valor inmediato.

### Formatos de Instrucción
Las instrucciones de RISC-V utilizan varios formatos según el tipo de operación:
1. R-Type: Instrucciones aritméticas y lógicas que operan sobre registros.
Ejemplo: ADD, SUB, AND, OR.
2. I-Type: Instrucciones que involucran un registro y un valor inmediato (constante).
Ejemplo: ADDI, SLTI, XORI.
3. S-Type: Instrucciones de almacenamiento que involucran un registro y un valor inmediato, y almacenan en memoria.
Ejemplo: SW, SH, SB.
4. B-Type: Instrucciones de salto condicional que comparan registros.
Ejemplo: BEQ, BNE, BLT.
5. U-Type: Instrucciones de salto con una dirección de 20 bits.
Ejemplo: LUI, AUIPC.
6. J-Type: Instrucción de salto absoluto con un valor inmediato de 20 bits.
Ejemplo: JAL.

### Ventajas de RISC-V
RISC-V es una arquitectura de instrucciones poderosa y versátil, con un diseño limpio y abierto que favorece la personalización, la investigación y la educación. Su conjunto básico de instrucciones rv32i cubre las necesidades esenciales de un procesador de 32 bits, y su capacidad de expansión permite crear sistemas altamente especializados. La modularidad y flexibilidad que ofrece la arquitectura lo convierten en una opción cada vez más atractiva frente a otras arquitecturas propietarias como ARM.

2. Investigue sobre las diferencias entre un lenguaje de programación como C y ensamblador.
Explique qué es bare-metal programming.

3. Investigue sobre cómo se almacenan los datos en una memoria. ¿Qué es little-endian y
big-endian?

4. Explique el concepto de periféricos mapeados en memoria. ¿Cuál es el método utilizado
para leer o escribir datos/instrucciones a un periférico?

5. Investigue sobre el uso de los IP-Cores en Vivado para memorias RAM y ROM, así como el
ADC para entradas analógicas.


# Referencia:
1.	“Home,” RISC-V International, 04-Sept-2024. [Online]. Available: http://riscv.org/. [Accessed: 05-Nov-2025].
2.	“Ratified specification,” RISC-V International, 27-Aug-2024. [Online]. Available: https://riscv.org/specifications/ratified/. [Accessed: 05-Nov-2025].
3.	“RV32I, RV64I Instructions — riscv-isa-pages documentation,” Github.io. [Online]. Available: https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html. [Accessed: 05-Nov-2025].
