import ctypes as ct
import sys


class CustomError(Exception):
    pass


def myCallBack(str):
    print(str, "\n")
    sys.stdout.flush()
    #raise callback.CustomError


# declation du type CallBack
CallBackType = ct.CFUNCTYPE(None, ct.c_char_p)

def main():
    lib_call_back = ct.PyDLL("./libcall_back.so")

    setCallBack = lib_call_back.setCallBack
    setCallBack.argtype = CallBackType
    setCallBack.restype = None

    callback = CallBackType(myCallBack)
    setCallBack(callback)

    lib_compute_sqrt = ct.PyDLL("./libcompute_sqrt.so")
    compute_sqrt = lib_compute_sqrt.compute_sqrt
    compute_sqrt.argtype = ct.c_double
    compute_sqrt.restype = ct.c_double

    try :
        print("√4", compute_sqrt(ct.c_double(4.)))
        print("√-4", compute_sqrt(ct.c_double(-4.)))
    except:
        print("Whew!", sys.exc_info()[0])
        #print("I raised THE exception 😎!")

if __name__ == "__main__":
    main()
