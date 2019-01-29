let l = 
    object
     val mutable haha = 1
     method haha = haha
     method z du = du + haha
     method modif = {< z = fun x -> x * haha>}
    end;; 
