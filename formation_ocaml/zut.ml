let rec iota n = match n with
        0 -> [0]
        | _ ->iota(n-1)@[n]

let rec mon_map f l = match l with
        [] -> []
      | s :: q -> (f s)::(mon_map f q);;
        
let rec mon_min l = 
    if List.length(l) = 0 then
        max_int
    else 
        min (List.hd l) (mon_min (List.tl l));;

let ma_moy l =  
    if List.length(l) = 0 then
      0.
    else
        float(List.fold_left (+) 0 l)/.float(List.length(l));;

let palindrome_list l = 
    let rec interne l1 l2 = match l1, l2 with
        [], [] -> true
      | s1::q1, s2::q2 when s1 = s2 -> (interne q1 q2)
      | _, _ ->false
    in interne l (List.rev l);;

