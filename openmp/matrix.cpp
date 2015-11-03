// TODO Matrix multiplication with OpenMP
#include<stdio.h>
#include<stdlib.h>
#include<omp.h>

int **generatematrix(int width, int height)
{
	int** result = (int**)malloc(height*sizeof(int*));	
	for(int i=0; i<height; i++)
	{
		result[i]=(int*)malloc(width*sizeof(int));
		for(int j=0; j<width; j++)
			result[i][j]=i+j;
	}
	return result;
}

int ** multiply(int ** a, int ** b, int common, int width, int height)
{
	int **result = (int**)malloc(height*sizeof(int*));
	for(int i=0; i<height; i++)
		result[i]=(int*)malloc(width*sizeof(int));
	
	#pragma omp parallel for
	for(int i=0; i<height; i++)
	{
		for(int j=0; j<width; j++)
		{
			int sum=0;
			for(int k=0; k<common; k++)
				sum+=a[i][k]*b[k][j];
			result[i][j]=sum;
		}
		printf("%d of %d\n", i, height);
	}
	return result;
}

void printmatrix(int** m, int w, int h)
{
	//printf("%d, %d, %d\n\n", sizeof(m), sizeof(*m), sizeof(**m));
	for(int i=0; i<h; i++)
	{
		for(int j=0; j<w; j++)
			printf("%3d ",m[i][j]);
		printf("\n");
	}
	printf("\n\n");
}

int main(int argc, char **argv)
{
	if(argc!=5)
	{
		printf("Usage: %s <h1> <w2> <h2>\n", argv[0]);
		return(1);
	}
	int w1;
	int h1=atoi(argv[1]);
	int w2=atoi(argv[2]);
	int h2 = w1 = atoi(argv[3]);
	int threadnum = atoi(argv[4]);
	//int h1 = 1000;
	//int w2 = 2000;
	//int h2 = w1 = 3000;
	omp_set_num_threads(threadnum);
	int** A = generatematrix(w1, h1);
	int** B = generatematrix(w2, h2);
	int** C=multiply(A, B, w1, w2, h1);
	if(w1*h1<10000)
		printmatrix(A, w1, h1);
	if(w2*h2<10000)
		printmatrix(B, w2, h2);
	if(w2*h1<10000)
		printmatrix(C, w2, h1);
	return 0;
}
