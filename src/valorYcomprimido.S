# Calcula el valor y comprimido a partir del valor Y lineal
# double valorYcomprimido (double)

	.global	valorYcomprimido

	.data
comparar:	.double		0.0031308
multiplicador:	.double		12.92
constante:	.double		1.055
denominador:	.double		2.4
numerador:	.double		1.0
resta:		.double		0.055

	.text
valorYcomprimido:
	lea	comparar(%rip), %rax	# cargo la constante para comparar, paramentro de entrada en xmm0
	movsd	(%rax), %xmm1
	comisd	%xmm0, %xmm1 		# parametro de entrada < constante?, si es menor CF=0
	jc	mayor
	lea	multiplicador(%rip), %rax	# es menor, multiplico
	movsd	(%rax), %xmm2		# cargo el multiplicador 12.92
	mulsd	%xmm2, %xmm0		# divido, resultado en xmm0 y retorno
	ret
mayor:
	lea	denominador(%rip), %rax	# cargo el denominador
	movsd	(%rax), %xmm1
	lea	numerador(%rip), %rax	# cargo el numerador
	movsd	(%rax), %xmm2
	divsd	%xmm1, %xmm2		# calculo el exponente fraccionario, resultado en xmm2
	movsd	%xmm2, %xmm1		# muevo el exponente fraccionario a xmm1, tengo valorYlineal en xmm0

	movq	$2, %rax		# aviso que son 2 parametros xmm
	subq	$8, %rsp		# invoco a pow(), resultado en xmm0
	call	pow
	addq	$8, %rsp

	lea	constante(%rip), %rax	# cargo la constante a multiplicar 1.055
	movsd	(%rax), %xmm1
	mulsd	%xmm0, %xmm1		# multiplico, resultado en xmm1

	lea	resta(%rip), %rax	# cargo el sustraendo
	movsd	(%rax), %xmm2
	subsd	%xmm2, %xmm1		# resto xmm1 - xmm2, resultado en xmm1

	movsd	%xmm1, %xmm0		# muevo a xmm0 para retornar el resultado de la funcion

	ret
