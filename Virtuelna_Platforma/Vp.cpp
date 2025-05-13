#include "Vp.hpp"

using namespace sc_core;

Vp::Vp(sc_module_name name) :
    sc_module(name),
    mem("bram"),
    ic("Interconnect"),
    cp("Cpu"),
    conv("Convolution")
{
    cp.cpu_ic_isoc.bind(ic.ic_cpu_tsoc);
    ic.ic_mem_isoc.bind(mem.mem_cpu_tsoc);
    ic.ic_conv_isoc.bind(conv.conv_ic_tsoc);
    conv.conv_mem_isoc.bind(mem.mem_conv_tsoc);


    SC_REPORT_INFO("VP", "Platform is constructed");
}
