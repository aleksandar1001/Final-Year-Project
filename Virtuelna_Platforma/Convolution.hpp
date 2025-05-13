#ifndef _CONVOLUTION_HPP_
#define _CONVOLUTION_HPP_

#include <systemc>
#include "adrese.hpp"
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/tlm_quantumkeeper.h>

 extern sc_core::sc_event done; //needs the word extern to be avaiable in other cpp files

class Convolution : public sc_core::sc_module
{
public:
    Convolution(sc_core::sc_module_name);

    tlm_utils::simple_target_socket<Convolution> conv_ic_tsoc;
    tlm_utils::simple_initiator_socket<Convolution> conv_mem_isoc;

protected:
    sc_dt::sc_uint<1> ready;

    Matrix image;
    Kernel kernel;
    Matrix_Conv image_conv;

    tlm::tlm_generic_payload pl;
    sc_core::sc_time offset;

    typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
    void b_transport(pl_t &, sc_core::sc_time &);

    Matrix_Conv get_convolued_image(Matrix, Kernel);

    void convolution();
};

#endif
