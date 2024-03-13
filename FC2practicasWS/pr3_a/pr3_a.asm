/*---------------------------------------------------------------------
**
**  Fichero:
**    pr3_a.asm
**
**  Notas de diseño:
**
**	int mul(int a, int b) {
**	    int res = 0;
**	    while (b > 0) {
**	        res += a;
**	        b--;
**	    }
**	    return res;
**	}
**
**	int dotprod(int V[], int W[], int n) {
**	    int acc = 0;
**	    for (int i = 0; i < n; i++) {
**	        acc += mul(V[i], W[i]);
**	    }
**	    return acc;
**	}
**
**	#define N 4
**	int A[] = {3, 5, 1, 9}
**	int B[] = {1, 6, 2, 3}
**
**	int res;
**
**	void main() {
**	    int normA = dotprod(A, A, N);
**	    int normB = dotprod(B, B, N);
**	    if (normA > normB)
**	        res = 0xa;
**	    else
**	        res = 0xb;
**	}
**
**-------------------------------------------------------------------*/
.extern _stack
.global main
.equ N, 4
.equ CONST_A, 10
.equ CONST_B, 11

.data
    A:      .word 3,5,1,9
    B:      .word 1,6,2,3

.bss
	res:  .space 4

.text
main:
	la sp, _stack
	la s11,A 		//a1 = @base A
	la s10,B		//a2 = @base B
	la t0,res		//t0 = @base res

	mv t1,zero		//t1 = res = 0
	mv t5,zero		//t5 = normA = 0
	mv t6,zero		//t6 = normB =0
	mv t2,zero		//t2 = i = 0
	li s3,N			//s3 = N


	mv a1, s11
	mv a2, s11
	call dotprod

	mv t5, a0

	mv a1, s10
	mv a2, s10
	call dotprod
	mv t6, a0

if:
	bge t5,t6,eif
	li s4, CONST_B
	sw s4, 0(t0)
	j fin
eif:
	li s4, CONST_A
	sw s4, 0(t0)

	j.
.end

/**
 * Recorremos ambos vectores utilizando la misma i y almacenamos el resultado
 * de sus productos escalares en t5 (NormA) y t6 (NormB)
 */
dotprod:
	addi sp,sp,-4
	lw ra,0(sp)
	mv t3,zero		//t3 = efectivaA = 0
	mv t4,zero		//t4 = efectivaB = 0
while:

	bge t2,s3,ewhile	//Salimos del while si i>=N
	slli t3,t2,2		//"Salto" A
	add t3,t3,a1		//Actualizamos efectiva A
	slli t4,t2,2		//"Salto" B
	add t4,t4,a2		//Actualizamos efectiva B
	lw s1,0(t3)			//s1 = A[i]
	lw s2,0(t4)			//s2 = B[i]

	call mul

	addi t2,t2,1		//i++
	j while

ewhile:
	lw ra,0(sp)
	addi sp,sp,4
	ret



/**
 * MUL
 * Función que realiza la multiplicación de dos números enteros
 *
 * @arg a1 Primer número entero a multiplicar
 * @arg a2 Segundo número entero a multiplicar
 * @var t1 Resultado de la multiplicación
 * @return El resultado de la multiplicación
 * NOTA: a2 siempre pasa a ser 0
 */

mul:
	mv t1,zero
whilemul:
	bge zero,s2,ewhilemul
	add t1,t1,s1
	addi s2,s2,-1
	j mul

ewhilemul:
	mv a0,t1		//a0 = res
	ret
