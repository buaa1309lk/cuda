#include<iostream>
#include<cuda_runtime.h>
#define datasize 10242048
int data[datasize];

void creatNum(int* data,int size){
	int i;
	for(i=0;i<size;i++)
		data[i]=rand()%10;
}


__global__ static void sumOfSquare(int *num,int *result,clock_t *time){
	int sum=0;
	int i;
	clock_t start=clock();
	for(i=0;i<datasize;i++)
		sum+=num[i]*num[i];
	*result=sum;
	*time=clock()-start;
}


int main()
{
	using namespace std;

	creatNum(data,datasize);
	int *gpudata,*result;
	clock_t *time;
	cudaMalloc((void**)&gpudata,sizeof(int)*datasize);
	cudaMalloc((void**)&result,sizeof(int));
	cudaMalloc((void**)&time,sizeof(clock_t));
	cudaMemcpy(gpudata,data,sizeof(int)*datasize,cudaMemcpyHostToDevice);
	sumOfSquare<<<1,1,0>>>(gpudata,result,time);

	int sum;
	clock_t time_used;
	cudaMemcpy(&sum,result,sizeof(int),cudaMemcpyDeviceToHost);
	cudaMemcpy(&time_used,time,sizeof(clock_t),cudaMemcpyDeviceToHost);
	cudaFree(gpudata);
	cudaFree(result);
	cudaFree(time);
	cout<<"sum is:"<<sum<<"and time used is: "<<time_used<<endl;

	sum=0;
	clock_t cputime=clock();
	int i;
	for(i=0;i<datasize;i++)
		sum+=data[i]*data[i];
	time2=clock()-cputime;
	cout<<"cpu sum is:"<<sum<<"and time used is:"<<cputime<<endl;

	return 0;
}

