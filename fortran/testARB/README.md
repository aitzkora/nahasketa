try to compute the whittakerW function $exp(-z/2) z^{m+1/2} U(1/2+m -k, 1+2m, z)$ using arb
Prerequisites:
--------------
 - install flint (check in your distribution)
 - install ARB (git clone https://github.com/fredrik-johansson/arb && cd arb && ./configure --prefix=/path/to/install && make && make install)
INSTALL
-------
 - mkdir build && cd build && cmake -DARB_PREFIX=/path/to/install .. && make && make test
