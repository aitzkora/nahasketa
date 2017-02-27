# Read a matrix in a text file, where each entry in separated of the next
# by some whitespaces
macro(read_matrix fileName outputMatrix outputnbCols)
    file(STRINGS ${fileName} fileData)
    message(STATUS "Reading the matrix in the text file ${fileName}")
    list(LENGTH fileData nbRows)
    message(STATUS "nbRows = ${nbRows}")
    list(GET fileData 0 rowZero)
    string(REGEX MATCHALL "[^\ ]+\ +|[^\ ]+$" rowZeroList "${rowZero}")
    list(LENGTH rowZeroList nbCols)
    message(STATUS "nbCols = ${nbCols}")
    math(EXPR nbRowsMinusOne "${nbRows} - 1")
    math(EXPR nbColsMinusOne "${nbCols} - 1")
    foreach(rowNumber RANGE ${nbRowsMinusOne})
        list(GET fileData ${rowNumber} rowData)
        string(REGEX MATCHALL "[^\ ]+\ +|[^\ ]+$" rowDataList "${rowData}")
        foreach(colNumber RANGE ${nbColsMinusOne})
            list(GET rowDataList ${colNumber} entryIJ)
            string(REPLACE " " "" entryIJWithoutSpaces ${entryIJ})
            message(STATUS "(${rowNumber},${colNumber}) = ${entryIJWithoutSpaces}")
        endforeach()
    endforeach()
endmacro(read_matrix)

macro(display_matrix matrix)
    list(LENGTH matrix nbRows)
    list(GET matrix 0 rowZero)
endmacro(display_matrix)



read_matrix("table_test")
