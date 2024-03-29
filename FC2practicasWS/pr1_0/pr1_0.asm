/*---------------------------------------------------------------------
**
**  FICHERO:
**    pr1_0.asm
**
**  C++:
**	#define N 10
**	int V[N]={12,1,-2,15,-8,4,-31,8,8,25};
**	for (i=0; i<N; i++)
**	V[i] = V[i]+1
**
**-------------------------------------------------------------------*/

.global main
.equ N,10
.data
A: .word 12,1,-2,15,-8,4,-31,8,8,25
B: .word 23,5,-5,-30,1,12,8,11,-17,10
.bss
	mayor: .space N*4
.text
main :
	li s1,N // s1 -> n
	mv s2,zero // s2 -> i
	la s3,mayor // s3-> mayor
	la s4,A // s4-> A
	la s5,B // s5-> B
	li t1,0 // t1-> salto

for:
	beq s2,s1,efor
	slli t1,s2,2 // guarda el salto de cada iteración

	add s7,s4,t1 // dir A[i] -> s7
	sw s7,0(s8) // A[i] -> s8

	add s9,s5,t1 // dir B[i] -> s9
	sw s9,0(s10) // B[i] -> s10

	add s11,s3,t1 // dir mayor[i] -> s11
if:
	bgt s10,s8,eif // B[i] > A[i]
	sw s8,0(s11) // mayor[i] = A[i]
	j 8
eif:
	sw s11,0(s10) // mayor[i] = B[i]
	addi s2,s2,1 // i++
	j for
efor:
	j .
.end
