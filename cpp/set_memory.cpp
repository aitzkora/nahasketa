#include <iostream>
#include <fstream>
#include <regex>
#include <set>
#include <cstdlib>

using namespace std;

unsigned int occupiedMemory()
{
    ifstream fichier("/proc/self/status");
    unsigned int  size = 0;
    for (string line; getline(fichier, line); )
    {
        regex const pattern { ".*VmSize:\\s+(\\d+)\\s*kB.*" };
        smatch match;
        if (regex_match(line, match, pattern))
            size = stoi(match[1]);
    }
    return size;
}
template <typename T>
unsigned estimateSetSize(const set<T> & s)
{
   unsigned int count = 0;
   return s.size() * sizeof(T);
}


int main(int argc, char * argv[])
{
  set<int> a;
  auto before = occupiedMemory();
  cout << "sizeof(char) = " << sizeof(char) << endl;
  cout << "before inserting : " << before << endl;
  for(int i = 0;i < 10000 ; ++i)
      a.insert(rand() * 100);
  auto after = occupiedMemory();
  cout << "after inserting : " << after << endl;
  cout << "estimate memory occupation : " << estimateSetSize(a)<< "B" << endl;
  cout << "«true» memory occupation : " << after - before << "kB" << endl;
  
  // test with pointer
  before = occupiedMemory();
  int N=2000;
  int * p= new int[N];
  for(auto i = 0; i < N ; ++i)
      p[i] = rand();
  after = occupiedMemory();
  cout << "pointer estimate memory occupation : " << N * sizeof(int)<< "B" << endl;
  cout << "pointer «true» memory occupation : " << after - before << "kB" << endl;
  delete [] p;
  return 0;
}
