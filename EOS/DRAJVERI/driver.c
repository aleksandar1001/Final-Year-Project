
#include <linux/cdev.h>
#include <linux/kdev_t.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/string.h>
#include <linux/of.h>

#include <linux/mm.h>              //za memorijsko mapiranje
//#include <linux/io.h>              //iowrite ioread
//#include <linux/slab.h>            //kmalloc kfree
//#include <linux/platform_device.h> //platform driver
#include <linux/of.h>              //of match table
//#include <linux/ioport.h>          //ioremap

//#include <linux/semaphore.h>

MODULE_AUTHOR("TIM CONVOLUCIJA");
MODULE_DESCRIPTION("Driver for CONVOLUTION IP.");
MODULE_LICENSE("Dual BSD/GPL");

dev_t my_dev_id;

static struct class *my_class;
static struct device *my_device;
static struct cdev *my_cdev;

#define BUFF_SIZE 40
#define BRAM_SIZE_KERN 9
#define BRAM_SIZE_INPUT 144
#define BRAM_SIZE_OUTPUT 16
#define KERNEL_SIZE 3
struct semaphore ip_sem;

struct semaphore bram_KERN1_sem;
struct semaphore bram_KERN2_sem;
struct semaphore bram_KERN3_sem;
struct semaphore bram_KERN4_sem;
struct semaphore bram_INPUT_sem;
struct semaphore bram_OUTPUT_sem;


int bram_KERN1[BRAM_SIZE_KERN];
int bram_KERN2[BRAM_SIZE_KERN];
int bram_KERN3[BRAM_SIZE_KERN];
int bram_KERN4[BRAM_SIZE_KERN];
int bram_INPUT[BRAM_SIZE_INPUT];
int bram_OUTPUT[BRAM_SIZE_OUTPUT];


int cntk1 =0;
int cntk2 =0;
int cntk3 =0;
int cntk4 =0;
int cntin =0;
int cntout =0;

int endReadk1 = 0;
int endReadk2 = 0;
int endReadk3 = 0;
int endReadk4 = 0;
int endReadIn = 0;
int endReadOut = 0;



static int CONV_open(struct inode *pinode, struct file *pfile);
static int CONV_close(struct inode *pinode, struct file *pfile);
static ssize_t CONV_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset);
static ssize_t CONV_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset);

//static int __init CONV_init(void);
//static void __exit CONV_exit(void);

struct file_operations my_fops =
    {
        .owner = THIS_MODULE,
        .read = CONV_read,
        .write = CONV_write,
        .open = CONV_open,
	.release = CONV_close
	
    };


int CONV_open(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully opened file\n");
    return 0;
}

int CONV_close(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully closed file\n");
    return 0;
}


ssize_t CONV_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset)
{
  
  char buff[BUFF_SIZE];
  int minor = MINOR(pfile->f_inode->i_rdev);

  int kernval = 0;
  int kernpos = 0;
  int picpos = 0;
  int picval = 0;
  int ret = 0;
  int start = 0;
  int image_rows = 0;
  int image_cols = 0;
  
  int image_buffer1[100];
  int image_buffer2[64];
  int image_buffer3[36];
  
  
  ret = copy_from_user(buff, buf, length);
  
  if (ret)
    {
      printk("copy from user failed \n");
      return -EFAULT;
    }
  buff[length] = '\0';
  
  switch (minor)
    {
      
    case 0: // IP
        if (down_interruptible(&ip_sem))
	 {
	 
	 printk(KERN_INFO "IP semaphore: access to IP denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bram_KERN1_sem))
	 {
	 
	 printk(KERN_INFO "BRAM_KERN2: semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
         if (down_interruptible(&bram_KERN2_sem))
	 {
	 
	 printk(KERN_INFO "BRAM_KERN2: semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bram_KERN3_sem))
	 {
	 
	 printk(KERN_INFO "BRAM_KERN3 semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bram_KERN4_sem))
	 {
	 
	 printk(KERN_INFO "Bram_KERN4 semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bram_INPUT_sem))
	 {
	 
	 printk(KERN_INFO "BRAM_INPUT semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
	  if (down_interruptible(&bram_OUTPUT_sem))
	 {
	 
	 printk(KERN_INFO "BRAM_OUTPUT  semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
        sscanf(buff, "%d,%d,%d\n", &start , &image_rows , &image_cols  );
        printk(KERN_WARNING "%d,%d,%d\n", start , image_rows , image_cols );
      if (ret != -EINVAL)
        {
	  if (start == 0)
            {
	      printk(KERN_WARNING "IP: start must be 1 to start \n");
            }
	  else
            {
	      for (int k = 0; k < 4; ++k) {
		for (int i = 0; i < (image_rows - KERNEL_SIZE + 1); ++i) {
		  for (int j = 0; j < (image_cols - KERNEL_SIZE  + 1); ++j) {
		    int sum = 0;
		    for (int m = 0; m < KERNEL_SIZE; ++m) {
		      for (int n = 0; n < KERNEL_SIZE; ++n) {
			// Check for valid image boundaries (avoid out-of-bounds access)
			if (i + m < image_rows && j + n < image_cols) {
			  if(k == 0){ sum += bram_INPUT[(i + m)*image_rows+(j + n)] * bram_KERN1[m*KERNEL_SIZE + n];
			    //printk(KERN_WARNING "%d\n", sum);
			  }
			  if(k == 1){ sum += image_buffer1[(i + m)*image_rows+(j + n)] * bram_KERN2[m*KERNEL_SIZE + n];
			    //printk(KERN_WARNING "%d\n", sum);
			  }
			  if(k == 2){ sum += image_buffer2[(i + m)*image_rows+(j + n)] * bram_KERN3[m*KERNEL_SIZE + n];
			    //printk(KERN_WARNING "%d\n", sum);
			  }
			  if(k == 3){ sum += image_buffer3[(i + m)*image_rows+(j + n)] * bram_KERN4[m*KERNEL_SIZE + n];
			    //printk(KERN_WARNING "%d\n", sum);
			  }
			  
			  
			
		      }

		    }
		    }
		    
		   
		  if(sum > 255) sum = 255;
		  if(sum < 0) sum = 0;
        
		    if(k == 0){   image_buffer1[i*(image_rows - KERNEL_SIZE + 1)+j] = sum;
		      printk(KERN_WARNING "%d\n", image_buffer1[i*(image_rows - KERNEL_SIZE + 1)+j]);}
		    if(k == 1){   image_buffer2[i*(image_rows - KERNEL_SIZE + 1)+j] = sum;
		      printk(KERN_WARNING "%d\n", image_buffer2[i*(image_rows - KERNEL_SIZE + 1)+j]);}
		    if(k == 2){   image_buffer3[i*(image_rows - KERNEL_SIZE + 1)+j] = sum;
		      printk(KERN_WARNING "%d\n", image_buffer3[i*(image_rows - KERNEL_SIZE + 1)+j]);}
		    if(k == 3){   bram_OUTPUT[i*(image_rows - KERNEL_SIZE + 1)+j] = sum;
		      printk(KERN_WARNING "%d\n",  bram_OUTPUT[i*(image_rows - KERNEL_SIZE + 1)+j]);


		    }
	      }
	    }
	      image_rows = image_rows - KERNEL_SIZE + 1 ;
	      image_cols = image_cols - KERNEL_SIZE + 1;
		  
	}

	}
	}
      up(&ip_sem);
      up(&bram_KERN1_sem);
      up(&bram_KERN2_sem);
      up(&bram_KERN3_sem);
      up(&bram_KERN4_sem);
      up(&bram_INPUT_sem);
      up(&bram_OUTPUT_sem);
      
      break;
      
    case 1: // KERN1
      if (down_interruptible(&bram_KERN1_sem))
        {
            printk(KERN_INFO "BRAM_KERN1 semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
      printk(KERN_WARNING "CONV_write: about to write to bram_KERN1 \n");
      sscanf(buff, "(%d,%d)", &kernpos, &kernval);
      printk(KERN_WARNING "CONV_write: bram pos: %ld, kernel value: %d\n", kernpos, kernval);
      if (kernval > 1)
        {
	  printk(KERN_WARNING "BRAM_KERN1: KERN value cannot be larger than 1 \n");
        }
      else if (kernval < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN1: KERN value cannot be negative \n");
        }
      else if (kernpos < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN1: KERN adr cannot be negative \n");
        }
      else if (kernpos > BRAM_SIZE_KERN - 1)
        {
	  printk(KERN_WARNING "BRAM_KERN1: KERN adr cannot be larger than bram size \n");
        }
      else
        {
	  
	  //pos = bramPos * 4;
	  bram_KERN1[kernpos] = kernval;
	  
        }
      up(&bram_KERN1_sem);
      break;
      
    case 2: //KERN2
      
       if (down_interruptible(&bram_KERN2_sem))
        {
            printk(KERN_INFO "BRAM_KERN1 semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
      printk(KERN_WARNING "CONV_write: about to write to bram_KERN2 \n");
      sscanf(buff, "(%d,%d)", &kernpos, &kernval);
      printk(KERN_WARNING "CONV_write: bram pos: %ld, kernel value: %d\n", kernpos, kernval);
      if (kernval > 1)
        {
	  printk(KERN_WARNING "BRAM_KERN2: KERN value cannot be larger than 1 \n");
        }
      else if (kernval < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN2: KERN value cannot be negative \n");
        }
      else if (kernpos < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN2: KERN adr cannot be negative \n");
        }
      else if (kernpos > BRAM_SIZE_KERN - 1)
        {
	  printk(KERN_WARNING "BRAM_KERN2: KERN adr cannot be larger than bram size \n");
        }
      else
        {
	  
	  //pos = bramPos * 4;
	  bram_KERN2[kernpos] = kernval;
	  
        }
      up(&bram_KERN2_sem);
      break;
    
    case 3://KERN3
       if (down_interruptible(&bram_KERN3_sem))
        {
            printk(KERN_INFO "BRAM_KERN1 semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
      printk(KERN_WARNING "CONV_write: about to write to bram_KERN3 \n");
      sscanf(buff, "(%d,%d)", &kernpos, &kernval);
      printk(KERN_WARNING "CONV_write: bram pos: %ld, kernel value: %d\n", kernpos, kernval);
      if (kernval > 1)
        {
	  printk(KERN_WARNING "BRAM_KERN3: KERN value cannot be larger than 1 \n");
        }
      else if (kernval < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN3: KERN value cannot be negative \n");
        }
      else if (kernpos < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN3: KERN adr cannot be negative \n");
        }
      else if (kernpos > BRAM_SIZE_KERN - 1)
        {
	  printk(KERN_WARNING "BRAM_KERN3: KERN adr cannot be larger than bram size \n");
        }
      else
        {
	  
	  //pos = bramPos * 4;
	  bram_KERN3[kernpos] = kernval;
	  
        }
      up(&bram_KERN3_sem);
        break;


      
    case 4://KERN4
       if (down_interruptible(&bram_KERN4_sem))
        {
            printk(KERN_INFO "BRAM_KERN4 semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
      printk(KERN_WARNING "CONV_write: about to write to bram_KERN4 \n");
      sscanf(buff, "(%d,%d)", &kernpos, &kernval);
      printk(KERN_WARNING "CONV_write: bram pos: %ld, kernel value: %d\n", kernpos, kernval);
      if (kernval > 1)
        {
	  printk(KERN_WARNING "BRAM_KERN4: KERN value cannot be larger than 1 \n");
        }
      else if (kernval < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN4: KERN value cannot be negative \n");
        }
      else if (kernpos < 0)
        {
	  printk(KERN_WARNING "BRAM_KERN4: KERN adr cannot be negative \n");
        }
      else if (kernpos > BRAM_SIZE_KERN - 1)
        {
	  printk(KERN_WARNING "BRAM_KERN4: KERN adr cannot be larger than bram size \n");
        }
      else
        {
	  
	  //pos = bramPos * 4;
	  bram_KERN4[kernpos] = kernval;
	  
        }
      up(&bram_KERN4_sem);
      break;
      
      
      
      
    case 5://INPUT
      if (down_interruptible(&bram_INPUT_sem))
        {
            printk(KERN_INFO "BRAM_INPUT semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }
      printk(KERN_WARNING "CONV_write: about to write to bram_INPUT \n");
      sscanf(buff, "(%d,%d)", &picpos, &picval);
      printk(KERN_WARNING "CONV_write: bram pos: %ld, kernel value: %d\n", picpos, picval);
      if (picval > 255)
        {
	  printk(KERN_WARNING "BRAM_OUTPUT: OUTPUT value cannot be larger than 1 \n");
        }
      else if (picval < 0)
        {
	  printk(KERN_WARNING "BRAM_OUTPUT: OUTPUT value cannot be negative \n");
        }
      else if (picpos < 0)
        {
	  printk(KERN_WARNING "BRAM_OUTPUT: OUTPUT adr cannot be negative \n");
        }
      else if (picpos > BRAM_SIZE_INPUT - 1)
        {
	  printk(KERN_WARNING "BRAM_OUTPUT: PICTURE adr cannot be larger than bram size \n");
        }
      else
        {
	  
	  //pos = bramPos * 4;
	  bram_INPUT[picpos] = picval;
	  
        }
      up(&bram_INPUT_sem);

     
      break;
      
	
	
    case 6://OUTPUT
      printk(KERN_WARNING "CONV_write: cannot write to   OUTPUT \n");
        break;


	
        default:
        printk(KERN_INFO "somethnig went wrong\n");
    }

    return length;
}

ssize_t CONV_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset)
{
  
    int ret;
    char buff[BUFF_SIZE];
    int len, value;
    int minor = MINOR(pfile->f_inode->i_rdev);
    if (endReadk1 == 1)
    {
        endReadk1 = 0;
	cntk1 = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
      if (endReadk2 == 1)
    {
        endReadk2 = 0;
	cntk2 = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
        if (endReadk3 == 1)
    {
        endReadk3 = 0;
	cntk3 = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	  if (endReadk4 == 1)
    {
        endReadk4 = 0;
	cntk4 = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	    if (endReadIn == 1)
    {
        endReadIn = 0;
	cntin =0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	      if (endReadOut == 1)
    {
        endReadOut = 0;
	cntout = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
    switch (minor)
      {
	
      case 0: // ip
       
	
        break;
    
      case 1: // KERN1
      if (down_interruptible(&bram_KERN1_sem))
        {
	printk(KERN_INFO "KERN1: semaphore: access to memory denied.\n");
	
	return -ERESTARTSYS;
	}
	
	value = bram_KERN1[cntk1];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
        
        
	if (ret)
      {
	return -EFAULT;
      }
	
	cntk1++;
	if (cntk1 == BRAM_SIZE_KERN-1)
	  {
	endReadk1 = 1;
	cntk1 = 0;
	  }
	 up(&bram_KERN1_sem);
	break;
	
      case 2: // KERN2
	if (down_interruptible(&bram_KERN2_sem))
	  {
	    printk(KERN_INFO "KERN2: semaphore: access to memory denied.\n");
	    
	    return -ERESTARTSYS;
	  }
	
	value = bram_KERN2[cntk2];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntk2++;
	if (cntk2 == BRAM_SIZE_KERN-1)
	  {
	    endReadk2 = 1;
	    cntk2 = 0;
	  }
	up(&bram_KERN2_sem);
	break;
	
      case 3://KERN3
	if (down_interruptible(&bram_KERN3_sem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }
	
	value = bram_KERN3[cntk3];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram_B_UNROTATED:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntk3++;
	if (cntk3 == BRAM_SIZE_KERN-1)
	  {
	    endReadk3 = 1;
	    cntk3 = 0;
	  }
	 up(&bram_KERN3_sem);
	break;
	
	
      case 4://KERN4
	
	if (down_interruptible(&bram_KERN4_sem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }
	
	value = bram_KERN4[cntk4];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram_R_ROTATED:%d.\n", cntr);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntk4++;
	if (cntk4 == BRAM_SIZE_KERN-1)
	  {
	    endReadk4 = 1;
	    cntk4 = 0;
	  }
	up(&bram_KERN4_sem);
	break;
	
      case 5://INPUT
	
	if (down_interruptible(&bram_INPUT_sem))
	  {
	    printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }
	
	value = bram_INPUT[cntin];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram_G_ROTATED:%d.\n", cntg);
	
	
	
	if (ret)
	  {
	   return -EFAULT;
	 }
	
       cntin++;
       if (cntin == BRAM_SIZE_INPUT-1)
	 {
	   endReadIn = 1;
	   cntin = 0;
	 }
       up(&bram_INPUT_sem);
       break;
       
      case 6://OUTPUT
	 if (down_interruptible(&bram_OUTPUT_sem))
	   {
	   printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	   
	   return -ERESTARTSYS;
	   }
	 
	 value = bram_OUTPUT[cntout];
	 len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	 ret = copy_to_user(buf, buff, len);
	 //printk(KERN_INFO "BRAM_B_ROTATED:%d.\n", cntout);
	 
	 
	 
	 if (ret)
	   {
	     return -EFAULT;
	   }
	 
	 cntout++;
	 if (cntout == BRAM_SIZE_OUTPUT)
	   {
	     endReadOut = 1;
	     cntout = 0;
	   }
	 up(&bram_OUTPUT_sem);
	 break;
      default:
	   printk(KERN_INFO "somethnig went wrong\n");
      }
	   
	   return len;
}



static int __init CONV_init(void)
{
   sema_init(&bram_KERN1_sem, 1);
   sema_init(&bram_KERN2_sem, 1);
   sema_init(&bram_KERN3_sem, 1);
   sema_init(&bram_KERN4_sem, 1);
   sema_init(&bram_INPUT_sem, 1);
   sema_init(&bram_OUTPUT_sem, 1);
   sema_init(&ip_sem, 1);

    int num_of_minors = 7;
    int ret = 0;
    ret = alloc_chrdev_region(&my_dev_id, 0, num_of_minors, "CONV_REGION");
    if (ret != 0)
    {

        printk(KERN_ERR "Failed to register char device\n");
        return ret;
    }
    printk(KERN_INFO "Char device region allocated\n");

    my_class = class_create("CONV_class");
    if (my_class == NULL)
    {
        printk(KERN_ERR "Failed to create class\n");
        goto fail_0;
    }
    printk(KERN_INFO "Class created\n");
    
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 0), NULL, "CONV_ip");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device IP\n");
        goto fail_1;
    }
    printk(KERN_INFO "created IP\n");
    
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 1), NULL, "KERN1");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device KERN1\n");
        goto fail_1;
    }
    printk(KERN_INFO "created KERN1\n");

    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 2), NULL, "KERN2");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device KERN2\n");
        goto fail_1;
    }
    printk(KERN_INFO "created KERN2\n");
    
      my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 3), NULL, "KERN3");
    if (my_device == NULL)
      {
        printk(KERN_ERR "failed to create device KERN3\n");
        goto fail_1;
    }
    printk(KERN_INFO "created KERN3\n");
    
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 4), NULL, "KERN4");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device KERN4\n");
        goto fail_1;
    }
    printk(KERN_INFO "created KERN4\n");
    
      my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 5), NULL, "INPUT_PICTURE");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device INPUT_PICTURE\n");
        goto fail_1;
    }
    printk(KERN_INFO "created INPUT_PICTURE\n");
    
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 6), NULL, "OUTPUT_PICTURE");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device OUTPUT_PICTURE\n");
        goto fail_1;
    }
    printk(KERN_INFO "OUTPUT_PICTURE\n");


    my_cdev = cdev_alloc();
    my_cdev->ops = &my_fops;
    my_cdev->owner = THIS_MODULE;
    ret = cdev_add(my_cdev, my_dev_id, 7);
    if (ret)
    {
        printk(KERN_ERR "Failde to add cdev \n");
        goto fail_2;
    }
    printk(KERN_INFO "cdev_added\n");
    printk(KERN_INFO "Hello from ROT_driver\n");

    return 0;

fail_2:
    device_destroy(my_class, my_dev_id);
fail_1:
    class_destroy(my_class);
fail_0:
    unregister_chrdev_region(my_dev_id, 1);
    return -1;
    }

static void __exit CONV_exit(void)
{
    printk(KERN_ALERT "CONV_exit: rmmod called\n");
    cdev_del(my_cdev);
    printk(KERN_ALERT "CONV_exit: cdev_del done\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 0));
    printk(KERN_INFO "CONV_exit: device destroy 0\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 1));
    printk(KERN_INFO "CONV_exit: device destroy 1\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 2));
    printk(KERN_INFO "CONV_exit: device destroy 2\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id),3));
    printk(KERN_INFO "CONV_exit: device destroy 3\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 4));
    printk(KERN_INFO "CONV_exit: device destroy 4\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 5));
    printk(KERN_INFO "CONV_exit: device destroy 5\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 6));
    printk(KERN_INFO "CONV_exit: device destroy 6\n");
    class_destroy(my_class);
    printk(KERN_INFO "CONV_exit: class destroy \n");
    unregister_chrdev_region(my_dev_id, 7);
    printk(KERN_ALERT "Goodbye from CONV_driver\n");
}
module_init(CONV_init);
module_exit(CONV_exit);


