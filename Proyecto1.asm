# PROYECTO 1. ORGANIZACION DEL COMPUTADOR 
# INTEGRANTES: GILBERTO PUCCIARELLI , VITO TATOLI
#--------------------------------------------------
# UNIT WIDTH IN PIXELS: 16
# UNIT HEIGHT IN PIXELS: 16
# DISPLAY WIDTH IN PIXELS: 512
# DISPLAY HEIGHT IN PIXELS: 256
# BASE ADDRESS FOR DISPLAY: STATIC DATA
# FILAS TOTALES: 16
# FILAS DE AGUA: 6
# FILAS DE CARRETERA: 6
	.data
#-------------------- TABLERO --------------------
bitmap: .space 4096
#-------------------- COLORES --------------------
verde: .word 0x0000ff00
rojo: .word 0x00ff0000
azul: .word 0x000000ff
negro: .word 0x0000000
gris: .word 0xAAAAAA
marron: .word 0x8B4513
amarillo: .word 0xFFFF00
verdeOscuro: .word 0x006400
#-------------------- POSICIONES --------------------
posicionInicial: .word 1984
posicionCarro1: .word 1788
posicioncarroprueba1: .word 1784
posicionCarro2: .word 1532
posicioncarroprueba2: .word 1528
posicionCarro3: .word 1276
posicioncarroprueba3: .word 1272
posicionCarro4: .word 1792
posicioncarroprueba4: .word 1796
posicioncarroprueba44: .word 1800
posicionCarro5: .word 1536
posicioncarroprueba5: .word 1540
posicioncarroprueba55: .word 1544
posicionCarro6: .word 1280
posicioncarroprueba6: .word 1284
posicioncarroprueba66: .word 1288
posicionTronco1: .word 256
posicionTronco11: .word 260
posicionTronco111: .word 264
posicionTronco2: .word 252
posicionTronco22: .word 248
posicionTronco222: .word 244
posicionTronco3: .word 512
posicionTronco33: .word 516
posicionTronco333: .word 520
posicionTronco4: .word 508
posicionTronco44: .word 504
posicionTronco444: .word 500
posicionTronco5: .word 768
posicionTronco55: .word 772
posicionTronco555: .word 776
posicionTronco6: .word 764
posicionTronco66: .word 760
posicionTronco666: .word 756
#-------------------- ETIQUETAS --------------------
puntos: .asciiz "Has sumado 100 puntos"
score: .asciiz "Tu puntaje final es: "
salto: .asciiz "\n"
again: .asciiz "Desea jugar otra vez Si(1) No(2)"
pierdeVida: .asciiz "Has perdido un vida"

	.text
#-------------------- FONDO --------------------
comienzo:
li $t8, 0 # REGISTRO QUE ALMACENA EL PUNTAJE
li $t9, 3 # REGISTRO QUE ALMACENA LAS VIDAS
inicio: 
linea1:
lw $s0, verde
sw $s0, bitmap($t0)
addi $t0, $t0, 4
blt $t0, 128, linea1

li $t0, 128
linea2:
lw $s0, azul
sw $s0, bitmap($t0)
addi $t0, $t0, 4
blt $t0, 896, linea2

li $t0, 896
linea3:
lw $s0, verde
sw $s0, bitmap($t0)
addi $t0, $t0, 4
blt $t0, 1152, linea3

li $t0, 1152
linea4:
lw $s0, gris
sw $s0, bitmap($t0)
addi $t0, $t0, 4
blt $t0, 2048, linea4

li $t0, 1920
linea:
lw $s0, verde
sw $s0, bitmap($t0)
addi $t0, $t0, 4
blt $t0, 2048, linea

#-------------------- RANA --------------------
lw $s1, verdeOscuro
sw $s1, bitmap+1984
li $t5, 0

#-------------------- MOVIMIENTO DE LA RANA --------------------
espera2:
lw $t1, 0xffff0004
beq $t1, 100, moverDerecha
beq $t1, 97, moverIzquierda
beq $t1, 119, moverArriba
beq $t1, 115, moverAbajo
beq $t5, 1, moverInicio

#-------------------- GENERAR MOVIMIENTO DE LOS CARROS --------------------
espera:
li $t4, 0 # REGISTRO QUE ALMACENA EL NUMERO RANDOM PARA LA GENERACION DE CARROS Y TRONCOS
li $t7, 0 # REGISTRO QUE ALMACENA EL NUMERO RANDOM PARA LA GENERACION DE LA MOSCA
li $v0, 42
li $a1, 14
syscall
move $t4, $a0
li $v0, 42
li $a1, 15
syscall
move $t7, $a0
li $v0, 32
li $a0, 50
syscall
beq $t4, 1, moverCarro1
beq $t4, 2, moverCarro2
beq $t4, 3, moverCarro3
beq $t4, 4, moverCarro4
beq $t4, 5, moverCarro5
beq $t4, 6, moverCarro6
beq $t4, 7, moverTronco1
beq $t4, 8, moverTronco2
beq $t4, 9, moverTronco3
beq $t4, 10, moverTronco4
beq $t4, 11, moverTronco5
beq $t4, 12, moverTronco6
beq $t7, 1, generarMosca
b espera

#-------------------- INSTRUCCIONES PARA MOVERSE --------------------
moverDerecha:
lw $t0, posicionInicial
sw $s0, bitmap($t0)
move $s7, $t0
addi $t0, $t0, 4
sw $s1, bitmap($t0)
sw $t0, posicionInicial
sw $zero,  0xffff0004
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LA MOSCA --------------------
beq $t0, $t6, puntosMosca
#-------------------- VALIDACION DE LA POSICION DE LA RANA --------------------
ble $t0, 896, cambiarColorAzul4
ble $t0, 1152, cambiarColorVerde4
ble $t0, 1920, cambiarColorGris4
bgt $t0, 1920, cambiarColorVerde4
cambiarColorAzul4:
lw $s0, azul
sw $s0, bitmap($s7)
b espera2
cambiarColorVerde4:
lw $s0, verde
sw $s0, bitmap($s7)
b espera2
cambiarColorGris4:
lw $s0, gris
sw $s0, bitmap($s7)
b espera2

moverIzquierda:
lw $t0, posicionInicial
sw $s0, bitmap($t0)
addi $t0, $t0, -4
sw $s1, bitmap($t0)
sw $t0, posicionInicial
sw $zero,  0xffff0004
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LA MOSCA --------------------
beq $t0, $t6, puntosMosca
#-------------------- VALIDACION DE LA POSICION DE LA RANA --------------------
ble $t0, 888, cambiarColorAzul3
ble $t0, 1144, cambiarColorVerde3
ble $t0, 1912, cambiarColorGris3
bgt $t0, 1912 cambiarColorVerde3
cambiarColorAzul3:
lw $s0, azul
sw $s0, bitmap+4($t0)
b espera2
cambiarColorVerde3:
lw $s0, verde
sw $s0, bitmap+4($t0)
b espera2
cambiarColorGris3:
lw $s0, gris
sw $s0, bitmap+4($t0)
b espera2

moverArriba:
lw $t0, posicionInicial
sw $s0, bitmap($t0)
addi $t0, $t0, -128
sw $s1, bitmap($t0)
sw $t0, posicionInicial
sw $zero,  0xffff0004
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LA MOSCA --------------------
beq $t0, $t6, puntosMosca
#-------------------- VALIDACION PARA VER SI EL JUGADOR GANO --------------------
ble $t0, 124, loop
#-------------------- VALIDACION DE LA POSICION DE LA RANA --------------------
ble $t0, 764, cambiarColorAzul
ble $t0, 1020, cambiarColorVerde
ble $t0, 1920, cambiarColorGris
ble $t0, 2048, cambiarColorVerde
cambiarColorAzul:
lw $s0, azul
sw $s0, bitmap+128($t0)
b continuar
cambiarColorVerde:
lw $s0, verde
sw $s0, bitmap+128($t0)
b continuar
cambiarColorGris:
lw $s0, gris
sw $s0, bitmap+128($t0)
b continuar
continuar: 
b espera2
loop:
lw $s0, verde
sw $s0, bitmap+128($t0)
li $t5, 1
b espera2 

moverAbajo:
lw $t0, posicionInicial
sw $s0, bitmap($t0)
move $s7, $t0
addi $t0, $t0, 128
sw $s1, bitmap($t0)
sw $t0, posicionInicial
sw $zero,  0xffff0004
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LA MOSCA --------------------
beq $t0, $t6, puntosMosca
#-------------------- VALIDACION DE LA POSICION DE LA RANA --------------------
ble $t0, 1020, cambiarColorAzul2
ble $t0, 1278, cambiarColorVerde2
ble $t0, 2048, cambiarColorGris2
cambiarColorAzul2:
lw $s0, azul
sw $s0, bitmap($s7)
b espera2
cambiarColorVerde2:
lw $s0, verde
sw $s0, bitmap($s7)
b espera2
cambiarColorGris2:
lw $s0, gris
sw $s0, bitmap($s7)
b espera2

#-------------------- INSTRUCCION PARA REINICAR EL JUEGO --------------------
moverInicio:
lw $t0, posicionInicial
sw $s0, bitmap($t0)
loop1:
addi $t0, $t0, 4
ble $t0, 124, loop1
loop2:
addi $t0, $t0, 128
ble $t0, 2048, loop2
addi $t0, $t0, -64
sw $t0, posicionInicial
ble $t0, 1980, moverInicio
addi $t8, $t8, 100

la $a0, puntos
li $v0, 4
syscall
la $a0, salto
li $v0, 4
syscall
b inicio

#-------------------- GENERAR MOSCA --------------------
generarMosca:
li $v0, 32
li $a0, 400
syscall
li $v0, 42
li $a1, 128
syscall
move $t6, $a0
mul $t6, $t6, 4
addi $t6, $t6, 1152
lw $s4, negro
sw $s4, bitmap($t6)
b espera2

#-------------------- INSTRUCCION QUE SUMA PUNTOS CUANDO SE AGARRA UNA MOSCA --------------------
puntosMosca:
addi $t8, $t8, 100
la $a0, puntos
li $v0, 4
syscall
la $a0, salto
li $v0, 4
syscall
b espera2

#-------------------- MOVIMIENTO DE CARROS --------------------
moverCarro1:
lw $t0, posicionCarro1
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1916, noReinicia1
li $t0, 1788
noReinicia1:
addi $t0, $t0, 4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro1

moverprueba1:
lw $t0, posicioncarroprueba1
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1916, noReiniciaprueba1
li $t0, 1788
noReiniciaprueba1: 
addi $t0, $t0, 4
sw $s3, bitmap($t0)
sw $t0, posicioncarroprueba1
b espera2

moverCarro2:
lw $t0, posicionCarro2
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1660, noReinicia2
li $t0, 1532
noReinicia2: 
addi $t0, $t0, 4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro2

moverprueba2:
lw $t0, posicioncarroprueba2
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1660, noReiniciaprueba2
li $t0, 1532
noReiniciaprueba2: 
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba2
b espera2

moverCarro3:
lw $t0, posicionCarro3
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1404, noReinicia3
li $t0, 1276
noReinicia3: 
addi $t0, $t0, 4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro3

moverprueba3:
lw $t0, posicioncarroprueba3
lw $s3, rojo
lw $s0, gris
sw $s0, bitmap($t0)
blt $t0, 1404, noReiniciaprueba3
li $t0, 1276
noReiniciaprueba3: 
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba3
b espera2

moverCarro4:
lw $t0, posicionCarro4
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1664, noReinicia4
li $t0, 1792
noReinicia4: 
addi $t0, $t0, -4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro4

moverprueba4:
lw $t0, posicioncarroprueba4
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1664, noReiniciaprueba4
li $t0, 1792
noReiniciaprueba4: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba4

moverprueba44:
lw $t0, posicioncarroprueba44
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1664, noReiniciaprueba44
li $t0, 1792
noReiniciaprueba44: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba44
b espera2

moverCarro5:
lw $t0, posicionCarro5
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1408, noReinicia5
li $t0, 1536
noReinicia5: 
addi $t0, $t0, -4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro5

moverprueba5:
lw $t0, posicioncarroprueba5
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1408, noReiniciaprueba5
li $t0, 1536
noReiniciaprueba5: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba5

moverprueba55:
lw $t0, posicioncarroprueba55
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1408, noReiniciaprueba55
li $t0, 1536
noReiniciaprueba55: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba55
b espera2

moverCarro6:
lw $t0, posicionCarro6
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1152, noReinicia6
li $t0, 1280
noReinicia6:
addi $t0, $t0, -4
#-------------------- VALIDACION DE LA POSICION DE LA RANA CON RESPECTO A LOS CARROS --------------------
lw $s5, bitmap($t0)
sw $s3, bitmap($t0)
beq $s1, $s5, restarVidas
sw $t0, posicionCarro6

moverprueba6:
lw $t0, posicioncarroprueba6
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1152, noReiniciaprueba6
li $t0, 1280
noReiniciaprueba6: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba6

moverprueba66:
lw $t0, posicioncarroprueba66
lw $s3, amarillo
lw $s0, gris
sw $s0, bitmap($t0)
bgt $t0, 1152, noReiniciaprueba66
li $t0, 1280
noReiniciaprueba66: 
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicioncarroprueba66
b espera2

#-------------------- MOVIMIENTOS DE LOS TRONCOS --------------------
moverTronco1:
lw $t0, posicionTronco1
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 128, noReinicia7
li $t0, 256
noReinicia7:
addi $t0, $t0, -4
lw $s2, bitmap($t0)
sw $s3, bitmap($t0)
move $t2, $s1
ble $t2, 892, comprobar
sw $t0, posicionTronco1

moverTronco11:
lw $t0, posicionTronco11
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 128, noReinicia71
li $t0, 256
noReinicia71:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco11


moverTronco111:
lw $t0, posicionTronco111
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 128, noReinicia711
li $t0, 256
noReinicia711:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco111
b espera2

moverTronco2:
lw $t0, posicionTronco2
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 380, noReinicia8
li $t0, 252
noReinicia8:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco2

moverTronco22:
lw $t0, posicionTronco22
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 380, noReinicia82
li $t0, 252
noReinicia82:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco22

moverTronco222:
lw $t0, posicionTronco222
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 380, noReinicia822
li $t0, 252
noReinicia822:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco222
b espera2

moverTronco3:
lw $t0, posicionTronco3
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 384, noReinicia9
li $t0, 512
noReinicia9:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco3

moverTronco33:
lw $t0, posicionTronco33
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 384, noReinicia93
li $t0, 512
noReinicia93:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco33

moverTronco333:
lw $t0, posicionTronco333
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 384, noReinicia933
li $t0, 512
noReinicia933:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco333
b espera2

moverTronco4:
lw $t0, posicionTronco4
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 636, noReinicia10
li $t0, 508
noReinicia10:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco4

moverTronco44:
lw $t0, posicionTronco44
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 636, noReinicia104
li $t0, 508
noReinicia104:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco44

moverTronco444:
lw $t0, posicionTronco444
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 636, noReinicia1044
li $t0, 508
noReinicia1044:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco444
b espera2

moverTronco5:
lw $t0, posicionTronco5
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 640, noReinicia11
li $t0, 768
noReinicia11:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco5

moverTronco55:
lw $t0, posicionTronco55
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 640, noReinicia115
li $t0, 768
noReinicia115:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco55

moverTronco555:
lw $t0, posicionTronco555
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
bgt $t0, 640, noReinicia1155
li $t0, 768
noReinicia1155:
addi $t0, $t0, -4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco555
b espera2

moverTronco6:
lw $t0, posicionTronco6
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 892, noReinicia12
li $t0, 764
noReinicia12:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco6

moverTronco66:
lw $t0, posicionTronco66
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 892, noReinicia126
li $t0, 764
noReinicia126:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco66

moverTronco666:
lw $t0, posicionTronco666
lw $s3, marron
lw $s0, azul
sw $s0, bitmap($t0)
blt $t0, 892, noReinicia1266
li $t0, 764
noReinicia1266:
addi $t0, $t0, 4
sw $s3, bitmap($t0) 
sw $t0, posicionTronco666
b espera2

comprobar:
bne $s2, $s1, restarVidas
b espera2

#-------------------- INSTRUCCIONES CUANDO UN CARRO/CAMION CHOCA A LA RANA --------------------
restarVidas:
la $a0, pierdeVida
li $v0, 4
syscall

la $a0, salto
li $v0, 4
syscall

addi $t9, $t9, -1
beq $t9, 0, fin
lw $t0, posicionInicial
sw $s0, bitmap($t0)
loop3:
addi $t0, $t0, 4
ble $t0, 124, loop3
loop4:
addi $t0, $t0, 128
ble $t0, 2048, loop4
addi $t0, $t0, -64
sw $t0, posicionInicial
ble $t0, 1980, moverInicio
b inicio

#-------------------- GAMEOVER --------------------
fin:
la $a0, score
li $v0, 4
syscall
move $a0, $t8
li $v0, 1
syscall

la $a0, salto
li $v0, 4
syscall

la $a0, again
li $v0, 4
syscall
li $v0, 5
syscall
move $t3, $v0
beq $t3, 1, comienzo

li $v0, 10
syscall
