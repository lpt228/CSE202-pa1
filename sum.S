.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    movq $0, %rax               # %rax will store 'total' (and serve as the return value)

    movq %rdi, %rcx             # %rcx will act as 'ptr'

.Lloop_check:
    cmpq $0, %rcx               # check if ptr == NULL (0)
    je .Ldone                   # if ptr is NULL, exit loop

    addq 8(%rcx), %rax          # %rax = %rax + ptr->value

    movq 16(%rcx), %rcx         # %rcx = ptr->next

    jmp .Lloop_check            # repeat loop

.Ldone:
    retq


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
