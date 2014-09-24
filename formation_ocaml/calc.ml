type calc = int list;;

let convert l =  (l : calc);;
let pop = function  
     ((s ::l) : calc) -> ( (l: calc) , (s: int));;
let push (n : int) = function (l :calc) -> (((n::l) :calc), ());;
let add  = function l -> let ((a::b::q) : calc)= l in
                  ((((a + b)::q):calc),());;
let bind act   cont  = function  (l:calc) -> 
                    let (calc1, v) = (act l)
                    in let act1 = cont v
                    in  (act1 calc1) ;;
