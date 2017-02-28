# Read a matrix in a text file, where each entry in separated of the next
# by some whitespaces
# @fileName : filename containing the matrix
# @matrix : name of the variable where we store the read matrix
# @nbColsOut : name of the variable containing the number of columns
macro(read_matrix fileName matrix nbColsOut)
    file(STRINGS ${fileName} fileData)
    list(LENGTH fileData nbRows)
    list(GET fileData 0 rowZero)
    string(REGEX MATCHALL "[^\ ]+\ +|[^\ ]+$" rowZeroList "${rowZero}")
    list(LENGTH rowZeroList nbCols)
    set(nbColsOut ${nbCols})
    message(STATUS "Reading the matrix in the text file ${fileName} (${nbRows}, ${nbCols})")
    math(EXPR nbRowsMinusOne "${nbRows} - 1")
    math(EXPR nbColsMinusOne "${nbCols} - 1")
    foreach(rowNumber RANGE ${nbRowsMinusOne})
        list(GET fileData ${rowNumber} rowData)
        string(REGEX MATCHALL "[^\ ]+\ +|[^\ ]+$" rowDataList "${rowData}")
        foreach(colNumber RANGE ${nbColsMinusOne})
            list(GET rowDataList ${colNumber} entryIJ)
            string(REPLACE " " "" entryIJWithoutSpaces ${entryIJ})
            list(APPEND ${matrix} ${entryIJWithoutSpaces})
        endforeach()
    endforeach()
endmacro(read_matrix)

# to display matrix
# @matrix : flat list with all elements of the matrix
# @nbCols : number of columns for the matrix
macro(display_matrix matrix nbCols)
    list(LENGTH ${matrix} nbElements)
    math(EXPR nbElementsMinusOne "${nbElements} - 1")
    foreach(i RANGE ${nbElementsMinusOne})
        math(EXPR isBeginningOfRow "(${i}+1) % ${nbCols}")
                list(GET ${matrix} ${i} elem)
        set(row "${row} ${elem}")
        if(${isBeginningOfRow} EQUAL "0")
            message(STATUS ${row})
            set(row "")
        endif()
endforeach()
endmacro(display_matrix)

# a test
read_matrix("mat.txt" mat nbCols)
display_matrix(mat ${nbCols})
