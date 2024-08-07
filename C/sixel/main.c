#include "gray_image.h"
#include <math.h>

#define M 400
#define NB_REPEATS 2

#define SQR(x) ((x)*(x))
#define MIN(A,B) ((A)<(B)?(A):(B))

int main() {
  int i,j,k,l;
  gray_image * img = gray_image_create();
  char buff[M*M];
  for(l = 0; l < NB_REPEATS; l++) {
    for(k = 0; k < floor(M/sqrt(2.)); k++) {
      for(i = 0; i < M; i++) {
        for(j= 0; j < M; j++) {
            buff[i*M+j] = MIN(255, floor(sqrt(1.*(SQR(i-M/2)+SQR(j-M/2)))/k*2));
        }
      }
      render(img, buff, M, M);
    }
  }
  gray_image_destroy(img);
  return 0;
}
