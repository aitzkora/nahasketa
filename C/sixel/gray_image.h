#pragma once
#include <sixel.h>

typedef struct gray_image_t 
  {
    struct sixel_output * output;
    struct sixel_dither * dither;
  }
gray_image;
 

gray_image * gray_image_create();

void gray_image_destroy(gray_image * img);

void render(gray_image * img, char * buff, int m, int n);

