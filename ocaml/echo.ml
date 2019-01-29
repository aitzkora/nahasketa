let zut () = 
    let n = Array.length(Sys.argv)
    in 
    for i = 1 to n-1 do
        print_endline(Sys.argv.(i))
    done;;
zut ();;

