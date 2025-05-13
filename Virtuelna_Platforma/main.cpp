#include <iostream>
#include <systemc>
#include "Vp.hpp"

using namespace std;
using namespace sc_core;

int sc_main(int argc, char* argv[])
{

    Vp v("Virtual_Platform");

    sc_start(1, SC_MS);
    //sc_start(1000, SC_MS);

    cout << endl;
    cout << "simulacija se zavrsila u simulacionom trenutku: " << sc_time_stamp() << endl;

    return 0;
}
