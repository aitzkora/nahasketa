#include <iostream>
#include <vector>
#include <array>
#include <functional>
#include <map>
using namespace std;

template <typename I>
struct range_adapter
{
    std::pair<I, I> p;

    range_adapter(const std::pair<I, I> &p) : p(p) {}

    I begin() const
    {
        return p.first;
    }

    I end() const
    {
        return p.second;
    }
};

template <typename I>
range_adapter<I> as_range(const std::pair<I, I> &p)
{
        return range_adapter<I>(p);
}



int main(int argc, char * argv[])
{
    multimap<string, int> haha = {{ "hihi", 12}, {"hoho", 12}, { "hihi", 45}, { "toto", -2}};
    for(auto &x : as_range(haha.equal_range("hihi")))
    {
     cout << x.second << endl;
    }
    return 0;
}
