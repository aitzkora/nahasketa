import numpy as np

def get_coo(n, strides):
    coo = np.zeros(len(strides), int)
    r = n
    for (i,s) in enumerate(strides):
        coo[i] = r // s
        r = r % s
    return coo

def parcours(a):
    s = [round(x/a.itemsize) for x in a.strides]
    for x in range(np.prod(a.shape)):
        coo = get_coo(x, s)
        print(a.flat[x], a.flat[sum(coo * s)])
