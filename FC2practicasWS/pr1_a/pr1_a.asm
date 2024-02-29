/*---------------------------------------------------------------------
**
**  FICHERO:
**    pr1_a.asm
**
**  C++:
**	# define N 10
**	int res = 0;
**	for (int i = 0; i < N ; i ++) {
**		res += i ;
**	}
**
**-------------------------------------------------------------------*/
.global main
.equ N, 10

.bss
	res: 	.space 4

.text
main:
	li s1,N // s1 es n
	li t0,0 // t0 es i
	li t1,0 // t1 es res
for:
	bge t0,s1,efor
	add t1,t1,t0 // res += i
	add t0,t0,1 // i++
	j for
efor:
	la t2, res
	sw t1, 0(t2)
	j .
.end


