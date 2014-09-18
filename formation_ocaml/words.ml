let mots chaine = 
    let rec interne = function
       "", mots, courant -> "", courant::mots, "" 
     |  s, mots, courant -> 
         let amputee = String.sub s 1 (String.length(s)-1) in 
         match  s.[0]  with
        ' ' ->  interne (amputee, courant::mots , "")
        |_ -> interne (amputee,mots,(courant ^ (String.make 1 s.[0])))
    in 
       let (_,m,_ )= interne (chaine, [],"") 
       in List.filter ((<>) "") (List.rev m);;

let compte_occu s = 
    let les_mots = (mots s) and
        matable= Hashtbl.create 100 
    in let augmente x  = 
        try let comp = Hashtbl.find matable x in
            Hashtbl.replace matable x (comp + 1)  
        with
         Not_found -> Hashtbl.add matable x 1 
    in  List.iter augmente les_mots; 
        Hashtbl.iter (fun x y-> (Printf.printf " %s : %d\n" x y)) matable;;

module Nire_Giltza = struct
    type t = string 
    let compare = Pervasives.compare
end;;

module Nire_Mapa = Map.Make(Nire_Giltza);;

let zenbatu s = 
    let hitzak = (mots s)
    and m = Nire_Mapa.empty 
    and modif_map ma s =
        try let z = Nire_Mapa.find s ma 
          in   Nire_Mapa.add s (z+1) ma  
        with
          Not_found -> Nire_Mapa.add s 1 ma
    in Nire_Mapa.iter (Printf.printf "%s : %d\n") (List.fold_left modif_map m hitzak);; 

