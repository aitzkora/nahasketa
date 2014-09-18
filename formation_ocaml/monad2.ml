type calc = int list;;

let popcalc = (function  ((s :int) ::l  ) -> ( l , s));;
let pushcalc n = function l -> (n::l, ());;
let addcalc  = function lst -> let (a::b::rest) = lst in
                  ((a+b)::rest,());;
let f1 = popcalc
let a_calc = [1;2;3];;
let (_,z) = f1 a_calc;;
(* Rube GOldberg *)
let ajout x y = 
     let pux = pushcalc x
 and  puy = pushcalc y
 and  axy = addcalc 
 and  pp = popcalc 
 and  calcul = ([]) 
 in  let (c1, _) = pux calcul 
 in  let  (c2, _) = puy c1 
 in let (c3, _) = axy c2 
 in  let (_, c4) = pp c3 in c4;;

