# Example of setting a callback from python using ctypes and calling it
Only  tested on Linux

# to test
```bash
cmake -B build && make -C build install
LD_PRELOAD="./libcall_back.so" python3 error.py
```

# requirements
- CMake > 3.9
- a standard python installation

# Thanks 
to CristiFati for his [SO answser](https://stackoverflow.com/questions/67079630/how-to-call-assign-dynamically-a-python-method-to-a-c-pointer-function-exported)
