let lis_rep s = 
   let desc_tmp = Unix.opendir s in
   while (  
       try let suivante = Unix.readdir(desc_tmp) in
           (Printf.printf "%s\n" suivante); 
           true
       with
          End_of_file -> false) do ()
          done;;
lis_rep("/tmp");;
