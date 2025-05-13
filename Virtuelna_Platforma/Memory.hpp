#ifndef _MEMORY_HPP_
#define _MEMORY_HPP_

#include <systemc>
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <fstream>
#include "adrese.hpp"

class Memory : public sc_core::sc_module
{
public:
    Memory(sc_core::sc_module_name);

    tlm_utils::simple_target_socket<Memory> mem_conv_tsoc;
    tlm_utils::simple_target_socket<Memory> mem_cpu_tsoc;
protected:
    Matrix image;
    Kernel kernel;
    Matrix_Conv image_conv;
    std::string filename;

    typedef tlm::tlm_base_protocol_types::tlm_payload_type pl_t;
    void writeMatrixTofile(Matrix_Conv, std::string);

    void b_transport(pl_t&, sc_core::sc_time&);
    void showData(unsigned char*, int, int);
};

#endif
