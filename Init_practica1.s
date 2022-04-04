.data
.align 2

matriz2: .word 1,3,2,2,4,5
		 .word 2,1,3,2,6,4
.text
main:
	la $a0 matriz2
    li $a1 2
    li $a2 6
	init:
        #suponemos que entra en a0 el adress, en a1 M y en a2 N
        blez $a1  wrong #si es 0 o menor devuelve -1 y acaba
        blez $a2  wrong
        li $v0 1
        move $t0 $a0
        li $t1 0 #variable de control de aumento de bucle
        mul $t2 $a1 $a2 #cantidad de veces que debe hacer el bucle
        while:
        	bge $t1 $t2 fin #control de bucle a M*N veces
            sw $zero ($t0)
            addi $t0 $t0 4
            addi $t1 $t1 1
            b while
            
      wrong:
      	li $v0 -1
      fin:
      	jr $ra #fin de programa