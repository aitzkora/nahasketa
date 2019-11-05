# wrapTest
small cmake wrapper to extract test from a fortran file

each subroutine respecting the following naming rule
```fortran
subroutine test_XXX 
```
will be take into account in the wrapper. 
A test named XXX will be added to the ctest system
