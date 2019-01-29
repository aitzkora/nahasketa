type calc;;
val convert : int list -> calc;;
val pop : calc -> (calc *  int);;
val push : int -> (calc -> (calc * unit));;
val add : calc -> (calc * unit);;
val bind : (calc -> 'a * 'b) -> ('b -> 'a -> 'c) -> calc -> 'c
