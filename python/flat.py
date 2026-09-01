import numpy as np

def parcours(a):
    s = [round(x/a.itemsize) for x in a.strides]
    for x in range(np.prod(a.shape)):
        coo = tuple(np.flip([x % w for w in s]))
        print(coo, np.flip(coo), a.flat[x])
