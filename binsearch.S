.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  xorl %ecx, %ecx                 # lo = 0
  movl %esi, %r8d                 # hi = n
  decl %r8d                       # hi = n - 1

  .L_loop:
    cmpl %r8d, %ecx               # compare hi and lo
    jg .L_not_found               # if lo > high, exit loop and return -1

    movl %r8d, %eax               # eax = hi
    subl %ecx, %eax               # eax = hi - lo
    shrl $1, %eax                 # eax = (hi - lo) / 2
    addl %ecx, %eax               # eax = lo + (hi - lo) / 2

    movl %eax, %r9d               # r9d = mid
    movslq %r9d, %r9              # sign-extended mid to 64-bit for memory addressing

    movl (%rdi, %r9, 4), %r10d   # %r10d = arr[mid]
    
    cmpl %edx, %r10d              # compare mid and target (base address + mid * 4 bytes)
    je .L_found                   # if equal, found target

    jl .L_less                    # if less, target is upper half

    leal -1(%r9d), %r8d           # hi = mid - 1
    jmp .L_loop                   # repeat loop

  .L_less:
    leal 1(%r9d), %ecx            # lo = mid + 1
    jmp .L_loop                   # repeat loop

  .L_found:
    movl %r9d, %eax               # set return value to mid
    ret
  
  .L_not_found:
    movl $-1, %eax                 # set return value to -1
    ret
  


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
