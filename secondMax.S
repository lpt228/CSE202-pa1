.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  cmpw %si, %di           # Compare v1 (%di) with v2 (%si)
  jl .Lv2_greater

  movw %di, %ax           # first = v1
  movw %si, %r8w          # second = v2
  jmp .Lcheck_v3

.Lv2_greater:
  movw %si, %ax           # first = v2
  movw %di, %r8w          # second = v1

.Lcheck_v3:
  cmpw %ax, %dx           # compare v3 (%dx) with first (%ax)
  jle .Lcheck_v3_second

  movw %ax, %r8w          # second = first
  movw %dx, %ax           # first = v3
  jmp .Lcheck_v4

.Lcheck_v3_second:
  cmpw %r8w, %dx          
  jle .Lcheck_v4          # if v3 <= second, skip
  movw %dx, %r8w          # second = v3

.Lcheck_v4:
  cmpw %ax, %cx           # Compare v4 (%cx) with first (%ax)
  jle .Lcheck_v4_second

  movw %ax, %r8w          # second = first
  movw %cx, %ax           # first = v4
  jmp .Ldone

.Lcheck_v4_second:
  cmpw %r8w, %cx          # compare v4 (%cx) with second (%r8w)
  jle .Ldone              # if v4 <= second, skip
  movw %cx, %r8w          # second = v4

.Ldone:
  movw %r8w, %ax          # move 'second' into return register %ax
  retq

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
