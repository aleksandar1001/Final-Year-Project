#ifndef _INTERCONNECT_HPP_
#define _INTERCONNECT_HPP_

#include "adrese.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>

class Interconnect : public sc_core::sc_module
{
public:
    Interconnect(sc_core::sc_module_name);

    tlm_utils::simple_target_socket<Interconnect> ic_cpu_tsoc;
    tlm_utils::simple_initiator_socket<Interconnect> ic_conv_isoc;
    tlm_utils::simple_initiator_socket<Interconnect> ic_mem_isoc;

protected:
    sc_core::sc_time offset;
    typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
    void b_transport(pl_t&, sc_core::sc_time&);
};

#endif
