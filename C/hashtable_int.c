#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define HASHPRIME          37            /* Prime number */

void print_keys(int *hashtab, int hashsiz)
{
  printf("[");
  for(int * hasptr  = hashtab; hasptr != hashtab + hashsiz; hasptr ++)
    if (*hasptr != ~0) printf("%d ", *hasptr);
  printf("]\n");
}
int resize_hash(int ** hashtab, int * hashsiz, int * hashmsk)
{
   int newsiz, newmsk;
   int *newtab;
   int * hasoptr;
   int hashnum;
   newsiz = *hashsiz * 2;
   printf("resizing the hashtable to %d\n", newsiz);
   print_keys(*hashtab, *hashsiz);
   newmsk = newsiz - 1;
   newtab = (int *) malloc(sizeof(int) * newsiz);
   memset((void*) newtab, ~0, sizeof(int) * newsiz);
    
   for(hasoptr = *hashtab; hasoptr != *hashtab + *hashsiz; hasoptr ++ ) {
     int * hasnptr;
     if (*hasoptr == ~0)
       continue;
     for (hashnum = (*hasoptr * HASHPRIME) & newmsk, hasnptr = newtab + hashnum; /* init : new hash compute*/ 
         *hasnptr != ~0; /* stopping condition : new slot is not empty */
         hashnum = (hashnum + 1) & newmsk, hasnptr = newtab + hashnum) {
       if (*hasnptr == *hasoptr) { /* Item should not already be present */
         printf("hash table resize error: duplicate hash slot");
         return (1);
       }
     }
     *hasnptr = *hasoptr;
   }


   free(*hashtab);
   *hashtab = newtab;
   *hashsiz = newsiz;
   *hashmsk = newmsk;
   return 0;
}




int main(int argc, char * argv[])
{
   int hashsiz; // number of buckets (we need a power a two! )
   int hashmsk; /* binary mask used to compute integer hash */
   int hashnbr, hashend;
   int hashfill; /* counting the number of occupied buckets */
   int * hashtab; 


   int numbers[]  = {1, 37, 2, 3, 37, 12 , 124, 32, 18, 12, 5 };
   int tests[] = {37, 5, 29};
     
   int size_numbers = sizeof(numbers)/sizeof(int);
   int size_tests = sizeof(tests)/sizeof(int);

   // whe choose deliberately hashsiz two small to force resize;
   hashsiz = 4; 
   hashmsk = hashsiz - 1;
   hashfill = 0;


   // allocating
   hashtab = (int *) malloc(hashsiz * sizeof(int));
   memset (hashtab, ~0, hashsiz * sizeof (int)); /* Initialize hash table */


   for(int i = 0; i < sizeof(numbers)/sizeof(int) ; i ++)
   {
     int r = numbers[i];
     
     // compute hash_key
     int hashnum = r * HASHPRIME & hashmsk;

     // insert
     for(hashend = hashnum; ; hashend = (hashend + 1) & hashmsk) {
       int val = hashtab[hashend];
       if (val != ~0) {
         if (val == r) {
           printf("%d it -> %d is yet inserted \n", i, r);
           break;
         }
         else
           printf("collision : %d cannot be in position %d, because %d is there \n", r, hashend, hashtab[hashend] );
       }
       else  {
          hashtab[hashend] = r;
          hashfill++;
          if (hashfill > (int)(0.75 * hashsiz)) {
            if (resize_hash(&hashtab, &hashsiz, &hashmsk) !=0)
              exit(-1);
          }
          break;
       }
     }
   }
   
   // seek for value
   for(int i = 0; i < size_tests; i ++)
   {
     int to_seek = tests[i];
     printf("looking for %d in hashtable -> ", to_seek);
     for(hashend =  to_seek * HASHPRIME & hashmsk;; hashend = (hashend + 1) & hashmsk) {
       if (hashtab[hashend] == ~0) {
          printf("not found !\n", hashend);
          break;
       } 
       if (hashtab[hashend] == to_seek) {
          printf("found %d pos \n", hashend);
          break; 
       }
     }
   }

   free(hashtab);
   return 0;
}
