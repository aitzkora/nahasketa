#load "calc.cmo"
open Calc;;
let f1 = Calc.pop
let a_calc = Calc.convert [1;2;3] 
let (_,z) = f1 a_calc;;
(* Rube GOldberg *)
let ajout x y = 
     let pux = Calc.push x
 and  puy = Calc.push y
 and  axy = Calc.add 
 and  pp = Calc.pop 
 and  calcul = convert [] 
 in  let (c1, _) = pux calcul 
 in  let (c2, _) = puy c1 
 in  let (c3, _) = axy c2 
 in  let (_, c4) = pp c3 in c4;;

let ajout2 x y = 
    bind (push x) (fun () ->
        bind (push y) (fun ()  ->
           bind add  (fun () -> 
               bind pop  (fun l -> (l,z)))));;   
