function(extract_dummy filename type size)
  file(READ "${filename}" contents_swp)
  string(REPLACE ";" "@" contents "${contents_swp}") #to fire those damned semi-colons!
  string(REGEX MATCHALL 
         ".*typedef struct {\n *double *dummy\\[([0-9])+\\]@\n} SCOTCH_${type}@.*"
         dummy_type
         ${contents})
  list(LENGTH dummy_type l_dummy)
  if (l_dummy EQUAL "1")
    message(STATUS "👍")
    string(REGEX REPLACE ".*typedef struct {\n *double *dummy\\[(([0-9])+)\\]@\n} SCOTCH_${type}@.*"
    "\\1" size ${contents})
    message(STATUS " size -> ${size}")
  else()
    message(STATUS "😐")
  endif() 
endfunction()
