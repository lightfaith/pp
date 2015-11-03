#include "mpi.h"
#include <stdio.h>


void send(int src, int dst)
{
	MPI_Request r;
	char message [13];
	snprintf(message, 12, "Msg from %d", src);
	message[12]=0;
	MPI_Isend(message, 12, MPI_CHAR, dst, 0, MPI_COMM_WORLD, &r);
	printf("Message \"%s\" has been sent to %d\n\n", message, dst);
	MPI_Cancel(&r);
}

void receive(int rank, int count)
{
	char message[13];
	MPI_Recv(message, 12, MPI_CHAR, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	message[12]=0;
	printf("%d Here!\n", rank);
	printf("Message: `%s`\n", message);
}

int main(int argc, char *argv[])
{
	int  numtasks, rank, len, rc; 

	rc = MPI_Init(&argc,&argv);
	if (rc != MPI_SUCCESS)
	{
		printf ("Error starting MPI program. Terminating.\n");
		MPI_Abort(MPI_COMM_WORLD, rc);
	}

	MPI_Comm_size(MPI_COMM_WORLD,&numtasks);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);

	if(rank==0)
	{
		printf("I am root! Sending first message...\n");
		send(0, 1);
		receive(rank, numtasks);
		printf("\n\nThat's all folks!\n");
	}
	else //not parent
	{
		receive(rank, numtasks);
		send(rank, (rank+1)%numtasks);
	}

	MPI_Finalize();
}
