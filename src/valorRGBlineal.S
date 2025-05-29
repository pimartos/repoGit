# Calcula el valor RGB lineal a partir del valor RGB comprimido para un componente
# double valorRGBlineal (double)

	.global	valorRGBlineal

	.data
comparar:	.double		0.04045
divisor:	.double		12.92
constante:	.double		1.055
exponente:	.double		2.4
suma:		.double		0.055
	.text
valorRGBlineal:
	lea	comparar(%rip), %rax	# cargo la constante para comparar, paramentro de entrada en xmm0
	movsd	(%rax), %xmm1
	comisd	%xmm0, %xmm1 		# parametro de entrada < constante?, si es menor CF=0
	jc	mayor
	lea	divisor(%rip), %rax	# es menor, divido
	movsd	(%rax), %xmm2		# cargo el divisor 12.92
	divsd	%xmm2, %xmm0		# divido, resultado en xmm0 y retorno
	ret
mayor:
	lea	suma(%rip), %rax	# cargo la constante a sumar 0.055
	movsd	(%rax), %xmm1
	addsd	%xmm0, %xmm1		# sumo, resultado en xmm1
	lea	constante(%rip), %rax	# cargo la constante 1.055
	movsd	(%rax), %xmm2
	divsd	%xmm2, %xmm1		# divido, resultado en xmm1
	movsd	%xmm1, %xmm0		# muevo el resultado a xmm0 para invocar pow()
	lea	exponente(%rip), %rax	# cargo el exponente
	movsd	(%rax), %xmm1
	movq	$2, %rax		# aviso que son 2 parametros xmm
	subq	$8, %rsp		# invoco a pow(), resultado en xmm0
	call	pow
	addq	$8, %rsp
	ret
