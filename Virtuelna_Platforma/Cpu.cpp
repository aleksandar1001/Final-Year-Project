#include "Cpu.hpp"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

SC_HAS_PROCESS(Cpu);
Cpu::Cpu(sc_module_name name) :
    sc_module(name),
    cpu_ic_isoc("cpu_ic_isoc"),
    offset(SC_ZERO_TIME),
    ready(1),
    counter_of_covolued_images(0)
{
    SC_THREAD(sendData);

    SC_REPORT_INFO("CPU", "Cpu is constructed");
}

void Cpu::sendData()
{
while(1)
{
    int counter{0};
    int niz[9] = {0, 0 , 0, 0, 1, 0, 0, 0 , 0};
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<int>dist(0, 255); //generation of random numbers from 0 to 255
        //writing data in matrix
        for(int i{0}; i < ROWS; ++i)
        {
            for(int j{0}; j < COLS; ++j)
            {
                image(i, j) = static_cast<unsigned char>(dist(gen));
            }
        }
        //writing data in kernel
           for(int i{0}; i < 3; ++i)
        {
            for(int j{0}; j < 3; ++j)
            {
                kernel(i, j) = niz[counter];
                ++counter;
            }
        }

        //creating TLM transactions:
        tlm_generic_payload pl;
        pl.set_address(VP_ADDRESS_MEMORY_IMAGE);
        pl.set_data_ptr(reinterpret_cast<unsigned char*>(&image.data));
        pl.set_data_length(ROWS * COLS * sizeof(unsigned char));
        pl.set_command(TLM_WRITE_COMMAND);
        pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
        cout << endl;
        cout << "CPU: Image sent to memory at: " << sc_time_stamp() << endl;
        wait(10, SC_NS); //this imitates the time the transaction needs to be sent to memory.
        cpu_ic_isoc -> b_transport(pl, offset);

        wait(15, SC_NS);

        pl.set_address(VP_ADDRESS_MEMORY_KERNEL);
        pl.set_data_ptr(reinterpret_cast<unsigned char*>(&kernel.data));
        pl.set_data_length(ROWS * COLS * sizeof(unsigned char));
        pl.set_command(TLM_WRITE_COMMAND);
        pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
        cout << "CPU: Kernel sent to memory at: " << sc_time_stamp() << endl;
        wait(10, SC_NS);
        cpu_ic_isoc -> b_transport(pl, offset);

        wait(15, SC_NS);

        pl.set_command(TLM_WRITE_COMMAND);
        pl.set_address(VP_ADDRESS_CONVOLUTION_READY);
        pl.set_data_ptr((unsigned char *)&ready);
        pl.set_response_status(TLM_INCOMPLETE_RESPONSE);
        cout << "CPU: Ready flag sent to memory at: " << sc_time_stamp() << endl;
        wait(10,SC_NS);
        cpu_ic_isoc -> b_transport(pl, offset);

        wait(15, SC_NS);

        wait(done); //wait untill IP has finished convolution.
        cout << "CPU: Convolutin is done, I can send next matrix at: " << sc_time_stamp() << endl;
        cout << endl;
        ++counter_of_covolued_images;
        if(counter_of_covolued_images > 100000)
        {
            cout << "Number of convolued images: " << counter_of_covolued_images << endl;
        }
        wait(100, SC_NS); //wait 100ns before sending next image

    }
}
