type calc;;
val convert : int list -> calc;;
val pop : calc -> (calc *  int);;
val push : int -> (calc -> (calc * unit));;
val add : calc -> (calc * unit);;
val bind : (calc ->  (calc * 'a)) ->
           ('a -> (calc -> calc * 'a)) -> 
               (calc -> calc * 'a);;

