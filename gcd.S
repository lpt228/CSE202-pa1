.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    pushq %rbp
    movq %rsp, %rbp
    cmpl $0, %esi

    jne .Lrecursive_step

    movl %edi, %eax
    jmp .Lgcd_end

.Lrecursive_step:
    movl %edi, %eax         # eax = a
    cltd                    # sign-extended %eax into %edx
    idivl %esi              # divide by b
                            # eax = quotient, %edx = remainder (a % b)

    # set up arguments
    movl %esi, %edi         # 1st argument new a = b
    movl %edx, %esi         # 2nd argument new b = a % b

    call gcd

.Lgcd_end:
    leave
    ret


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
