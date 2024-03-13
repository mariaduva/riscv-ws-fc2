/*---------------------------------------------------------------------
**
**  FICHERO:
**    fun_asm.ams  13/03/2024
**
**-------------------------------------------------------------------*/

.extern _stack
.text

.global eucl_dist
.global guardar
.extern mul
.global i_sqrt

eucl_dist:
	//la sp, _stack		// En este caso no hace falta inicializar la pila
	addi sp, sp, -20 	///
	sw ra, 16(sp) 		//
	sw s0, 12(sp) 		//
	sw s1, 8(sp) 		// PRÓLOGO
	sw s2, 4(sp) 		//
	sw s3, 0(sp) 		///
	mv s0, a0 			// s0 = @baseW
	mv s1, a1 			// s1 = N(size)
	li s2, 0 			// s2 = acc = 0
	li s3, 0 			// s3 = i = 0

eucl_for:
	bge s3, s1, e_eucl_for
	lw a0, 0(s0) 		// a0 = W[i]
	lw a1, 0(s0) 		// a1 = W[i]
	call mul
	add s2, s2, a0 		// acc += mul(W[i], W[i])
	addi s0, s0, 4 		// @baseW + 4
	addi s3, s3, 1 		// i++
	j eucl_for

e_eucl_for:
	mv a0, s2
	call i_sqrt
	lw ra, 16(sp) 		///
	lw s0, 12(sp) 		//
	lw s1, 8(sp) 		//
	lw s2, 4(sp) 		// EPÍLOGO
	lw s3, 0(sp) 		//
	addi sp, sp, 20 	///

	ret

guardar:
	sb a0, 0(a1) 		// Gruardamos un byte

	ret

i_sqrt:
	addi sp, sp, -12 	///
	sw s0, 8(sp) 		//
	sw s1, 4(sp) 		//PRÓLOGO
	sw ra, 0(sp) 		///

	mv s0, zero
	mv s1, a0

while_sqrt:
	mv a0, s0
	mv a1, s0

	call mul
	bge a0, s1, e_i_sqrt
	addi s0, s0, 1

	j while_sqrt

e_i_sqrt:
	mv a0, s0
	lw s0, 8(sp) 		///
	lw s1, 4(sp) 		//EPÍLOGO
	lw ra, 0(sp) 		//
	addi sp, sp, 12 	///

	ret


idiv:

	addi sp, sp, -20 	///
	sw ra, 16(sp)		//
	sw s0, 12(sp) 		//
	sw s0, 8(sp) 		// PRÓLOGO
	sw s1, 4(sp) 		//
	sw s3, 0(sp) 		///

	mv s0, a0			// s0 = a
	mv s1, a1			// s1 = b
	mv s2, zero			// s2 = c
	li s3, 1			// s3 = sign = 1

if_a:
	bge s0, zero, if_b			// if a < 0

	mv a0, s3					// sign = -sign
	li a1, -1
	call mul
	mv s3, a0

	mv a0, s0					// a = -a
	li a1, -1
	call mul
	mv s0, a0

if_b:
	bge s1, zero, while_idiv 	// if b < 0

	mv a0, s3					// sign = -sign
	li a1, -1
	call mul
	mv s3, a0

	mv a0, s1					// b = -b
	li a1, -1
	call mul
	mv s1, a0

while_idiv:
	blt s1, s0, if_sign			// while (b > a)
	sub s0, s0, s1				// a -= b
	addi s2, s2, 1
					// c++
	j while_idiv

if_sign:
	bge s3, zero, e_idiv		// if (sign < 0 )

	mv a0, s2					// c = -c
	li a1, -1
	call mul
	mv s2, a0

e_idiv:
	mv a0, s2

	lw ra, 16(sp)		//
	lw s0, 12(sp) 		//
	lw s0, 8(sp) 		// EPILOGO
	lw s1, 4(sp) 		//
	lw s3, 0(sp) 		///
	addi sp, sp, 20 	///

	ret

.end



