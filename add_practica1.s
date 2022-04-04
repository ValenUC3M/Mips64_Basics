
.data
.align 2

matriz2: .word 1,3,2,2,4,5
		 .word 2,1,3,2,6,4

.text
main:
	 la $a0 matriz2
     li $a1 2 #parametros de entrada
     li $a2 6
     li $a3 0 #variable i
     li $t0 0 #variable j
     li $t1 1 #variable k
     li $t2 5 #variable l
     addu $sp $sp -12
     sw $t0 8($sp)
     sw $t1 4($sp)
     sw $t2 ($sp) #guardamos en pila para simular luego sacada de pila
     
     add:
       lw $s2 ($sp)#variable l
       lw $s1 4($sp)#variable k
       lw $s0 8($sp)#variable j
       addu $sp $sp 12 #cargamos los parametros necesarios
       #comprobaciones error de codigo            		     	
       checking:
           #check all the posible wrong combos for the inputs
           blez $a1 fail_end
           blez $a2 fail_end
           range:
                #considero la primera posicion la 0,0
                #variable i
                blt $a3 $zero fail_end
                bge $a3 $a1 fail_end
                #variable j
                blt $s0 $zero fail_end
                bge $s0 $a2 fail_end
                #variable k
                blt $s1 $zero fail_end
                bge $s1 $a1 fail_end
                #variable l
                blt $s2 $zero fail_end
                bge $s2 $a2 fail_end
            wrong_parametres:
                #checks if i,j,k,l are not valid
                bgt $a3 $s1 fail_end
                blt $a3 $s1 end_checking
                blt $s2 $s0 fail_end
                b end_checking
            fail_end:
                  li $v0 -1
                  j fin_programa
            end_checking:
                li $v0 0 
		calculainator:
            #calculamos las iteraciones necesarias para hacer la suma y la primera posicion de memoria            
            #reajusto las variables ya que empezaban en 0 y no en 1 y eso rompe el sentido del calculainator
        	move $t0 $a3 #variable i
            addi $t0 $t0 1
            move $t1 $s0 #variable j
            addi $t1 $t1 1
            move $t2 $s1 #variable k
            addi $t2 $t2 1
            move $t3 $s2 #variable l
            addi $t3 $t3 1
            #algoritmo de calculo para posicion de memoria (i*N + (j-N))*4
            li $t4 -1
            mul $t5 $t0 $a2
            mul $t6 $a2 $t4
            add $t6 $t1 $t6
            add $s4 $t6 $t5
            addi $s3 $s4 -1
            li $t4 4
            mul $s3 $s3 $t4
            #hemos calculado de paso una de las variables necesarias para saber el numero de iteraciones (s4)
            li $t4 -1
            mul $t5 $t2 $a2
            mul $t6 $a2 $t4
            add $t6 $t3 $t6
            add $s5 $t6 $t5
            mul $s4 $s4 $t4
            add $s4 $s5 $s4
            #hemos calculado las iteraciones necesarias totales y guardadas en s4
            #asignamos ahora variables de control
            add $t0 $a0 $s3
            li $t1 0
        while_suma:
        		bgt $t1 $s4 fin_programa
                lw $t2 ($t0) #vamos cargando los valores de la matriz en t2
                add $v1 $v1 $t2 #vamos sumandolos en v1
                addi $t0 $t0 4
                addi $t1 $t1 1
                b while_suma
            
      fin_programa: 
          jr $ra #fin de programa

     	
     