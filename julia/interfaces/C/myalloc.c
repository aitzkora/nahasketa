#include <inttypes.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define ALLOC_MAX 4
double *table[ALLOC_MAX];
int64_t compteur = 0;

int64_t my_alloc(int64_t size) {
    double * p;
    if (compteur <  ALLOC_MAX )
    {
        p = (double*) (calloc(size, sizeof(double)));
        if (p)
        {
            table[compteur] = p;
            return compteur++;
        }
        else
            return -1; // bad calloc
    }
    else
      return -2; // allocation table is full
}
void my_free(int64_t num)
{
     if (table[num]) { free(table[num]); table[num] = NULL; }
}

int64_t set_values(int64_t size, int64_t num, double * val)
{
    if (table[num])
        memcpy((void*)(table[num]), (void*)(val), sizeof(double)*size);
    else
        return -1;
}

int64_t get_values(int64_t size, int64_t num, double * val)
{
    if (table[num])
        memcpy((void*)(val), (void*)(table[num]), sizeof(double)*size);
    else
        return -1;
}
