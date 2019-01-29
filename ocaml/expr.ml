type 'a expr = 
   Entier of 'a 
 | Plus of 'a expr * 'a expr 
 | Moins of 'a expr * 'a expr
 | Fois of 'a expr * 'a expr
 | Divise of 'a expr * 'a expr;;

type 'a binop = 'a -> 'a -> 'a;;
type 'a operators = {
    plus  : ('a binop) ;
    moins : ('a binop) ;
    fois : ('a binop) ;
    divise : ('a binop )};;

let rec calcule op= function
    Entier(n) -> n
  | Plus(a,b) ->  (op.plus (calcule op a)  (calcule op b))
  | Moins(a,b) -> op.moins (calcule op a)  (calcule op b)
  | Fois(a,b) -> op.fois (calcule op a)  (calcule op b)
  | Divise(a,b) -> op.divise (calcule op a)  (calcule op b);;
    
let op_entiers = { plus= (+); moins = (-); fois =( * ); divise = (/) };;
let op_flottants = { plus= (+.); moins = (-.); fois =( *. ); divise = (/.) };;

calcule op_entiers (Divise(Entier(2), Entier(1)));;
calcule op_flottants (Divise(Entier(3.), Entier(4.)));;



