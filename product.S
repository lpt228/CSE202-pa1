.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    # loop iteration
    movl $0, %eax                   # %eax = i 

.Lloop_check:
    # check condition: i < size
    cmpl %ecx, %eax                 # compare i with size
    jae .Ldone                      # if i >= size, exit loop

    # loop body
    movss (%rdi, %rax, 4), %xmm0    # %xmm0 = a[i] 
    movss (%rsi, %rax, 4), %xmm1    # %xmm1 = b[i] 
    mulss %xmm1, %xmm0              # %xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx, %rax, 4)    # c[i] = %xmm0

    # increment
    addl $1, %eax                   # i++
    jmp .Lloop_check                # jump back to check condition

.Ldone:
    ret


# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
