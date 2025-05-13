#include "Convolution.hpp"
#include <systemc>
#include <iostream>
#include <tlm>
#include <tlm_utils/simple_target_socket.h>

using namespace std;
using namespace sc_core;
using namespace sc_dt;
using namespace tlm;

SC_HAS_PROCESS(Convolution);
sc_event done;

Convolution::Convolution(sc_module_name name) :
    sc_module(name),
    conv_ic_tsoc("conv_ic_tsoc"),
    conv_mem_isoc("conv_mem_isoc"),
    ready('0'),
    offset(SC_ZERO_TIME)
{
    SC_THREAD(convolution);
    conv_ic_tsoc.register_b_transport(this, &Convolution::b_transport);
    SC_REPORT_INFO("IP", "IP is constructed");
}

Matrix_Conv Convolution::get_convolued_image(Matrix slika, Kernel filtar)
{
     int R_in = ROWS - 3  + 1;
     int P_in = COLS - 3 + 1;

     Matrix_Conv result;

    for(int i{0}; i < P_in; ++i)
    {
        for(int j{0}; j < R_in; ++j)
        {
            int sum = 0;
            for(int m{0}; m < 3; ++m)
            {
                for(int n{0}; n < 3; ++n)
                {
                    sum += slika(i + m, j + n) * filtar(m, n);
                }
            }
            if(sum > 255) sum = 255;
            else if(sum < 0) sum = 0;

            result(i, j) = sum;
        }
    }
    return result;
}

void Convolution::b_transport(pl_t& pl, sc_time& offset)
{
    tlm_command cmd = pl.get_command();
    uint64 addr = pl.get_address();
    unsigned char *data = pl.get_data_ptr();

    switch(cmd)
    {
        case TLM_WRITE_COMMAND:
        {
            switch(addr)
            {
                case CONVOLUTION_READY:
                    ready = *((sc_uint<1>*)data);
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "IP: Ready flag recieved from cpu at: " << sc_time_stamp() << endl;
                    break;
                default:
                    pl.set_response_status(TLM_ADDRESS_ERROR_RESPONSE);
                    SC_REPORT_ERROR("IP", "Invalid address");
                    break;
            }
        }
        break;
        default:
            pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
            SC_REPORT_ERROR("IP", "Invalid command");
            break;
    }
    offset += sc_time(5, SC_NS);
}

void Convolution::convolution()
{
    tlm_command cmd = pl.get_command();
    uint64 addr = pl.get_address();
    unsigned char *data = pl.get_data_ptr();

    while(true)
    {
        wait(65, SC_NS); //needs this wait. It takes 65ns for CPU to send all his things to IP and memorys
        if(ready == 1)
        {
            cout << "IP: Ready flag became 1, and we can begin the 2Dconvolution at: " << sc_time_stamp() << endl;
            pl.set_address(MEMORY_IMAGE);
            pl.set_data_ptr(reinterpret_cast<unsigned char*>(&image.data));
            pl.set_data_length(ROWS * COLS * sizeof(unsigned char));
            pl.set_command(TLM_READ_COMMAND);
            wait(10, SC_NS);
            conv_mem_isoc -> b_transport(pl, offset);
            wait(10, SC_NS);
            cout << "IP: Image from memory recieved at: " << sc_time_stamp() << endl;

            pl.set_address(MEMORY_KERNEL);
            pl.set_data_ptr(reinterpret_cast<unsigned char*>(&kernel.data));
            pl.set_data_length(3 * 3 * sizeof(unsigned char));
            pl.set_command(TLM_READ_COMMAND);
            wait(10, SC_NS);
            conv_mem_isoc -> b_transport(pl, offset);
            wait(10, SC_NS);
            cout << "IP: Kernel from memory recieved at: " << sc_time_stamp() << endl;

            wait(15, SC_NS);

            image_conv = get_convolued_image(image, kernel);

            cout << "IP: CONVOLUTION2D is finished!!! at: " << sc_time_stamp() << endl;

            pl.set_address(MEMORY_IMAGE_CONV);
            pl.set_data_ptr(reinterpret_cast<unsigned char*>(&image_conv.data));
            pl.set_data_length((ROWS - 3 + 1) * (COLS - 3 + 1) * sizeof(unsigned char));
            pl.set_command(TLM_WRITE_COMMAND);
            pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
            cout << "IP: Image_conv sent to memory at: " << sc_time_stamp() << endl;
            wait(10, SC_NS);
            conv_mem_isoc -> b_transport(pl, offset);

            ready = 0;
            done.notify(); //interrupt to signalize to CPU that convolution is over
        }
    }
}
