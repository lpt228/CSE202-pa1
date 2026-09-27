.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  movl $0, %eax               # n = 0

.Lprefix_loop:
  # 1. read a[n]
  movb (%rdi, %rax), %cl      # load 1 byte from address (a + n) into %cl

  # 2. check if a[n] == '\0'
  cmpb $0, %cl
  je .Lloop_done                # if = 0, reach the end of string a => break the loop

  # 3. read b[n]
  movb (%rsi, %rax), %dl      # load 1 byte from address (b + n) into %dl
  
  # 4. check if a[n] == b[n]
  cmpb %cl, %dl
  jne .Lloop_done               # if they do not match, break the loop

  # 5. n++
  addl $1, %eax               # n = n + 1
  jmp .Lprefix_loop             # jump back to the top of the loop

.Lloop_done:
  ret




# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
