#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define HASHPRIME          37            /* Prime number */

int main(int argc, char * argv[])
{
   int hashsiz, hashmsk, hashnbr, hashend;
   int max_number;
   int numbers[]  = {1, 37, 2, 3, 37, 12 };
   int tests[] = {37, 5};

   int size_numbers = sizeof(numbers)/sizeof(int);
   int size_tests = sizeof(tests)/sizeof(int);

   max_number = numbers[0];
   for(int i = 1; i < size_numbers; i ++)
        max_number = (numbers[i] > max_number ) ? numbers[i] : max_number;



   // compute hastable size 
   for (hashsiz = 32, hashnbr = max_number; hashsiz < hashnbr; hashsiz <<= 1) ;
   hashmsk = hashsiz - 1;
   printf("%d %d %d %d\n", max_number, (int)pow(2,((int)ceil(log2(1.*max_number)))), hashsiz, hashmsk);

   // allocating
   int * hashtab = (int *) malloc(hashsiz * sizeof(int));
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
         if (val == r)
           printf("%d it -> %d is yet inserted \n", i, r);
         else
           printf("collision : %d cannot be in %d, %d is there \n", r, hashend, hashtab[hashend] );
         break;
       }
       else  {
          hashtab[hashend] = r;
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
