#include "gray_image.h"
#include <stdio.h>
#include <stdlib.h>


static int sixel_write(char *data, int size, void *priv) {
      return fwrite(data, 1, size, (FILE *)priv);
}

gray_image * gray_image_create() {
  gray_image * img = malloc(sizeof(gray_image));
  sixel_output_new(&img->output, sixel_write, stdout, NULL);
  img->dither = sixel_dither_get(SIXEL_BUILTIN_G8);
  sixel_dither_set_pixelformat(img->dither, SIXEL_PIXELFORMAT_G8);
  return img;
}


void gray_image_destroy(gray_image * img) {
   sixel_dither_unref(img->dither);
   sixel_output_unref(img->output);
}

void render(gray_image * img, char * buff, int m, int n) {
 fprintf(stdout,"\033[1;1H");
 sixel_encode(buff, m, n, 0, img->dither, img->output);
 fprintf(stdout,"\0x1B\0x5C\0338");
}

