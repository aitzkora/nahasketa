<script type="text/javascript" async 
src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js? 
config=TeX-MML-AM_CHTML"
</script>
testARB
-------

 computes the whittaker_W function $$exp(-z/2) z^{m+1/2} U(1/2+m -k, 1+2m, z)$$ using arb

Prerequisites:
--------------
 - install flint (check in your distribution)
 - install ARB 
   
   git clone https://github.com/fredrik-johansson/arb && cd arb && ./configure --prefix=/path/to/install && make && make install

INSTALL
-------
 - git clone 

    git clone git@github.com:aitzkora/nahasketa.git

 - go to subdirectory 

    cd nahasketa/fortran/testARB/

 - configure and compile 

    mkdir build && cd build && cmake -DARB_PREFIX=/path/to/install .. && make && make test

