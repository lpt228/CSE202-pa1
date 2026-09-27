.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movl $0, %eax               # %eax = i

.Lloop_check:
  movl %esi, %ecx             # copy n into %ecx
  shrl $1, %ecx               # %ecx = n / 2 

  cmpl %ecx, %eax       
  jae .Ldone                  # if i >= n/2, exit loop

  movq (%rdi, %rax, 8), %r8   # temp = list[i]

  movl %esi, %r9d             # %r9d = n
  subl %eax, %r9d             # %r9d = n - i
  subl $1, %r9d               # %r9d = n - i - 1
  movl %r9d, %r9d             # Zero-extend 32-bit index into %r9 (64-bit)

  movq (%rdi, %r9, 8), %r10   # %r10 = list[n - i - 1]
  movq %r10, (%rdi, %rax, 8)  # list[i] = list[n - i - 1]

  movq %r8, (%rdi, %r9, 8)    # list[n - i - 1] = temp

  addl $1, %eax               # i++
  jmp .Lloop_check            # Jump back to loop condition
  
.Ldone:
    retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
