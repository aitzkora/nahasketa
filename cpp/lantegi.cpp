#include <iostream>
#include <vector>
using namespace std;
class Base {
public:
  Base() {};
  ~Base() {};
  virtual int eval(int x) = 0; 
};     
class f1 : public Base {
public:
  int c;
  f1(int cx):c(cx) {};
  int eval(int x) { return c+x;}
  ~f1(){};
};


class f2 : public Base {
public:
  int c,d;
  f2(int cx, int dx):c(cx),d(dx) {};
  int eval(int x) { return c*x+d;}
  ~f2(){};
};


class Lantegia {
public:
  vector<Base*> la_base; 

  Lantegia() {} 
  
  void record(Base * un_objet) {
     la_base.push_back(static_cast<Base*> (un_objet));
  }

  int eval_sum(int x) {
      int accu = 0;
      for(auto v : la_base) {
        accu +=v->eval(x); 
      }
    return accu;
  }

  ~Lantegia(){
    for( auto v : la_base) {
         delete v; 
      }
   }
};

int main() {
   Lantegia s;
   s.record(new f1(1));
   s.record(new f2(2,3));
   cout << s.eval_sum(1) << endl;
   return 0;
}

