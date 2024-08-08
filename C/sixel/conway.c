#include "gray_image.h" 
#include <math.h> 
#include <stdlib.h>
#include <string.h>

#define TILE_SIZE 20
#define N 20
#define M (TILE_SIZE*N)
#define NB_REPEATS 200


void draw_damier(const char * state, char * buff, int m, int n, int tile_size)
{
  int i, j, k, l;
  memset(buff, 0, m * n * tile_size * tile_size *sizeof(char));
  for(i = 0; i < m; i++) {
    for (j = 0; j < n ; j++) {
      if (state[i * n + j] != 0) {
        for(k = 0;  k < tile_size; k++)
          for (l = 0; l < tile_size; l++)
            buff[ j * tile_size + l + (i * tile_size + k) * tile_size * n] = 255;
      }
    }
  }
}


int main() {
  int i,j,k,l;
  gray_image * img = gray_image_create();
  char buff[M*M];
  char state[N*N];
  for(l = 0; l < NB_REPEATS; l++) {
      for(i = 0 ; i < N; ++i) 
        for(j = 0; j < N; ++j) 
          state[i * N + j] = (drand48() < 0.5) ? 255 : 0;
      draw_damier(state, buff, N, N, TILE_SIZE);
      render(img, buff, N*TILE_SIZE, N*TILE_SIZE);
  }
  gray_image_destroy(img);
  return 0;
}
