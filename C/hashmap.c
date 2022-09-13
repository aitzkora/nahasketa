#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define HASHPRIME          37            /* Prime number */

typedef struct link_node_ {
  int val;
  struct link_node_ * next;
} link_node;

typedef struct hash_map_ {
  int key;
  link_node *list;
} hash_map;

void print_keys(hash_map *hashtab, const int hashsiz)
{
  printf("[");
  for(hash_map * hasptr = hashtab; hasptr != hashtab + hashsiz; hasptr ++)
    if (hasptr->key != ~0) printf("%d ", hasptr->key);
  printf("]\n");
}

void free_hash_map(hash_map *hashtab, const int hashsiz)
{
  for(hash_map * hasptr  = hashtab; hasptr != hashtab + hashsiz; hasptr ++) {
    if (hasptr->key != ~0) {
      for(link_node * lnkptr = hasptr->list; lnkptr!= NULL ;) {
         link_node * next = lnkptr->next;
         free(lnkptr);
         lnkptr = next;
      }
    }
  }
  free(hashtab);
}

int resize_hash(hash_map ** hashtab, int * hashsiz, int * hashmsk)
{
   int newsiz, newmsk;
   hash_map *newtab;
   hash_map * hasoptr;
   int hashnum;
   newsiz = *hashsiz * 2;
   printf("resizing the hashtable to %d\n", newsiz);
   print_keys(*hashtab, *hashsiz);
   newmsk = newsiz - 1;
   newtab = (hash_map *) malloc(sizeof(hash_map) * newsiz);

   for(int i = 0; i < newsiz ; i ++) {
     newtab[i].key = ~0;
     newtab[i].list = NULL;
   } 

   for(hasoptr = *hashtab; hasoptr != *hashtab + *hashsiz; hasoptr ++ ) {
     hash_map * hasnptr;
     if (hasoptr->key == ~0)
       continue;
     for (hashnum = (hasoptr->key * HASHPRIME) & newmsk, hasnptr = newtab + hashnum; /* init : new hash compute*/ 
         hasnptr->key != ~0; /* stopping condition : new slot is not empty */
         hashnum = (hashnum + 1) & newmsk, hasnptr = newtab + hashnum) {
       if (hasnptr->key == hasoptr->key) { /* Item should not already be present */
         printf("hash table resize error: duplicate hash slot");
         return (1);
       }
     }
     hasnptr->key = hasoptr->key;
     hasnptr->list = hasoptr->list;
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
   hash_map * hashtab; 


   int test_keys[]  = {1, 37, 2, 3, 37, 12 , 124, 32, 18, 12, 5 };
   int test_vals[]  = {2, 38, 3, 4, 39, 13 , 125, 33, 19, 14, 6 };
   
   int query_keys[] = {37, 5, 29};
     
   int size_test = sizeof(test_keys)/sizeof(int);
   int size_query = sizeof(query_keys)/sizeof(int);

   // whe choose deliberately hashsiz two small to force resize;
   hashsiz = 4; 
   hashmsk = hashsiz - 1;
   hashfill = 0;


   // allocating
   hashtab = (hash_map *) malloc(hashsiz * sizeof(hash_map));
   for(int i = 0; i < hashsiz ; i ++) {
     hashtab[i].key = ~0;
     hashtab[i].list = NULL;
   }

   for(int i = 0; i < size_test ; i ++)
   {
     int r = test_keys[i];
     
     // compute hash_key
     int hashnum = r * HASHPRIME & hashmsk;

     // insert
     for(hashend = hashnum; ; hashend = (hashend + 1) & hashmsk) {
       int val = hashtab[hashend].key;
       if (val != ~0) {
         if (val == r) {
           link_node * new_node = (link_node *) malloc(sizeof(link_node));
           new_node->val = test_vals[i];
           new_node->next = hashtab[hashend].list;
           hashtab[hashend].list = new_node;
           printf("%d it -> %d is yet inserted \n", i, r);
           break;
         }
         else
           printf("collision : %d cannot be in position %d, because %d is there \n", r, hashend, hashtab[hashend].key );
       }
       else  {
          hashtab[hashend].key = r;
          link_node * new_node = (link_node *) malloc(sizeof(*new_node));
          new_node->val = test_vals[i];
          new_node->next = NULL;
          hashtab[hashend].list = new_node;
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
   for(int i = 0; i < size_query; i ++)
   {
     int to_seek = query_keys[i];
     printf("looking for %d in hashtable -> ", to_seek);
     for(hashend =  to_seek * HASHPRIME & hashmsk;; hashend = (hashend + 1) & hashmsk) {
       if (hashtab[hashend].key == ~0) {
          printf("not found !\n", hashend);
          break;
       } 
       if (hashtab[hashend].key == to_seek) {
          printf("found %d pos :  ", hashend);
          for(link_node * lnkptr = hashtab[hashend].list;
              lnkptr != NULL;
              lnkptr = lnkptr->next)
            printf("%d ", lnkptr->val);
          printf("\n");
          break; 
       }
     }
   }

   free_hash_map(hashtab, hashsiz);
   return 0;
}
