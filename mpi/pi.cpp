#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[])
{
	if(argc<2)
	{
		printf("Usage: %s <intervals>\n", argv[0]);
		exit(1);
	}
	int numtasks, rank, rc, ierr;
	unsigned int intervals = atoi(argv[1]);
	long int start; //start of interval
	long int  end; //end of interval
	long int r;
	double x; // x for formula
	double intervalsize; 
	double rectik; //size of one little rectangle
	double thread_sum; //sum of rectangles for one thread
	double total_sum; //total sum of all rectangles
	double pi; //final pi (total_sum * intervalsize)
	double time2, time1;
	char realpi[] = {"3.14159265358979323846"};
	char computedpi[23];
	
	rc = MPI_Init(&argc,&argv);
	if (rc != MPI_SUCCESS)
	{
		printf ("Error starting MPI program. Terminating.\n");
		MPI_Abort(MPI_COMM_WORLD, rc);
	}

	MPI_Comm_size(MPI_COMM_WORLD,&numtasks);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	
	intervals = intervals/numtasks*numtasks;
	if(rank==0)
	{
		printf("%d processes will participate in PI computing on %d intervals...\n", numtasks, intervals);
	}
	
	time1 = MPI_Wtime();
	start = (intervals/numtasks)*rank+1;
	end = (intervals/numtasks)*(rank+1);
	thread_sum=0.0;
	total_sum=0.0;
	intervalsize = 1.0/(double)intervals;
	for(int i=end; i>=start; i--)
	{
		x = intervalsize*((double)(i-0.5));
		rectik = 4.0/ (1.0+x*x);
		thread_sum=thread_sum+rectik;
	}
	ierr=MPI_Reduce(&thread_sum, &total_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
	time2 = MPI_Wtime();
	pi=intervalsize*total_sum;
	
	if(rank==0)
	{
		snprintf(computedpi, 23, "%.24f", pi);
		computedpi[22]=0;
		int bugloc=1;
		for(int i=0; i<23; i++)
			if(realpi[i]==computedpi[i])
				bugloc++;
			else
				break;
		printf("PI computed in %fs:\n%.24f\n", time2-time1, pi);
		if(bugloc<23)
			for(int i=1; i<bugloc; i++)
				printf(" ");
		printf("^\n");
	}
	MPI_Finalize();
}
