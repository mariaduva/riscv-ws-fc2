/*---------------------------------------------------------------------
**
**  FICHERO:
**    pr3_lab.asm  29/02/2024
**
**
**	DATOS DE PRUEBA:
**	2,4,6,7 <105>
**	9,1,3,3 <95>
**	3,5,1,9	<116>
**	1,6,2,3 <50>
**	1,1,1,2 <7>
**-------------------------------------------------------------------*/

.extern _stack
.global main
.equ N, 4
.equ const_a, 10
.equ const_b, 11

.data
A:      	.word 1,6,2,3
B:      	.word 1,1,1,1


.bss
	res:  .space 4

.text
main:
	la sp, _stack	//Inicialización de la pila
	la a0, A		//a0 = @base A
	la a1, B		//a1 = @base B
	li a2, N		//a2 = N
	call dotprod
	mv t2,a0		//t2 = normA

	la a0, B		//a0 = @base B1
	la a1, B		//a1 = @base B2
	call dotprod
	mv t1,a0		//t1 = normB
	la t0, res 		//t0 = @base Res


if:
	bge t1, t2, eif
	li t3, const_a
	sw t3, 0(t0)	//res = 0xa
	j fin
eif:
	li t3, const_b
	sw t3, 0(t0)	//res = 0xb
fin:
	j fin

/**
 * DOTPROD
 * Función que realiza el producto escalar de dos vectores de n dimensión
 *
 * @arg a0 Primer vector (A)
 * @arg a1 Segundo vector (B)
 * @arg a2 Longuitud del vector (N)
 * @return Producto escalar AxB
 */

dotprod:
	addi sp, sp, -24 	/////
	sw ra, 20(sp) 		//
	sw s10, 16(sp) 		//
	sw s1, 12(sp) 		// PRÓLOGO
	sw s2, 8(sp) 		//
	sw s3, 4(sp) 		//
	sw s4, 0(sp) 		/////
	li s10, 0 			// s0 = acc = 0
	li s1, 0 			// s1 = i
	mv s2, a0 			// s2 = @A1
	mv s3, a1 			// s3 = @A2
	mv s4, a2 			// s4 = N

while:
	bge s1, s4, ewhile
	lw a0, 0(s2)		//a0 = A[i]
	lw a1, 0(s3)		//a1 = A[i]
	call mul
	add s10, s10, a0	//acc += mul
	addi s1, s1, 1		//i++
	addi s2, s2, 4 		//@A1++
	addi s3, s3, 4 		//@A2++
	j while

ewhile:
	mv a0, s10
	lw ra, 20(sp) 		// ///
	lw s10, 16(sp) 		//
	lw s1, 12(sp)		//
	lw s2, 8(sp) 		// EPÍLOGO
	lw s3, 4(sp) 		//
	lw s4, 0(sp) 		//
	addi sp, sp, 24 	// ///
	ret

/**
 * MUL
 * Función que realiza la multiplicación de dos números enteros
 *
 * @arg a0 Primer número entero a multiplicar
 * @arg a1 Segundo número entero a multiplicar
 * @return El resultado de la multiplicación
 * NOTA: a1 siempre pasa a ser 0
 */

mul:
	bge zero, a1, emul
	add t1,t1,a0
	addi a1,a1,-1
	j mul

emul:
	mv a0,t1		//a0 = res
	li t1, 0		//t1 = res = 0
	ret

div:
	li t4, 0
while:
	blt a0, a1, ediv
	sub a0, a0, a1
	addi t4, t4, 1
	j while
ediv:
	mv a0, t4
	ret


vsum: // a0 = @baseV --- a1 = N
	li t5, 0 // t5 = i = 0
	li t6, 0 // t6 = s = 0
for:
	bge t5, a1, efor
	mv s4, zero 	// s4 = efectiva V = 0
	slli s4, t5, 2	// desplazamineto V
	add s4, s4, a0	// s4 = dir V[i]
	lw s5, 0(s4)	// s5 = V[i]
	add t6, t6, s5
	addi t5, t5, 1	//
efor:
	mv a0, s4
	ret


