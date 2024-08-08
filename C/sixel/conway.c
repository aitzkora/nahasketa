#include "gray_image.h" 
#include <math.h> 
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define TILE_SIZE 10
#define N 40
#define M (TILE_SIZE*N)
#define NB_REPEATS 300000


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


void one_step_life(const char * state1, char * state2, int m, int n) {
  int i,j;
  memset(state2, 0, m * n * sizeof(char));
  for(i = 1; i < (m- 1); i++) {
    for (j = 1; j <(n-1) ; j++) {
      char accu = 0;
      accu += state1[(i-1)*n+(j-1)];
      accu += state1[(i  )*n+(j-1)];
      accu += state1[(i+1)*n+(j-1)];
      accu += state1[(i-1)*n+(j  )];
      accu += state1[(i+1)*n+(j  )];
      accu += state1[(i-1)*n+(j+1)];
      accu += state1[(i  )*n+(j+1)];
      accu += state1[(i+1)*n+(j+1)];
      if (accu < 2 ||  accu > 3) 
        state2[i * n + j ] = 0;
      else if (accu == 3) 
        state2[i * n + j ] = 1;
      else 
        state2[i * n + j ] = state1[i * n + j];
    }
  }
}


int main() {
  int i,j,k,l;
  gray_image * img = gray_image_create();
  char buff[M*M];
  char * state1 = malloc(N * N * sizeof(char));
  char * state2 = malloc(N * N * sizeof(char));
  char * tmp;

  for(i = 1 ; i < (N-1); ++i) 
    for(j = 1; j < (N-1); ++j) 
      state1[i * N + j] = (drand48() < 0.5) ? 1 : 0;
 
  for(l = 0; l < NB_REPEATS; l++) {
      one_step_life(state1, state2, N, N);
      draw_damier(state2, buff, N, N, TILE_SIZE);
      render(img, buff, N*TILE_SIZE, N*TILE_SIZE);
      tmp = state1;
      state1 = state2;
      state2 = tmp;
  }
  free(state1);
  free(state2);
  gray_image_destroy(img);
  return 0;
}
