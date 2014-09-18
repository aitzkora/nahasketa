let bind m f = 
    match m with
      None  -> None
     |Some x-> f x;;  

let return x = Some x;; 
let join mmx = bind mmx (fun x-> x);; 
let compose f g x =
      bind (f x) (fun s -> 
           bind (g s) return);;               

let f = function 
     0. -> None
   | x -> Some (1./.x);;

let g = function
   | x -> Some (x*.x);;

compose f g 0.;;
compose f g 5.;;

