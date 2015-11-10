//optimalni nasobeni matic

//case study: matrix multiplication - systolic algorithm
//bonus: in Kaira, MPI

#include<mpi.h>
#include<stdio.h>
#include<stdlib.h>

int** generatematrix(int w, int h)
{
	int **result = (int**)malloc(w*sizeof(int*));
	for(int i=0; i<w; i++)
	{
		result[i]=(int*)malloc(h*sizeof(int));
		for(int j=0; j<h; j++)
			result[i][j]=i+j;
	}
	return result;
}

int **multiply(int** a, int** b, int common, int width, int height)
{
	int **result = (int**)malloc(width*sizeof(int*));
	for(int i=0; i<width; i++)
		result[i]=(int*)malloc(height*sizeof(int));
	
	// No thread part
	/*
	for(int i=0; i<width; i++)
	{
		for(int j=0; j<height; j++)
		{
			//for each element
			int rank=i*height+j;
			int x = rank%width;
			int y = rank/width;
			printf("rank=%d, x=%d, y=%d\n", rank, x, y);
			result[x][y]=0;
			for(int k=0; k<common; k++)
			{
				result[x][y]+=a[k][y]*b[x][k];
			}
		}
	}
	*/

	// Threading
	//for each element

	int rank;
	int total;
	MPI_Comm_size(MPI_COMM_WORLD,&total);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);

	if(rank==0) //parent, complete result matrix
	{
		printf("Work delegated. Waiting for responses...\n");
		//wait for message from every child
		for(int i=0; i<total-1; i++)
		{
			char message[20];
			MPI_Recv(message, 20, MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			message[19]=0;
			//printf(">%s: ", message);
			int r;
			int val;
			sscanf(message, "%d %d", &r, &val);
			int x = (r-1)%width;
			int y = (r-1)/width;
			//printf("rank=%d, value=%d; x=%d, y=%d\n", r, val, x, y);
			result[x][y]=val;
		}
		printf("Work complete.\n");
	}
	else //child, count one cell
	{
		int cell=0;
		int x = (rank-1)%width;
		int y = (rank-1)/width;

		//printf("rank=%d, x=%d, y=%d\n", rank, x, y);
		for(int k=0; k<common; k++)
		{
			cell+=a[k][y]*b[x][k];
		}
		char message[20];
		snprintf(message, 19, "%d %d", rank, cell);
		message[19]=0;
		//printf("%s\n", message);
		MPI_Request r;
		MPI_Isend(message, 20, MPI_CHAR, 0, 0, MPI_COMM_WORLD, &r);
	}
	return result;
}

void printmatrix(int** a, int w, int h)
{
	for(int i=0; i<h; i++)
	{
		for(int j=0; j<w; j++)
			printf("%3d ", a[j][i]);
		printf("\n");
	}
	printf("\n");
}

int main(int argc, char** argv)
{
	if(argc!=4)
	{
		printf("Usage: %s <h1> <w2> <h2>\n", argv[0]);
		return(1);
	}
	int rc = MPI_Init(&argc,&argv);
    if (rc != MPI_SUCCESS)
    {   
        printf ("Error starting MPI program. Terminating.\n");
        MPI_Abort(MPI_COMM_WORLD, rc);
    }

	int w1;
	int h1=atoi(argv[1]);
	int w2=atoi(argv[2]);
	int h2 = w1 = atoi(argv[3]);
	
	int** A = generatematrix(w1, h1);
	int** B = generatematrix(w2, h2);
	
	int** C=multiply(A, B, w1, w2, h1);
	
	int rank;
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(rank==0)
	{
		//printf("c done\n");
		if(w1*h1<10000)
			printmatrix(A, w1, h1);
		if(w2*h2<10000)
			printmatrix(B, w2, h2);
		if(w2*h1<10000)
			printmatrix(C, w2, h1);
	}
	MPI_Finalize();
	return 0;
}

