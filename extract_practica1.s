.data
	.align 2
matriz: .word 1,2,3,4
		.word 5,6,7,8
        .word 9,5,7,4
        
vector: .space 48

.text
main:
	la $a0 matriz #Dirección de la matriz
    li $a1 3 #Número de filas M
    li $a2 4 #Número de columnas N
    la $a3 vector #Dirección del vector
    li $t0 10 #Tamaño del vector
    li $t1 0 #Coordenada i
    li $t2 0 #Coordenada j
    li $t3 2 #Coordenada k
    li $t4 1 #Coordenada l
    addu $sp $sp -20 #Metemos los valores de los t en pila
    sw $t0 16($sp)
    sw $t1 12($sp)
    sw $t2 8($sp)
    sw $t3 4($sp)
    sw $t4 ($sp)
    jal extract
    li $ra -1
    jr $ra



extract: #Sacamos los valores de la pila
	lw $s0 16($sp) #Tamaño del vector
    lw $s1 12($sp) #Coordenada i
    lw $s2 8($sp)  #Coordenada j
    lw $s3 4($sp)  #Coordenada k
    lw $s4 ($sp)   #Coordenada l
    addu $sp $sp 16
    sw $ra ($sp)
    comprobaciones:
		ble $a1 $zero final_mal #Filas <= 0
    	ble $a2 $zero final_mal #Columnas <= 0
        ble $a3 $zero final_mal #P <=0
    	blt $s1 $zero final_mal #i < 0
        blt $s2 $zero final_mal #j < 0
        blt $s3 $zero final_mal #k < 0
        blt $s4 $zero final_mal #l < 0
        ble $a2 $s1 final_mal #i fuera de rango [0,M-1]
        ble $a3 $s2 final_mal #j fuera de rango [0,N-1]
        ble $a2 $s3 final_mal #k fuera de rango [0,M-1]
        ble $a3 $s4 final_mal #l fuera de rango [0,N-1]
        blt $s3 $s1 final_mal #k<i
        ble $s3 $s1 columnas
        columnas:
            blt $s4 $s2 final_mal #j<l
        #Para calcular si P es diferente al número de elementos entre (i,j),(k,l)
        mul $t0 $s1 $a2 #i*N
        add $t0 $t0 $s2 #(i*N)+j
        mul $t1 $s3 $a2 #k*N
        add $t1 $t1 $s4 #(k*N)+l
        sub $t0 $t1 $t0 #Con la resta sacamos el número de elementos desde (i,j) hasta (k,l)
        addi $t0 $t0 1  #Pero como el (k,l) no está contado, le sumamos 1
        bne $t0 $s0 final_mal #P diferente al número
    jal calculainator
    move $t0 $v0 #En t0 la posición del elemento (i,j)
    li $t1 0 #Usaremos t1 como contador
    move $t2 $a3
    while: #Recorremos las posiciones de memoria de los elementos
		bge $t1 $s0 final_ok #Usamos el tamaño del vector como stop
        lw $t3 ($t0) #Cargamos en t3 la dirección del elemento en la matriz
        sw $t3 ($t2) #Y t3 lo pasamos al vector
        addu $t2 $t2 4	#Aumentamos contadores y pa'lante
        addu $t0 $t0 4
        addi $t1 $t1 1
        b while
    
    
    calculainator: #Calculamos la posición de memoria (i,j) con i*N+j
    	
    	mul $t0 $s1 $a2 #i*N
        add $t0 $t0 $s2 #(i*N)+j
        mul $t0 $t0 4
        add $t0 $t0 $a0
        move $v0 $t0 
        jr $ra
    
    final_ok:
    	li $v0 0
    	lw $ra ($sp)
        addu $sp $sp 4
    	jr $ra
    final_mal:
    	li $v0 -1
    	lw $ra ($sp)
        addu $sp $sp 4
    	jr $ra