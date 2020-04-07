define pTriangle
if $argc .eq. 0
    help pTriangle
end
if $argc .eq. 1
    printf "Triangle : [%d, %d, %d]\n", $arg0 % t(1) % index, $arg0 % t(2) % index, $arg0 % t(3) % index
end
end
document pTriangle
    Prints the list of index of a triangle
    Syntax: pTriangle triangle
end
