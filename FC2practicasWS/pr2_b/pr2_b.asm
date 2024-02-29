/*---------------------------------------------------------------------
**
**  FICHERO:
**    pr2_b.asm  19/02/2024
**
**  C++:
**	# define N 8
**	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int W [ N ];
**	int min , index ;
**	for ( j = 0; j < N ; j ++) {
**		min = INT_MAX ;
**		for ( i = 0; i < N ; i ++) {
**			if ( V [ i ] < min ) {
**				min = V [ i ];
**				index = i ;
**			}
**		}
**		W [ j ] = V [ index ];
**		V [ index ] = INT_MAX ;
**	}
**
** VARIABLES:
** 	index		--> a2
** 	min			--> a1
** 	INT_MAX		--> s2
** 	N			--> s1
** 	i 			-->	t4
** 	j			--> t3
**	(base) V	--> s3
**	(base) W	--> s4
**	(base)min 	--> t1
**	(base)index --> t2
**
**-------------------------------------------------------------------*/

.global main
.equ N , 7
.equ INT_MAX , 65536

.data
V: 	 .word 4 ,50 , 2 ,30 ,3 , 1 ,6
.bss
W: 	 .space N *4
min: .space 4
ind: .space 4


.text
main:
	la s3, V 				// s3 = @base V
	la s4, W 				// s4 = @base W
	li t3, 0				// t3 = j = 0
    li s1, N        		// s1 = N = 8
    la t1, min				// t1 = @base min
    la t2, index			// t2 = @base index
    li a3 0					// a3 = NumMay = 0

for_j:
    bge t3, s1, end_for_j	// Salimos del bucle si j >= N
    li a1, INT_MAX			// t4 = INT_MAX
    sw a1, 0(t1)			// Almacenamos en memoria el contenido de a1
    li t4, 0				// t4 = i = 0

for_i:
	bge t4,s1, end_for_i	// Salimos del bucle si i >= N
	li t5, 0				// t5 = 0
	slli t5, t4, 2			// t5 = Desplazamiento de 2 bits (i * 4)
    add t5, t5, s3 			// t5 = @efectiva de V[i]
	lw a0, 0(t5)			// a0 = V[i]


if:
	bge a0, a1, end_if 		// Salta si a0 >= a1
	mv a1, a0  				// min = V[i]
	mv a2, t4 				// index = i

end_if:
	addi t4, t4, 1			// i++
	j for_i

end_for_i:
	li t6, 0				// t6 = 0 desplazamiento de W
	slli t6, t3, 2			// t6 = Desplazamiento de 2 bits (j * 4)
	add t6, t6, s4			// t6 = @base W + salto

	li t5, 0 				// t5 = 0 desplazamiento de V
	slli t5, a2, 2 			// t6 = Desplazamiento de 2 bits (index * 4)
	add t5, t5, s3 			// t5 = @efectiva de V[index]
	lw a0, 0(t5)			// a0 = V[index]

	sw a0, 0(t6)			// W[j] = V[index]
	li a0, INT_MAX			// a0 = INT_MAX
	sw a0, 0(t5)			// V[index] = INT_MAX

	addi t3, t3, 1 			// j++
	j for_j

end_for_j:
	j .
.end


