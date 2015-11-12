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
	
	// Threading
	//for each element

	MPI_Request request;
	MPI_Status status;
	int rank;
	int total;
	MPI_Comm_size(MPI_COMM_WORLD,&total);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	
	if(rank==0) //parent
	{
		printf("height: %d, width: %d, common: %d\n", height, width, common);
		//send rows to elements in first column
		for(int rowiter=0; rowiter<height+common-1; rowiter++)
		{
			//printf("\n\nIteration %d\n", rowiter);
			for(int row=0; row<height; row++)
			{
				if(rowiter<row+common && rowiter>=row)
				{	//printf("printing element %d of row %d\n", rowiter-row, row);
					//printf("D2: common-(rowiter-row)-1=%d, rowiter=%d, row=%d\n", common-(rowiter-row)-1,rowiter,row);
					int tosend = a[common-(rowiter-row)-1][row];
					printf("Root-sending to %d (left)\n", (row*width)+1);
					MPI_Isend(&tosend, 1, MPI_INT, (row*width)+1, rowiter-row, MPI_COMM_WORLD, &request);
				}
			}
		}
		//send columns to elements in first row
		printf("----------\n");
		for(int coliter=0; coliter<width+common-1; coliter++)
		{
			//printf("\n\nIteration %d\n", coliter);
			for(int col=0; col<width; col++)
			{
				if(coliter<col+common && coliter>=col)
				{
					//printf("printing element %d of col %d\n", coliter-col, col);
					int tosend=b[col][common-(coliter-col)-1];
					printf("Root-sending to %d (top)\n", col+1);
					MPI_Isend(&tosend, 1, MPI_INT, col+1, common+coliter-col, MPI_COMM_WORLD, &request);
				}
			}
		}
		printf("----------\n");
		//wait for responses
		for(int i=0; i<total-1; i++)
		{
			int value;
			MPI_Recv(&value, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
			int r = status.MPI_SOURCE;
			int x = (r-1)%width;
			int y = (r-1)/width;
			//printf("rank=%d, value=%d; x=%d, y=%d\n", r, value, x, y);
			result[x][y]=value;
		}	
	}
	else //child
	{
		int message;
		int sum=0;
		int *leftdata = (int*)malloc(common*sizeof(int));
		int *topdata = (int*)malloc(common*sizeof(int));
		bool isleft=false;
		for(int i=0; i<2*common; i++)
		{
			int x = (rank-1)%width;
			int y = (rank-1)/width;
			//save received data from left
			//save received data from top
			MPI_Recv(&message, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
			//send them further
			if(status.MPI_TAG<common) //is left
			{
				leftdata[status.MPI_TAG]=message;
				if(x+1<width)
				{
					MPI_Isend(&message, 1, MPI_INT, rank+1, status.MPI_TAG, MPI_COMM_WORLD, &request);
					printf("Process %d sending data to %d (left) (tag %d)\n", rank, rank+1, status.MPI_TAG);
				}
			}
			else //is top
			{
				topdata[status.MPI_TAG-common]=message;
				if(y+1<height)
				{
					MPI_Isend(&message, 1, MPI_INT, rank+width, status.MPI_TAG, MPI_COMM_WORLD, &request);
					printf("Process %d sending data to %d (top)(tag %d)\n", rank, rank+width, status.MPI_TAG);	
				}
			}

		}
		for(int i=0; i<common; i++)
		{
			//compute value
			sum+=leftdata[i]*topdata[i];

		}
		//send value to parent
		printf("Process with rank %d returning result: %d\n", rank, sum);
		MPI_Isend(&sum, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &request);
	}
	/*
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
	*/
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

