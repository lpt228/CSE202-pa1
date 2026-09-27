.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movb %dil, %al              # %al = a
  movb $7, %cl                # %cl = 7
  imulb %cl                   # %al * %cl -> result in %ax (%al holds lower 8 bits, 'mult')
                              # Now %al holds 'mult', %dil holds 'a'
  # check first condition
  cmpb $0, %dil               # compare 'a' with 0
  jle .Lcheck_cond2           # if a <= 0, first half is false; jump to check second condition

  cmpb $0, %al                # compare 'mult' with 0
  jl .Lset_overflow_true      # if mult < 0, (a > 0 && mult < 0) is TRUE -> set overflow = 1

.Lcheck_cond2:
  # check second condition
  cmpb $0, %dil               # compare 'a' with 0
  jge .Lset_overflow_false    # if a >= 0, both conditions failed => set overflow = 0

  cmpb $0, %al                # compare 'mult' with 0
  jg .Lset_overflow_true     # if mult > 0, (a < 0 && mult > 0) is TRUE -> set overflow = 1

.Lset_overflow_false:
  movb $0, (%rsi)             # *overflow = 0
  jmp .Ldo_divide

.Lset_overflow_true:
  movb $1, (%rsi)             # *overflow = 1

.Ldo_divide:
  cbw                         # convert byte to word
  movb $8, %cl                # %cl = 8
  idivb %cl                   # %al/%cl 

  ret






# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
