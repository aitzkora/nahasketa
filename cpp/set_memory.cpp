#include <iostream>
#include <fstream>
#include <regex>
#include <set>
#include <cstdlib>
#include <unordered_map>

using namespace std;

// heuristic to measure the occupied memory by this process
size_t occupiedMemory()
{
    ifstream fichier("/proc/self/status");
    size_t size = 0;
    for (string line; getline(fichier, line); )
    {
        regex const pattern { ".*VmSize:\\s+(\\d+)\\s*kB.*" };
        smatch match;
        if (regex_match(line, match, pattern))
            size = stoi(match[1]);
    }
    return size;
}

// rough estimate of a set size
template <typename T>
size_t estimatedSizeOfSet(const set<T> & s)
{
   size_t count = 0;
   return s.size() * sizeof(T);
}


template <typename T>
size_t estimatedSizeOfHashMapOfSet(const unordered_map<T, set<T>> & hash)
{
  size_t count = 0;
  for (unsigned i = 0; i < hash.bucket_count(); ++i)
  {
      size_t bucket_size = hash.bucket_size(i);
      if (bucket_size == 0)
      {
          count += sizeof(T);
      }
      else
      {
         for(auto it = hash.cbegin(i); it != hash.cend(i); ++it)
             count += estimatedSizeOfSet(it->second);
      }
  }
  return count;
}

// function returning a number between 0 and maxVal
size_t rand_max(size_t maxVal)
{
    return (size_t)((rand()/(double)RAND_MAX)*(double)maxVal);
}

template <typename T, size_t nbKeys, size_t nbSetElems>
void initHashMapOfSet(unordered_map<T,set<T>> & hash)
{
  for(int i = 0;i < nbKeys ; ++i)
  {
      size_t keyVal = rand_max(nbKeys* 2);
      size_t localNbSetElems = rand_max(nbSetElems);
      set<int> tempo;
      for(int j = 0; j < localNbSetElems  ; ++j)
            tempo.insert(rand() * 100);
      hash[keyVal] = std::move(tempo); // do not copy the set
  }
}

int main(int argc, char * argv[])
{
  size_t before, after;
  // test with set
  //set<int> a;
  //auto before = occupiedMemory();
  //cout << "sizeof(char) = " << sizeof(char) << endl;
  //cout << "before inserting : " << before << endl;
  //for(int i = 0;i <30000 ; ++i)
  //    a.insert(rand() * 100);
  //auto after = occupiedMemory();
  //cout << "after inserting : " << after << endl;
  //cout << "estimate memory occupation : " << estimatedSizeOfSet(a)/ (1 << 10) << "kB" << endl;
  //cout << "«true» memory occupation : " << after - before << "kB" << endl;

  // test with set
  unordered_map<int, set<int>> h;
  before = occupiedMemory();
  cout << "before inserting : " << before << endl;
  initHashMapOfSet<int,1000, 1000>(h);
  after = occupiedMemory();
  cout << "after inserting : " << after << endl;
  cout << "hashMap estimate memory occupation : " << estimatedSizeOfHashMapOfSet(h)/ (1 << 10) << "kB" << endl;
  cout << "hashMap «true» memory occupation : " << after - before << "kB" << endl;

  // test with pointer
  //before = occupiedMemory();
  //int N=20000;
  //int * p= new int[N];
  //for(auto i = 0; i < N ; ++i)
  //    p[i] = rand();
  //after = occupiedMemory();
  //cout << "pointer estimate memory occupation : " << N * sizeof(int) / (1 << 10) << "kB" << endl;
  //cout << "pointer «true» memory occupation : " << after - before << "kB" << endl;
  //delete [] p;
  //// test with vector
  //before = occupiedMemory();
  //N=20000;
  //std::vector<int> vec;
  //for(auto i = 0; i < N ; ++i)
  //    vec.push_back(rand());
  //after = occupiedMemory();
  //cout << "vector estimate memory occupation : " << N * sizeof(int) / (1 << 10) << "kB" << endl;
  //cout << "vector «true» memory occupation : " << after - before << "kB" << endl;


  return 0;
}
