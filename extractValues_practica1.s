.data

matrizA: .float -5.43, 2.34, -4.577, 6.32
		 .float 1.23, -4.32, 2.12, -4.97
         .float -0.14, 0, 4.23, -7.345

matrizS: .word 0, 0, 0, 0
		 .word 0, 0, 0, 0
         .word 0, 0, 0, 0
         
matrizE: .word 0, 0, 0, 0
		 .word 0, 0, 0, 0
         .word 0, 0, 0, 0
         
matrizMa: .word 0, 0, 0, 0
		  .word 0, 0, 0, 0
          .word 0, 0, 0, 0

.text
main:
	la $a0 matrizA #DirecciÃ³n de la matriz A
    la $a1 matrizS #DirecciÃ³n de la matriz S
    la $a2 matrizE #DirecciÃ³n de la matriz E
    la $a3 matrizMa #DirecciÃ³n de la matriz Ma
    li $t0 3 #NÃºmero de filas M
    li $t1 4 #NÃºmero de columnas N
    addu $sp $sp -8  #Metemos los M,N en pila
    sw $t0 4($sp)
    sw $t1 ($sp)
    jal extractValues #Llamamos a la funcion
    li $ra -1
    jr $ra
extractValues: #Sacamos los valores a pila
	lw $s0 4($sp) #M
    lw $s1 ($sp) #N
    addu $sp $sp 8
    
    comprobaciones:
    	ble $s0 $zero final_mal #Filas <= 0
        ble $s1 $zero final_mal #Columnas <= 0
    
    
    signo:
    	mul $t0 $s0 $s1 #Sacamos el nÃºmero de iteraciones
        li $t1 1 #Usamos t1 como contador
        move $t2 $a0 #Pasamos a t2 la direcciÃ³n de la matriz A
        move $t4 $a1 #Pasamos a t2 la direcciÃ³n de la matriz E
    	whileS: blt $t0 $t1 exponente #Mientras el contador sea menor que el tamaÃ±o de la matriz
    	lw $t3 ($t2) #Guardamos el primer nÃºmero
        srl $t3 $t3 31 #Movemos 31 bits a la derecha para dejar solo el del signo
        sw $t3 ($t4) #Guardamos el bit en la matriz E
        addu $t4 $t4 4 #Aumentamos contadores
        addu $t2 $t2 4
        addi $t1 $t1 1
        b whileS
		
    exponente:
    	mul $t0 $s0 $s1 #Sacamos el nÃºmero de iteraciones
        li $t1 1 #Usamos t1 como contador
        move $t2 $a0 #Pasamos a t2 la direcciÃ³n de la matriz A
        move $t4 $a2 #Pasamos a t4 la direcciÃ³n de la matriz E
    	whileE: blt $t0 $t1 mantisa #Mientras el contador sea menor que el tamaÃ±o de la matriz
    	lw $t3 ($t2) #Guardamos el primer nÃºmero
        sll $t3 $t3 1 #Movemos 1 bit a la izquierda para quitar el de signo
        srl $t3 $t3 24 #Movemos 24 a la derecha para quitar la mantisa mÃ¡s el bit que hemos aÃ±adido arriba
        sw $t3 ($t4) #Guardamos los 8 bits restantes
        addu $t4 $t4 4 #Movemos contadores
        addu $t2 $t2 4
        addi $t1 $t1 1
        b whileE
    mantisa: 
    	mul $t0 $s0 $s1 #Sacamos el nÃºmero de iteraciones
        li $t1 1 #Usamos t1 como contador
        move $t2 $a0 #Pasamos a t2 la direcciÃ³n de la matriz A
        move $t4 $a3 #Pasamos a t4 la direcciÃ³n de la matriz Ma
        move $t5 $a2 #Pasamos a t5 la dirección de la matriz E para añadir el 1 en números normalizados
    	whileMa: blt $t0 $t1 final_ok #Mientras el contador sea menor que el tamaÃ±o de la matriz
    	lw $t3 ($t2) #Guardamos el primer nÃºmero
        sll $t3 $t3 9 #Movemos 9 bits a la izquierda para quitar el bit de signo y 8 bits de exponente
        srl $t3 $t3 9 #Lo volvemos a poner en su posiciÃ³n
        lw $t6 ($t5) #Guardamos el exponente para ver si es 1>=E<=255
        ble $t6 $zero salto
        li $t7 255
        bge $t6 $t7 salto
        add $t3 $t3 8388608
        salto:sw $t3 ($t4) #Guardamos los 23 bits restantes
        
        
        addu $t4 $t4 4 #Movemos contadores
        addu $t2 $t2 4
        addi $t1 $t1 1
        b whileMa
        
    final_ok:
    	li $v0 0
        jr $ra #Volvemos
    
    final_mal:
    	li $v0 -1
    	jr $ra #Volvemos
    
    
    
    
    
    
    
    