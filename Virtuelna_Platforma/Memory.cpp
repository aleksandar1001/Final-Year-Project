#include "Memory.hpp"

using namespace std;
using namespace sc_core;
using namespace tlm;
using namespace sc_dt;

Memory::Memory(sc_module_name name) :
    sc_module(name),
    mem_conv_tsoc("mem_conv_tsoc"),
    mem_cpu_tsoc("mem_cpu_tsoc"),
    filename("output.txt")
{
    mem_conv_tsoc.register_b_transport(this, &Memory::b_transport);
    mem_cpu_tsoc.register_b_transport(this, &Memory::b_transport);
    SC_REPORT_INFO("MEMORY", "Memory is constructed.");
}

void Memory::showData(unsigned char* data, int counter1, int counter2)
{
    for(int i{0}; i < counter1; ++i)
    {
        for(int j{0}; j < counter2; ++j)
        {
            cout << static_cast<int>(data[i *  counter2 + j]) << " "; //showing data as a number
        }
        cout << endl;
    }
}

void Memory::b_transport(pl_t& pl, sc_time& delay)
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
                case MEMORY_IMAGE:
                    data = pl.get_data_ptr();
                    showData(data, ROWS, COLS);
                    for(int i{0}; i < ROWS; ++i)
                    {
                        for(int j{0}; j < COLS; ++j)
                        {
                            image(i, j) = data[i * COLS + j];
                        }
                    }
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "MEMORY: Image recieved at: " << sc_time_stamp() << endl;
                    break;
                case MEMORY_KERNEL:
                    data = pl.get_data_ptr();
                    showData(data, 3, 3);
                    for(int i{0}; i < 3; ++i)
                    {
                        for(int j{0}; j < 3; ++j)
                        {
                            kernel(i, j) = data[i * 3 + j];
                        }
                    }
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "MEMORY: Kernel recieved at: " << sc_time_stamp() << endl;
                    break;
                case MEMORY_IMAGE_CONV:
                {
                    data = pl.get_data_ptr();
                    int i1 = ROWS - 3 + 1;
                    int i2 = COLS - 3 + 1;
                    showData(data, i1, i2);
                    for(int i{0}; i < i1; ++i)
                    {
                        for(int j{0}; j < i2; ++j)
                        {
                            image_conv(i, j) = data[i * i2 + j];
                        }
                    }
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "MEMORY: Convolued image revieved at: " << sc_time_stamp() << endl;
                    writeMatrixTofile(image_conv, filename);
                    break;
                }
                default:
                    pl.set_response_status(TLM_ADDRESS_ERROR_RESPONSE);
                    SC_REPORT_ERROR("MEMORY", "Invalid address");
                    break;
            }
        }
            break;

        case TLM_READ_COMMAND:
        {
            switch(addr)
            {
                case MEMORY_IMAGE:
                    data = pl.get_data_ptr(); //it's possible it can work without this line
                    for(int i{0}; i < ROWS; ++i)
                    {
                        for(int j{0}; j < COLS; ++j)
                        {
                            data[i * COLS + j] = image(i, j);
                        }
                    }
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "MEMORY: Image read from memory at: " << sc_time_stamp() << endl;
                    break;
                case MEMORY_KERNEL:
                       data = pl.get_data_ptr();
                    for(int i{0}; i < 3; ++i)
                    {
                        for(int j{0}; j < 3; ++j)
                        {
                            data[i * 3 + j] = kernel(i, j);
                        }
                    }
                    pl.set_response_status(TLM_OK_RESPONSE);
                    cout << "MEMORY: Kernel read from memory at: " << sc_time_stamp() << endl;
                    break;
            }
        }
        break;

        default:
            pl.set_response_status(TLM_COMMAND_ERROR_RESPONSE);
            SC_REPORT_INFO("MEMORY", "TLM invalid command");
            break;
    }
}


    void Memory::writeMatrixTofile(Matrix_Conv matrix, string filename)
    {
        ofstream file(filename);
        if(file.is_open())
        {
            for(int i{0}; i < (ROWS - 3 + 1); ++i)
            {
                for(int j{0}; j < (COLS - 3 + 1); ++j)
                {
                    file << static_cast<int>(matrix(i, j)) << " ";
                }
                file << endl;
            }
            file.close();
            cout << "Matrix successfully written to file" << endl;
        }
        else
        {
            cerr << "Unable to open file" << filename << endl;
        }
    }
