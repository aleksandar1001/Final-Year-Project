#ifndef _VP_HPP_
#define _VP_HPP_
#include <systemc>

#include "Memory.hpp"
#include "Cpu.hpp"
#include "Interconnect.hpp"
#include "Convolution.hpp"
#include "adrese.hpp"


class Vp:sc_core::sc_module
{
public:
   Vp(sc_core::sc_module_name);
protected:
    Memory mem;
    Interconnect ic;
    Cpu cp;
    Convolution conv;
};

#endif
