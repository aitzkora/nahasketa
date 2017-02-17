#include <iostream>
#include <vector>
#include <array>
#include <functional>
#include <unordered_map>
#include <set>
#include <cstdlib>
#include <ratio>
#include <chrono>

using namespace std;
using namespace std::chrono;
template <typename T>
using HashMap = unordered_map<T, set<T>>;

template <typename T>
void moveHashMap(HashMap<T> & dest, HashMap<T> & src)
{
  for (auto && z : src)
      dest[z.first] = std::move(z.second);
}

template <typename T>
void copyHashMap(HashMap<T> & dest, const HashMap<T> & src)
{
  for (auto & z : src)
      dest[z.first] = z.second;
}

template <int M, int N, typename T>
void initHashMap(HashMap<T> & hash)
{
  for(int i = 0; i < M; ++i)
  {
    for(int j = 0; j < N; ++j)
        hash[i].insert(static_cast<T>(rand() % 100));
  }

}

double toSeconds(steady_clock::time_point & clock_begin, steady_clock::time_point & clock_end)
{
    steady_clock::duration time_span = clock_end - clock_begin;
    double nseconds = double(time_span.count()) * steady_clock::period::num / steady_clock::period::den;
    return nseconds;
}

int main(int argc, char * argv[])
{

    HashMap<int> m1, m2, m3;
    initHashMap<50000,60>(m1);
    steady_clock::time_point clock_begin = steady_clock::now();
    copyHashMap(m2, m1);
    steady_clock::time_point clock_end = steady_clock::now();
    cout << "copy takes " << toSeconds(clock_begin, clock_end) << endl;
    clock_begin = steady_clock::now();
    moveHashMap(m2, m1);
    clock_end = steady_clock::now();
    cout << "move takes " << toSeconds(clock_begin, clock_end) << endl;
    return 0;
}
