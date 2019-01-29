class pile = 
    object 
      val mutable l : int list = []
      method peek = match l with
            [] -> None
            |s::l -> Some s
      method pop = match l with
            [] -> None
            |s::p -> l<- p; Some s
      method push w = l<- w::l     
    end;;
