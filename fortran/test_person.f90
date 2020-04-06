program test_person
   use person
   class(individual) :: a 
   a = individual("joelly", 3)
   call a % salut()
end program test_person
    
