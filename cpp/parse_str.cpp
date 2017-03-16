#include <iostream>
#include <vector>
#include <array>
#include <functional>
#include <sstream>
#include <cassert>

using namespace std;
int main(int argc, char * argv[])
{
    //string test = "hehe haha 12 3. hehe 15";
    string test = "hehe haha 12 3. 15 0. prout";
    istringstream str(test);
    string one, two;
    str >> one;
    str >> two;
    vector<double> params;
    double oneDouble;
    while (str >> oneDouble)
    {
      params.push_back(oneDouble);
    }
    cout << one << endl;
    cout << two << endl;
    cout << "params =";
    for(auto &z : params) { cout << z << " " ;}
    cout << endl;
    return 0;
}
