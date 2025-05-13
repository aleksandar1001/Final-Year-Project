#include "Interconnect.hpp"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

Interconnect::Interconnect(sc_module_name name) :
    sc_module(name),
    ic_cpu_tsoc("ic_cput_tsoc"),
    ic_conv_isoc("ic_conv_isoc"),
    ic_mem_isoc("ic_mem_isoc"),
    offset(SC_ZERO_TIME)
{
    ic_cpu_tsoc.register_b_transport(this, &Interconnect::b_transport);
    SC_REPORT_INFO("INTERCONNECT", "Interconnect is constructed");
}

void Interconnect::b_transport(pl_t& pl, sc_time& offset)
{
    uint64 taddr = 0;
    tlm_command cmd = pl.get_command();
    uint64 addr = pl.get_address();
    unsigned char *data = pl.get_data_ptr();

    switch(cmd)
    {
        case TLM_WRITE_COMMAND:
        {
            if(addr >= VP_ADDRESS_CONVOLUTION && addr <= VP_ADDRESS_CONVOLUTION_READY)
            {
                taddr = addr & 0x000FFFFF;
                pl.set_address(taddr);
                ic_conv_isoc -> b_transport(pl, offset);
                pl.set_address(addr);
            }
            else if(addr >= VP_ADDRESS_MEMORY && addr <= VP_ADDRESS_MEMORY_IMAGE_CONV)
            {
                taddr = addr & 0x000FFFFF;
	            pl.set_address(taddr);
	            ic_mem_isoc -> b_transport(pl, offset);
	            pl.set_address(addr);
            }
            break;
        }
        default:
            pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
            SC_REPORT_ERROR("INTERCONNECT", "TLM bad command");
            break;
    }
    offset += sc_time(5, SC_NS);
}

