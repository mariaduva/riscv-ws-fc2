/*---------------------------------------------------------------------
**
**  FICHERO:
**    pr2_a.asm  19/02/2024
**
**  C++:
**
** 	# define N 8
** 	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int min = INT_MAX ;
**	for ( i = 0; i < N ; i ++) {
**		if ( V [ i ] < min )
**			min = V [ i ];
**	}
**
** VARIABLES:
**
** 	INT_MAX		--> t0
** 	N			--> s2
** 	i 			-->	t1
**	(base) V	--> t2
**	(base)min 	--> s1
** 	V[i]		--> s3
**
**-------------------------------------------------------------------*/

.global main
.equ N, 8
.equ INT_MAX, 65536

.data
V:   .word -7, 3, -9, 8, 15, -16, 0, 3

.bss
min: .space 4

.text
main:
	la s1, min 			// s1 = @base min
	li t0, INT_MAX 		// t0 = INT_MAX
	sw t0, 0(s1)		// Almacenamos en memoría el contenido de t0 (INT_MAX)

	li t1, 0 			// t1 = i = 0
    li s2, N        	// s2 = N = 8
    la t2, V			// t2 = @base de V
for:
    bge t1, s2, end_for	// Salimos del bucle si i >= N
	slli t3, t1, 2		// t3 = Desplazamiento de 4 bytes (i * 4)
    add t3,t3,t2 		// t3 = @efectiva de V[i]
	lw s3,0(t3)			// s3 = V[i]

if:
	bgt s3, t0, end_if 	// Salta si s3 > t0
	mv t0, s3 			// min = V[i]

end_if:
	addi t1, t1, 1		// i++
	j for

end_for:
	sw t0, 0(s1) 		// Almacenamos en memoría el min de V
	j .
.end


