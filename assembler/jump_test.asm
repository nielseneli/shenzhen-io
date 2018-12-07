loop:
  teq acc 100
+ jmp end
  mov 50 x2
  add 1
  jmp loop
end:
  mov 0 acc
