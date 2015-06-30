#include <iostream>
#include <vector>
#include <cassert>
#include <numeric>
#include <iterator>
#include <array>
#include <algorithm>
using namespace std;

std::vector<int> int2part(int n, int v) { 
    std::vector<int> x(n,0.);
    for(int i = n-1; i >= 0; i--) 
        x[i]= ('0'+ ((v >> i) & 1)) == '1';
    return x;  
}
template <int P>
std::vector<std::array<int, P> > generate_combi(std::vector<int> set) {
    std::vector<std::array<int, P> > combis; 
    auto n = set.size(); 
    assert(P <= n);
    for(int i = 0; i < (1 << n) ; ++i) {
        auto base_2 = int2part(n, i);
        if (accumulate(base_2.begin(), base_2.end(), 0) == P) { 
            std::array<int, P> tmp; 
            for(int j = 0, k = 0; j < set.size(); ++j)
               if (base_2[j] == 1) tmp[k++] = set[j];
            combis.push_back(tmp);
        } 
    }
    return combis;
}


int main() {
   constexpr int p = 2;
   std::vector<int> t = { 1, 2 , 3, 4};
   auto z = generate_combi<p>(t);
   for(int i = 0; i < z.size(); i++) {
       for(int zj :z[i] ) {
        std::cout << zj << " "; 
      }
     cout << endl;
   }
   return 0;
}
