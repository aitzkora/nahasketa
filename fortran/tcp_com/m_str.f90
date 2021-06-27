submodule (m_dill) str
contains
  module procedure from_c
 
     integer :: pos
  
     pos = index( string, achar(0) )
     if ( pos > 0 ) then
         from_c = string(1:pos)
     else 
         from_c = string
     endif
  end procedure from_c

end submodule str
