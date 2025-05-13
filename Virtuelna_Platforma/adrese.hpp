#ifndef _ADRESE_HPP_
#define _ADRESE_HPP_
#include <systemc>
#include <fstream>
#include <iostream>
#include <vector>
#include <sstream>
#include <string>

#define ROWS 5
#define COLS 5

typedef std::vector<std::vector<int>> slika2D;
typedef std::vector<int> slika1D;

struct Matrix {
    unsigned char data[ROWS * COLS]; //an array that contains data of matrix

    unsigned char& operator()(int row, int col) //a method for access elements of matrix
    {
        return data[row * COLS + col];
    }
};

struct Kernel {
    unsigned char data[3 * 3];

    unsigned char& operator()(int row, int col)
    {
        return data[row * 3 + col];
    }
};

struct Matrix_Conv {
    unsigned char data[(ROWS - 3 + 1) * (COLS - 3 + 1)];

    unsigned char& operator()(int row, int col)
    {
        return data[row * (COLS - 3 + 1) + col];
    }
};

const sc_dt::uint64 VP_ADDRESS_MEMORY = 0x47C00000;
const sc_dt::uint64 MEMORY_IMAGE = 0x00000000;
const sc_dt::uint64 MEMORY_KERNEL = 0x00000001;
const sc_dt::uint64 MEMORY_IMAGE_CONV = 0x00000002;

const sc_dt::uint64 VP_ADDRESS_MEMORY_IMAGE = VP_ADDRESS_MEMORY + MEMORY_IMAGE;
const sc_dt::uint64 VP_ADDRESS_MEMORY_KERNEL = VP_ADDRESS_MEMORY + MEMORY_KERNEL;
const sc_dt::uint64 VP_ADDRESS_MEMORY_IMAGE_CONV = VP_ADDRESS_MEMORY + MEMORY_IMAGE_CONV;

//------------------------------------------------------------------------------------//
const sc_dt::uint64 VP_ADDRESS_CONVOLUTION = 0x47B00000;
const sc_dt::uint64 CONVOLUTION_READY = 0x00000000;

const sc_dt::uint64 VP_ADDRESS_CONVOLUTION_READY = VP_ADDRESS_CONVOLUTION + CONVOLUTION_READY;

#endif
