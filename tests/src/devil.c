#include "tests.h"
#include "IL/il.h"

void load_image(const char* filename)
{
    ILenum err_num;
    ilInit();
    if(!ilLoadImage(filename)) {
        fprintf(stderr,"Can't load image %s\n",filename);
    }
    // while((err_num = ilGetError()) != IL_NO_ERROR)
    //     fprintf(stderr,"Image Library error: %s\n",err_num);
    printf("OK\n");
}
