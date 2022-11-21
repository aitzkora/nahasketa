#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "parmetis.h"                    

static 
int * read_file(const char  * filename, int * nb_int ) 
{
  *nb_int  = 0;
  int ch, i;
  int * buffer;
  FILE *fp = fopen(filename, "r");
  do {
   ch = fgetc(fp);
   if(ch == '\n') (*nb_int)++;   
  } while( ch != EOF );    
  fclose(fp);
  buffer = (int *) malloc(sizeof(int) * (*nb_int));
  fp = fopen(filename, "r");
  for(i = 0; i < (*nb_int); ++i) 
     fscanf(fp, "%d", buffer + i);
  fclose(fp);
  return buffer;
}



int
main (
int                 argc,
char *              argv[])
{
  MPI_Comm            proccomm;
  int                 proclocnum;                 /* Number of this process                 */
       
  idx_t          vertnum;
  idx_t          edgenum;
  idx_t *        xadj;
  idx_t *        adjncy;
  idx_t          ncommon = 2;
  idx_t          baseval = 0;
  idx_t          xadnbr;
  idx_t          adjnbr;


  idx_t *        eptr;
  idx_t *        eind;  
  idx_t *        xadj_c;
  idx_t *        adjncy_c;

  
  
  idx_t          *elmdist;

  idx_t          nb_int;


//  int                 thrdlvlreqval;
//  int                 thrdlvlproval;
// 
//  thrdlvlreqval = MPI_THREAD_MULTIPLE;
//  if (MPI_Init_thread (&argc, &argv, thrdlvlreqval, &thrdlvlproval) != MPI_SUCCESS)
//    SCOTCH_errorPrint ("main: Cannot initialize (1)");
//  if (thrdlvlreqval > thrdlvlproval)
//    SCOTCH_errorPrint ("main: MPI implementation is not thread-safe: recompile without SCOTCH_PTHREAD");
  if (MPI_Init (&argc, &argv) != MPI_SUCCESS) {
    printf("main: Cannot initialize (2)");
    exit(-1);
  }
 

  proccomm = MPI_COMM_WORLD;
  MPI_Comm_rank (proccomm, &proclocnum);

  if (proclocnum == 0) { 
    eptr = read_file ( "eptr.0", &nb_int );printf("|eptr| = %d\n", nb_int ); 
    eind = read_file ( "eind.0", &nb_int );printf("|eind| = %d\n", nb_int );
    elmdist = read_file ( "elmdist.0", &nb_int);printf("|elm| = %d\n", nb_int );
  }
  else if (proclocnum == 1) {
    eptr = read_file ( "eptr.1", &nb_int );printf("|eptr| = %d\n", nb_int ); 
    eind = read_file ( "eind.1", &nb_int );printf("|eind| = %d\n", nb_int );
    elmdist = read_file ( "elmdist.0", &nb_int );printf("|elm| = %d\n", nb_int );
  }
  else if (proclocnum == 2){
    eptr = read_file ( "eptr.2", &nb_int );printf("|eptr| = %d\n", nb_int ); 
    eind = read_file ( "eind.2", &nb_int );printf("|eind| = %d\n", nb_int ); 
    elmdist = read_file ( "elmdist.0", &nb_int);printf("|elm| = %d\n", nb_int ); 
  }

  ParMETIS_V3_Mesh2Dual (elmdist, eptr, eind, &baseval, &ncommon, &xadj, &adjncy, &proccomm);
  
  MPI_Finalize ();
  exit (EXIT_SUCCESS);
}
