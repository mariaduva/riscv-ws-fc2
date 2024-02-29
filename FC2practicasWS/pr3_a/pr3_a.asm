/*---------------------------------------------------------------------
**
**  FICHERO:

**    pr3_a.asm  29/02/2024
**
**  C++:
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
**	DATOS DE PRUEBA:
**
**	2,4,6,7 <105>
**	9,1,3,3 <95>
**	3,5,1,9	<116>
**	1,6,2,3 <50>
**	1,1,1,2 <7>
**
**-------------------------------------------------------------------*/
.extern _stack
.global main
.equ N, 4

.data
    A:      .word 3,5,1,9
    B:      .word 1,6,2,3

.bss
	res:  .space 4

.text
main:

	la s1,A 		//s1 = @base A
	la s2,B		//s2 = @base B
	la t0,res		//t0 = @base res

	mv t1,zero		//t1 = res = 0
	mv t5,zero		//t5 = normA = 0
	mv t6,zero		//t6 = normB =0
	mv t2,zero		//t2 = i = 0
	li s3,N			//s3 = N

	mv t3,zero		//t3 = efectivaA = 0
	mv t4,zero		//t4 = efectivaB = 0

/**
 * Recorremos ambos vectores utilizando la misma i y almacenamos el resultado
 * de sus productos escalares en t5 (NormA) y t6 (NormB)
 */
while:


	bge t2,s3,ewhile	//Salimos del while si i>=N
	slli t3,t2,2		//Despl A
	add t3,t3,s1		//Actualizamos efectiva A
	slli t4,t2,2		//Despl B
	add t4,t4,s2		//Actualizamos efectiva B

	lw a1,0(t3)			//a1 = A[i]
	mv a2, a1			//a2 = A[i]

	call mul
	add t5,t5,a0		//NormaA += res

	lw a2,0(t4)			//a2 = B[i]
	mv a1, a2			//a1 = B[i]

	call mul
	add t6,t6,a0		//NormaB += res

	addi t2,t2,1		//i++
	j while

ewhile:

/**
 * Comparamos ambos productos ecalares y almacenanos el mayor
 */
if:
	bge t5,t6,eif
	mv t5,t6

eif:
	sw t5, 0(t0)

fin:
	j .

/**
 * MUL
 * Función que realiza la multiplicación de dos números enteros
 *
 * @arg a1 Primer número entero a multiplicar
 * @arg a2 Segundo número entero a multiplicar
 * @return El resultado de la multiplicación
 * NOTA: a2 siempre pasará a ser 0
 */

mul:
	bge zero,a2,emul
	add t1,t1,a1
	addi a2,a2,-1
	j mul

emul:
	mv a0,t1		//a0 = res
	mv t1,zero		//Reseteamos t1 por si se vuelve a invocar a la función
	ret
