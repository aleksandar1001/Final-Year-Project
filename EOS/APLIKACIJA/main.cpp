#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cmath>

#define BRAM_SIZE_KERN 9
#define BRAM_SIZE_INPUT 144
#define BRAM_SIZE_OUTPUT 16 


int bram_INPUT[BRAM_SIZE_INPUT];

#define MAX_SIZE_LOOKUP 720



int main(int argc, char *argv[])
{
   

    std::ifstream infile;
    std::ofstream outfile;
    FILE * brams  ;
    FILE * ip ;
    FILE * bramres ;
    int rows = 12;
    int cols = 12;
    int r = 0;
    int image[144];
    for(int l = 0; l<rows*cols; l++){
    image[l]= l;
    }
    int bram_KERN1[BRAM_SIZE_KERN] = {0,0,0,0,1,0,0,0,0};
    int bram_KERN2[BRAM_SIZE_KERN] = {0,0,1,0,0,0,0,0,0};
    int bram_KERN3[BRAM_SIZE_KERN] = {0,0,0,0,0,0,0,1,0};
    int bram_KERN4[BRAM_SIZE_KERN] = {0,1,1,0,0,0,0,0,0};
    int bram_OUTPUT[BRAM_SIZE_OUTPUT];
    
    int choice;

    do
    {
        std::cout << "Main Menu\n";
        std::cout << "Please make your selection\n";
        std::cout << "1 - Write image and kernel data to brams\n";
        std::cout << "2 - Write parameters and start ip\n";
	std::cout << "3 - Read results from output bram\n";

        std::cout << "4 - Exit\n";
        std::cout << "Selection: ";
        std::cin >> choice;

        switch (choice)
	  {
	  
	  case 1:
	   
	    for (int i = 0; i < BRAM_SIZE_KERN; i++)
	      {
		brams = fopen("/dev/KERN1", "w");
		fprintf(brams  , "(%d,%d)\n", i, bram_KERN1[i]);
		fclose(brams);
	      }
	    for (int j = 0; j < BRAM_SIZE_KERN; j++)
	      {
		brams = fopen("/dev/KERN2", "w");
		fprintf(brams  , "(%d,%d)\n", j, bram_KERN2[j]);
		fclose(brams);
	      }
		for (int k = 0; k < BRAM_SIZE_KERN;k++)
	      {
		brams= fopen("/dev/KERN3", "w");
		fprintf(brams  , "(%d,%d)\n", k, bram_KERN3[k]);
		fclose(brams);
	      }
	      for (int q = 0; q < BRAM_SIZE_KERN; q++)
	      {
		brams= fopen("/dev/KERN4", "w");
		fprintf(brams  , "(%d,%d)\n", q, bram_KERN4[q]);
		fclose(brams);
	      }
	       for (int w  = 0; w < rows*cols; w++)
	      {
		brams= fopen("/dev/INPUT_PICTURE", "w");
		fprintf(brams  , "(%d,%d)\n", w, image[w]);
		fclose(brams);
	      }
		//std::cout <<bram_r_unrotated[i] << " " << bram_g_unrotated[i] << " " << bram_b_unrotated[i]  << std::endl;
		
	  
          
	  break;
        
	  
	case 2:
	  ip = fopen("/dev/CONV_ip", "w");
	  fprintf (ip,  "%d,%d,%d", 1 , rows , cols);
	  fclose(ip);
	  break;

	case 3:
	  bramres = fopen("/dev/OUTPUT_PICTURE", "r");
	  for (int b = 0; b < BRAM_SIZE_OUTPUT; b++)
	      {
		
		
		fscanf(bramres, "%d\n", &r);
		bram_OUTPUT[b] = r;
		std:: cout << bram_OUTPUT[b]<<std::endl;
		
		
	      }
	  break;
	  
	  
	case 4 :
	  std::cout << "Goodbye!" << std::endl;
	  return 0;
	  break;
	      default:
		
		std::cout << "Main Menu\n";
		std::cout << "Please make your selection\n";
		std::cout << "1 - Write image and kernel data to brams\n";
		std::cout << "2 - Write parameters and start ip\n";
		std::cout << "3 - Read results from output bram\n";
        
		std::cout << "4 - Exit\n";
		std::cout << "Selection: ";
		std::cin >> choice;
        }
    } while (choice != 8);
    
    return 0;
}
