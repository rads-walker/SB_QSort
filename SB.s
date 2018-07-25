.section .data
str: .string "Hola Mundo:\n"
str2: .string "%d"
str3: .string "O seu numero e %d\n"
vetor: .quad 10,2,3,4,5,6,7,8,9,1
tam: .quad 10
p: .quad 9 #variavel para seleção da posicao no final
.section .text
.globl main

qsort:
	pushq %rbp
    movq %rsp, %rbp
	subq $40, %rsp #alocando espaco
	#copiando i e j
	movq 16(%rbp), %rax #i = inicio
	movq %rax, -8(%rbp)
	movq 24(%rbp), %rax #j = fim
	movq %rax, -16(%rbp)

	#pegando a meio
	#meio = (int) ((i + j) / 2);
	addq -8(%rbp), %rax 	#rax = (i + j)
	movq $2, %rbx
	movq $0, %rdx  #para assegurar a divisão não seja por 0
	divq %rbx
	movq %rax, -24(%rbp)

	#pegando o elemento do pivo
	movq vetor(,%rax,8),%rbx
	movq %rbx, -32(%rbp)

	_do:

		_while1:
		#while (vetor[i] < pivo) i = i + 1;
		movq -8(%rbp), %rbx			# i pra registrador = 9
		movq vetor(,%rbx,8), %rax	# vetor[i] -> %rax
		movq -32(%rbp), %rbx 		# pivo pra registrador = 5
			#(vetor[i] < pivo)
			cmpq %rbx,  %rax
			jge _while2
			incq -8(%rbp)	#i = i + 1;
			jmp _while1

		#while (vetor[j] > pivo) j = j - 1;
		_while2:
			movq -16(%rbp), %rbx		# j pra registrador
			movq vetor(,%rbx,8), %rax	# vetor[j] -> %rax
			movq -32(%rbp), %rbx 		# pivo pra registrador
			cmpq %rbx,  %rax	#(vetor[i] < pivo)
			jle _endwhiles
			decq -16(%rbp)		#j = j - 1;
			jmp _while2
		_endwhiles:

		#if(i <= j)
        movq -8(%rbp), %rax		# i pra registrador
        movq -16(%rbp), %rbx 	# j pra registrador
        cmpq %rbx, %rax
      	jg _endif

        #vetor[i] = vetor[j];
		movq  vetor(,%rax,8), %rdx	#rdx = vetor[i]
		movq  %rdx, -40(%rbp)		#aux = vetor[i]
        movq  -16(%rbp), %rcx
        movq vetor(, %rcx, 8), %rdx
        movq  %rdx, vetor(,%rax,8)		#aux -> rcx
		movq -40(%rbp),%rdx				#vetor[j] = aux
		movq %rdx, vetor(, %rcx, 8)		#vetor[j] = aux
		#i = i + 1; j = j - 1;
		incq -8(%rbp)
		decq -16(%rbp)

		#do{}while(j > i);
		_endif:
        movq -8(%rbp), %rax	 # i pra registrador
        movq -16(%rbp), %rbx # j pra registrador
		cmpq %rax, %rbx
		jg _do

	movq -16(%rbp), %rax #%rax = j
	movq 24(%rbp), %rbx	#%rbx = fim
	cmpq %rax, 16(%rbp)#if(inicio < j)
	jge _if2

	#Quick(vetor, inicio, j);
	pushq vetor
	pushq -16(%rbp)	#%rax = j  	3
    pushq 16(%rbp)	#%rbx = inicio 0
	call qsort
	addq $24, %rsp

	_if2:

	#f(i < fim) Quick(vetor, i, fim);
	cmpq %rbx, -8(%rbp) #if(i < fim)
	jge _endfuncao

	#Quick(vetor, i, fim);
	pushq vetor
	pushq 24(%rbp)	#fim
	pushq -8(%rbp)	#i
	call qsort
	addq $24, %rsp

	_endfuncao:

	#desalocando
	addq $40, %rsp
	popq %rbp
	ret

	main:
	pushq %rbp
	movq %rsp, %rbp

	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	mov $str, %rdi
	call printf


	movq %rsp, %rsi

	mov $str2, %rdi
	call scanf
	movq -8(%rbp), %rsi
	mov $str3, %rdi
	call printf

	



	movq $60, %rax
    popq %rbp
	syscall
