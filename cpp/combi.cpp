#include <iostream>
#include <vector>
#include <cassert>
#include <numeric>
#include <iterator>
using namespace std;

vector<int> int2part(int n, int v) { 
    vector<int> x(n,0);
    for(int i = n-1; i >= 0; i--) 
        x[i] = (('0'+ ((v >> i) & 1)) == '1');
    return x;  
}

std::vector<std::vector<int> > generate_combi(int n, int p) {
    std::vector<std::vector<int> > combis; 
    assert(p <= n);
    for(int i = 0; i < (1 << n) ; ++i) {
        vector<int> base_2 = int2part(n, i);
        if (accumulate(base_2.begin(), base_2.end(), 0) == p) { 
            combis.push_back(base_2); 
        }
    }
    return combis;
}


int main() {
   int n = 4;
   int p = 3;
   std::vector<std::vector<int> > z = generate_combi(n, p);
   for(int i = 0; i < z.size(); i ++) {
      for(int j = 0 ; j < n; ++j) {
         if (z[i][j] == 1) cout << j << " " ; 
      }
     cout << endl;
   }
   return 0;
}
