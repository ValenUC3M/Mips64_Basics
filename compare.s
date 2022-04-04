.data
	.align 2
matrizA: .word 2,4,5,7
		 .word 1,5,8,3
         .word 3,6,1,2
    
matrizB: .word 2,3,4,5
		 .word 1,5,7,3
         .word 2,3,1,2
         
.text
main: 
	la $a0 matrizA #Guardamos la dirección de la primera matriz
    la $a1 matrizB #Guardamos la dirección de la segunda matriz
    li $a2 3 #Número de filas M
    li $a3 4 #Número de columnas N
    li $t0 0 #Posición i
    li $t1 3 #Posición j
    li $t2 2 #Posición k
    li $t3 3 #Posición l
    addu $sp $sp -16 #Metemos i,j,k,l a pila
    sw $t0 12($sp) #Metemos i
    sw $t1 8($sp) #Metemos j
    sw $t2 4($sp) #Metemos k
    sw $t3 ($sp) #Metemos l
    jal compare
    li $ra -1 #Cuando todo termina ponemos -1 para que pare
	jr $ra
compare: #Sacamos l,k,j,i de la pila
	lw $s3 ($sp) #Sacamos l
    lw $s2 4($sp) #Sacamos k
    lw $s1 8($sp) #Sacamos j
    lw $s0 12($sp) #Sacamos i
    addu $sp $sp 16
    addu $sp $sp -4
    sw $ra ($sp)

	comprobaciones:
		ble $a2 $zero final_mal #Filas <= 0
        ble $a3 $zero final_mal #Columnas <= 0
        blt $s0 $zero final_mal #i < 0
        blt $s1 $zero final_mal #j < 0
        blt $s2 $zero final_mal #k < 0
        blt $s3 $zero final_mal #l < 0
        ble $a2 $s0 final_mal #i fuera de rango [0,M-1]
        ble $a3 $s1 final_mal #j fuera de rango [0,N-1]
        ble $a2 $s2 final_mal #k fuera de rango [0,M-1]
        ble $a3 $s3 final_mal #l fuera de rango [0,N-1]
        blt $s2 $s0 final_mal #k<i
        ble $s2 $s0 columnas
        columnas:
        	blt $s3 $s1 final_mal #j<l
        

    calculainator:
        #Empezamos en el (0,0)
        #Usamos la formula de i*N+j
        mul $t0 $s0 $a3 #i*N
        addu $t0 $t0 $s1 #(i*N)+j
        mul $t0 $t0 4 #Multiplicamos las posiciones que nos movemos por los 4 bytes de cada posición
        add $s4 $t0 $a0 #Sacamos la dirección de la posición (i,j) de la primera matriz
        add $s6 $t0 $a1 #Sacamos la dirección de la posición (i,j) de la segunda matriz
        #Ahora igual pero k*N+l
        mul $t0 $s2 $a3 #k*N
        addu $t0 $t0 $s3 #(k*N)+l
        mul $t0 $t0 4 #Multiplicamos las posiciones que nos movemos por los 4 bytes de cada posición
        add $s5 $t0 $a0 #Sacamos la dirección de la posición (k,l) de la primera matriz
        add $s7 $t0 $a1 #Sacamos la dirección de la posición (k,l) de la segunda matriz
        
    addu $sp $sp -8
	sw $a0 4($sp) #Guardamos las posiciones de las matrices en la pila
    sw $a1 ($sp)
    li $t0 0
    
    bucle_cmp:
      bgt $s4 $s5 final_ok
      lw $a0 ($s4)
      lw $a1 ($s6)
      jal cmp
      add $t0 $t0 $v0
      addu $s4 $s4 4
      addu $s6 $s6 4
      b bucle_cmp
      
	final_ok: #Terminan las comparaciones
            move $v1 $t0
            lw $a1 ($sp)
            lw $a0 4($sp)
            addu $sp $sp 8
            li $v0 0 #Todos los parámetros estaban guay
            b final
	final_mal:
			  li $v0 -1
    final:
    	lw $ra ($sp)
        addu $sp $sp 4
        jr $ra

