#include <cinttypes>
#include <vector>
#include <numeric>

extern "C" {
double mysum2(int64_t n, double *x);
};

double mysum2(int64_t n, double *x)
{
    double s = 0;
    std::vector<double> t(x, x + n);
    for(auto & z : t) s+= z;
    return s;
}
