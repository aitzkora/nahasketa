set(abc "5_6_7")
string(REPLACE "_" " " hehe ${abc})
message(STATUS ${hehe})
