program printKind
integer, parameter :: kind8 = selected_real_kind(8)
integer, parameter :: kind16 = selected_real_kind(16)

print *, "kind for 8 = ", kind8
print *, "kind for 16 = ", kind16

end program printKind
