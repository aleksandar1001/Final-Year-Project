CC = g++ -lsystemc

pathOut = '../data/Output.txt'

.PHONY: clean run
.DEFAULT_GOAL := main_d

main_d: main.o Vp.o Convolution.o Cpu.o Memory.o Interconnect.o
	@$(CC) main.o Convolution.o Cpu.o Vp.o Memory.o Interconnect.o -o main_d  
	@echo "Making main_d executable"

main.o: main.cpp Vp.cpp Vp.hpp
	@$(CC) -c main.cpp 
	@echo "Compiling main.cpp"

Vp.o: Vp.cpp Vp.hpp Cpu.cpp Cpu.hpp Convolution.cpp Convolution.hpp adrese.hpp Memory.hpp Memory.cpp
	@$(CC) -c Vp.cpp 
	@echo "Compiling Vp.cpp"

Convolution.o: Convolution.cpp Convolution.hpp adrese.hpp
	@$(CC) -c Convolution.cpp 
	@echo "Compiling Convolution.cpp"

Cpu.o: Cpu.hpp Cpu.cpp adrese.hpp Convolution.cpp Convolution.hpp
	@$(CC) -c Cpu.cpp 
	@echo "Compiling cpu.cpp"

Memory.o: Memory.cpp Memory.hpp adrese.hpp Cpu.hpp Cpu.cpp Convolution.hpp Convolution.cpp
	@$(CC) -c Memory.cpp 
	@echo "Compiling Memory.cpp"

Interconnect.o: Interconnect.cpp Interconnect.hpp Cpu.cpp Cpu.hpp Convolution.cpp Convolution.hpp adrese.hpp Memory.hpp Memory.cpp
	@$(CC) -c Interconnect.cpp
	@echo "Compiling interconnect.cpp"

run:
	@make main_d
	@echo "Running executable target "
	@./main_d $(pathOut) 

clean:
	@rm *.o main_d
	@echo "Deleting all .o files"