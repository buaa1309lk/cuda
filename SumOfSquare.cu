#include<iostream>
#include<cuda_runtime.h>
#define datasize 10242048
int data[datasize];

void creatNum(int* data,int size){
	int i;
	for(i=0;i<size;i++)
		data[i]=rand()%10;
}


__global__ static void sumOfSquare(int *num,int *result){
	int sum=0;
	int i;
	for(i=0;i<datasize;i++)
		sum+=num[i]*num[i];
	*result=sum;
}


int main()
{
	using namespace std;

	creatNum(data,datasize);
	int *gpudata,*result;

	cudaMalloc((void**)&gpudata,sizeof(int)*datasize);
	cudaMalloc((void**)&result,sizeof(int));
	cudaMemcpy(gpudata,data,sizeof(int)*datasize,cudaMemcpyHostToDevice);
	sumOfSquare<<<1,1,0>>>(gpudata,result);

	int sum;
	cudaMemcpy(&sum,result,sizeof(int),cudaMemcpyDeviceToHost);
	cudaFree(gpudata);
	cudaFree(result);
	cout<<sum<<endl;

	sum=0;
	int i;
	for(i=0;i<datasize;i++)
		sum+=data[i]*data[i];
	cout<<sum<<endl;

	return 0;
}

