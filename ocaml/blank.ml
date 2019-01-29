let blank chaine = 
    
    let i = ref 0 and
        ch = String.copy chaine
    while (not (chaine.[!i] = 's')) do
        ch.[!i] = ' '
         incr i
    done;;     
