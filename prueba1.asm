; ------------------------------------------------------------------------------ -
; Universidad del Valle de Guatemala | Departamento de Ciencias de la Computación
; Ciclo: 1
; año cursando : 2
; año presente : 2023
; autores: Pablo Daniel Barillas Moreno | Carné No. 22193, Diego Rizzo | Carné No. 22955 y David Trujillo | Carné No. 22592
; Curso: Organización de computadoras y Assembler | sección : 30
; Catedrático: Licda. Kimberly Barrera
; Auxiliares: Fabian Juárez y Sara Pérez
; Nombre: proyecto 4.asm
; Descripción: Carrera de obstaculos - Temario 2
; Fecha: 01 / 06 / 2023
; ------------------------------------------------------------------------------ -

; Configuración y comentarios sobre el programa que está destinado a la arquitectura x86

.386
.model flat, stdcall, c
.stack 4096

; ----------------------------------------------- 
; SECCION DE DECLARACIÓN DE VARIABLES
; ----------------------------------------------- 

.data
    
    msg0 BYTE '----------------------------------------------------------------------------------------------------------------------------------', 0
    msg2 BYTE 'Tira, lanza y gana!',0Ah, 0
    msg3 BYTE '----------------------------------------------------------------------------------------------------------------------------------', 0
    msg4 BYTE '----------------------------------------------------------------------------------------------------------------------------------', 0
    msg5 BYTE ' ____  ____  ____  ____  ____  ____  ____  _________  ____  ____  _________  ____  ____  ____  ____  ____  ____  ____  ____  ____ ', 0
    msg6 BYTE '||C ||||a ||||r ||||r ||||e ||||r ||||a ||||       ||||d ||||e ||||       ||||o ||||b ||||s ||||t ||||c ||||u ||||l ||||o ||||s ||', 0
    msg7 BYTE '||__||||__||||__||||__||||__||||__||||__||||_______||||__||||__||||_______||||__||||__||||__||||__||||__||||__||||__||||__||||__||', 0
    msg8 BYTE '|/__\||/__\||/__\||/__\||/__\||/__\||/__\||/_______\||/__\||/__\||/_______\||/__\||/__\||/__\||/__\||/__\||/__\||/__\||/__\||/__\|', 0Ah, 0
    msg9 BYTE '========================================================= Menu principal =========================================================', 0Ah, 0
    msg10 BYTE 0Ah, 'Por favor elija una de las siguientes opciones:',0Ah, 0
    msg11 BYTE 0Ah, '--- 1. Iniciar partida del juego ---',0Ah, 0
    msg12 BYTE 0Ah, '--- 2. Ver instrucciones y reglas del juego ---',0Ah, 0
    msg13 BYTE 0Ah, '--- 3. Salir del juego ---',0Ah, 0
    msg135 BYTE 0Ah, 'Introduzca un numero del 1 al 6: ', 0
    msg14 BYTE 0Ah, 'Ingresa el numero de opcion que desee seleccionar: ', 0
    msg15 BYTE 0Ah, 'Saliendo del programa... procesando....', 0Ah, 0
    msg16 BYTE 0Ah, 'a retrocedido: %d', 0
    msg17 BYTE 0Ah, 'Ha salido en el dado 1; %d', 0Ah, 0
    msg18 BYTE 0Ah, 'Ha salido en el dado 2: %d', 0Ah, 0
    msg19 BYTE 0Ah, 'por lo tanto en total se mueve: %d, casillas', 0Ah, 0
    masgIns1 BYTE 0Ah,'---------- Reglamento y contexto del juego -----------',0Ah, 0
    masgIns2 BYTE 0Ah,'===--- Contexto del juego Carrera de obstaculos ---===', 0Ah, 0
    masgIns3 BYTE 0Ah,'Usted el jugador esta atrapado en una zona peligrosa de', 0Ah, 0
    masgIns4 BYTE 0Ah,'la ciudad, y por obvias razones usted quiere salir lo mas', 0Ah, 0
    masgIns5 BYTE 0Ah,'rapido posible de alli, para hacerlo debera de cruzar un', 0Ah, 0
    masgIns6 BYTE 0Ah,'camino para poder hacerlo, intente salir de esa zona antes',0Ah, 0
    masgIns7 BYTE 0Ah,'de que lo atrapen!.', 0
    masgIns8 BYTE 0Ah, '===========================================================', 0Ah, 0
    masgIns9 BYTE 0Ah, 'Usted el jugador lanza dos dados (maximo 6 veces), esto por', 0Ah, 0
    masgIns10 BYTE 0Ah, 'medio de una mensaje que dira que elija un numero entre 1 y', 0Ah, 0
    masgIns11 BYTE 0Ah, '6, posteriormente se le notificara por medio de dos mensajes los',0Ah,  0
    masgIns12 BYTE 0Ah, 'cuales le diran los numeros que le salieron en cada dado y la suma',0Ah, 0
    masgIns13 BYTE 0Ah, 'de las cantidades de los dados, con esto avanza la cantidad de pasos',0Ah, 0
    masgIns14 BYTE 0Ah, 'indicados por los dados.', 0
    masgIns15 BYTE 0Ah, '===========================================================',0Ah, 0
    masgIns16 BYTE 0Ah, 'Reglas principales para jugar Carrera de obstaculos',0Ah, 0
    masgIns17 BYTE 0Ah, '* Si al tirar los dados ambos son iguales, usted el jugador ',0Ah, 0
    masgIns18 BYTE 0Ah, 'retrocederá 10 pasos',0Ah,  0
    masgIns19 BYTE 0Ah,'* Si llega a la meta o la sobrepasa antes de 6 intentos de',0Ah, 0
    masgIns20 BYTE 0Ah, 'lanzamientos de dados, entonces cruza la meta, y gana el juego.',0Ah, 0
    masgIns21 BYTE 0Ah, 'medio de una mensaje que dira que elija un numero entre 1 y 6',0Ah, 0
    masgIns22 BYTE 0Ah,'Presione enter para continuar.... ',0Ah, 0

    prove DWORD 0
    format BYTE "%d", 0
    random DWORD 0
    dado1 DWORD 0
    dado2 DWORD 0
    cellFormat BYTE "|%d| ",0
    userCellFormat BYTE 1Bh,"[0;31m|%d|",1Bh,"[0m ",0
    i DWORD 0
    cellsMax DWORD 50
    userPosition DWORD 29
    fmt db "%d",0Ah, 0
    redPosition DWORD 0
    arr DWORD 10, 20, 30, 40, 20, 60
    
; ----------------------------------------------- 
; SECCION DE DEFINICIÓN DE CÓDIGO
; ----------------------------------------------- 
; ------------ Librerías utilizadas -------------

.code

    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    printf proto c : vararg
    scanf proto c : vararg
    rand proto c : vararg
    _getch proto c : vararg

; ------------ Rutina Principal -------------

public main
main proc

    invoke printf, offset msg0		; Imprimir mensaje p/contexto de programa
   	
    invoke printf, offset msg5
    invoke printf, offset msg6
    invoke printf, offset msg7
    invoke printf, offset msg8
    invoke printf, offset msg9


    prove1:

    invoke printf, offset msg10
    invoke printf, offset msg11
    invoke printf, offset msg12
    invoke printf, offset msg13
    invoke printf, offset msg14
    invoke scanf, offset format, offset prove 

    cmp prove, 1 
    je prove1
    cmp prove, 2
    je prove2
    cmp prove, 3
    je prove3

    invoke printf, offset msg0		; Imprimir mensaje p/contexto de programa

    invoke printf, offset msg2		; Imprimir mensaje p/indicar elementos de array

    invoke printf, offset msg0

    invoke printf, offset masgIns22
    invoke _getch
    jmp prove1


    prove2:

    invoke printf, offset msg0		; Imprimir mensaje p/contexto de programa

    invoke printf, offset msg2		; Imprimir mensaje p/indicar elementos de array

    invoke printf, offset msg0

    invoke printf, offset masgIns1
    invoke printf, offset masgIns2
    invoke printf, offset masgIns3
    invoke printf, offset masgIns4
    invoke printf, offset masgIns5
    invoke printf, offset masgIns6
    invoke printf, offset masgIns7
    invoke printf, offset masgIns8
    invoke printf, offset masgIns9
    invoke printf, offset masgIns10
    invoke printf, offset masgIns11
    invoke printf, offset masgIns12
    invoke printf, offset masgIns13
    invoke printf, offset masgIns14
    invoke printf, offset masgIns15
    invoke printf, offset masgIns16
    invoke printf, offset masgIns17
    invoke printf, offset masgIns18
    invoke printf, offset masgIns19
    invoke printf, offset masgIns20
    invoke printf, offset masgIns21

    invoke printf, offset masgIns22
    invoke _getch
    jmp prove1

    prove3:

    invoke printf, offset msg0		; Imprimir mensaje p/contexto de programa

    invoke printf, offset msg15		; Imprimir mensaje p/indicar elementos de array

    invoke printf, offset msg0

    RET


tablero: 

    invoke printf, offset msg3		; Imprimir mensaje p/sumatoria
    
    call GenerateRandomNumbers      ; se llama a la subrutina para el dado 1
    mov EAX, random
    mov dado1, EAX
    invoke printf, offset dado1

    call GenerateRandomNumbers      ; se llama a la subrutina para el dado 2
    mov EAX, random
    mov dado2, EAX
    invoke printf, offset dado2

    ploop:
        
        inc i
        mov EAX, i
        .IF EAX == userPosition
        invoke printf,offset userCellFormat, i
        .ELSE
        invoke printf,offset cellFormat, i
        .ENDIF
        cmp i, 50
        jl ploop

	ret

    ;Cambio de posición del color rojo en el tablero del usuario

    mov EAX, userPosition
    cmp EAX, redPosition
    jne skipRedPositionUpdate
    invoke printf, offset userCellFormat, EAX
    jmp endRedPositionUpdate
    skipRedPositionUpdate:
    invoke printf, offset cellFormat, EAX
    endRedPositionUpdate:

    ret

     ; Verificación de límites

    cmp EAX, 0
    jl redPositionLowerLimit
    cmp EAX, 50
    jg redPositionUpperLimit

    invoke printf, offset userCellFormat, EAX
    jmp endRedPositionUpdate

    redPositionLowerLimit:
    invoke printf, offset userCellFormat, 0
    jmp endRedPositionUpdate

    redPositionUpperLimit:
    invoke printf, offset userCellFormat, 50
    jmp endRedPositionUpdate


main endp

; ------------ SUBRUTINA -------------
;___________________________________________
;GenerateRandomNumbers
;input: No utiliza
;output: Variable random
;___________________________________________

GenerateRandomNumbers proc

    invoke rand
    mov EDX, 0
    mov EBX, 6
    div EBX
    inc EDX
    mov random, EDX
 
    ret 

GenerateRandomNumbers endp

end