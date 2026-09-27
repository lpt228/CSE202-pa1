.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    pushq %rbp                       
    movq %rsp, %rbp

    movl %edi, %eax             # eax = a
    addl %esi, %eax             # eax = a + b
    addl %edx, %eax             # eax = a + b + c
    sarl $1, %eax               # eax = p

    movl %eax, %ecx             # ecx = p (save original p for next step)

    movl %ecx, %r8d             # r8d = p 
    subl %edi, %r8d             # ecx = p - a
    imull %r8d, %eax            # eax = p * (p - a)

    movl %ecx, %r8d             # r8d = p
    subl %esi, %r8d             # r8d = p - b
    imull %r8d, %eax            # eax = p * (p - a) * (p - b)

    movl %ecx, %r8d             # r8d = p
    subl %edx, %r8d             # r8d = p - c
    imull %r8d, %eax            # r8d = p * (p - a) * (p - b) * (p - c)

    movl %eax, %edi             # set up x = p
    call .Lr_sqrt                 # call recursive sqrt; result will be in %eax

    leave
    ret

# x in %edi; result in %eax
.Lr_sqrt:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp              # keep stack 16-byte, save space for local vars

    movl %edi, -4(%rbp)         # save x to the stack

    cmpl $0, %edi               
    jge .Lcheck_base              # if x >= 0, check the next condition
    movl $-1, %eax              # return -1
    jmp .Lrsqrt_end

.Lcheck_base:
    cmpl $2, %edi
    jge .Lrecursive_step          # if x >= 2, perform recursive call
    movl %edi, %eax             # return x
    jmp .Lrsqrt_end

.Lrecursive_step:
    sarl $2, %edi               # pass x >> 2 as argument
    call .Lr_sqrt

    sall $1, %eax               # small_cand = result << 1
    movl %eax, -8(%rbp)         # save small_cand to the stack

    movl %eax, %ecx             # ecx = small_cand
    addl $1, %ecx               # ecx = large_cand

    movl %ecx, %edx             # edx = large_cand
    imull %ecx, %edx            # edx = large_cand * large_cand

    cmpl -4(%rbp), %edx         # compare large_cand * large_cand with x
    jle .Lreturn_large            # if large_cand * large_cand <= x, go to else branch

    movl -8(%rbp), %eax         # grab small_cand from stack to return in
    jmp .Lrsqrt_end

.Lreturn_large:
    movl %ecx, %eax             # eax = small_cand

.Lrsqrt_end:
    leave
    ret




# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
