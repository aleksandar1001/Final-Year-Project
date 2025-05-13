#ifndef _CPU_HPP_
#define _CPU_HPP_

#include <systemc>
#include <random>
#include "adrese.hpp"
#include "Convolution.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

class Cpu : public sc_core::sc_module
{
public:
    Cpu(sc_core::sc_module_name);

    tlm_utils::simple_initiator_socket<Cpu> cpu_ic_isoc;

protected:
    sc_dt::sc_uint<1> ready;
    int counter_of_covolued_images; //counter that increments himself whenever covolution is finished.

    Matrix image;
    Kernel kernel;

    void sendData();

    tlm::tlm_generic_payload pl;
    sc_core::sc_time offset;

    typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
    void b_transport(pl_t &, sc_core::sc_time &);
};

#endif
