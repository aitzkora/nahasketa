#include <iostream>
#include <vector>
#include <array>
#include <functional>
#include <map>
#include <cmath>
using namespace std;
int main(int argc, char * argv[])
{
    using ScalarField = std::function<double(double x)>;
    map<string,ScalarField> hehe;
    hehe["plus2"] = [] (double x) { return x+2;};
    hehe["fabs"] = [](double x) { return fabs(x);};
    cout << hehe["plus2"](-2.) << endl;
    return 0;
}
