.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi
  jl .Lnot_prime        # return 0 if not prime

  je .Lis_prime         # if n == 2, can just return true

  movl %edi, %eax       # copy n to scratchpad
  andl $1, %eax         # isolate the lowest bit (1 if odd, 0 if even)
  cmpl $0, %eax         # check if its even
  je .Lnot_prime        # if even, return 0

  movl $3, %ecx         # i = 3, loop counter

.Lloop_start:
  # check condition: i * i <= n
  movl %ecx, %r8d       # r8d = i
  imull %ecx, %r8d      # r8d = i * i 
  cmpl %edi, %r8d       # compare (i * i) to n
  jg .Lis_prime         # if (i * i > n), loop ends => prime 

  movl %edi, %eax       # dividend 'n' -> %eax 
  cltd                  # sign extended %eax into %edx
  idivl %ecx            # divide by 'i', remainder goes to %edx

  cmpl $0, %edx         # is remainder == 0
  je .Lnot_prime        # divides evenly => not prime

  addl $2, %ecx         # i = i + 2
  jmp .Lloop_start      # jump back to check condition
  
.Lnot_prime:
  movl $0, %eax         # return 0
  ret

.Lis_prime:
  movl $1, %eax         # return 1
  ret



# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
