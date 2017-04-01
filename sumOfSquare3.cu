#include<iostream>
#include<cuda_runtime.h>
#define datasize 10242048
#define THREAD_NUM 256


int data[datasize];

void creatNum(int* data,int size){
	int i;
	for(i=0;i<size;i++)
		data[i]=rand()%10;
}


__global__ static void sumOfSquare(int *num,int *result,clock_t *time){
	const int tid=threadIdx.x;
	const int size=datasize/THREAD_NUM;
		
	int sum=0;
	int i;
	clock_t start;
	if(tid==0)
		start=clock();
	for(i=tid*size;i<(tid+1)*size;i++)
		sum+=num[i]*num[i];
	result[tid]=sum;

	if(tid==0)
		*time=clock()-start;
}


int main()
{
	using namespace std;

	creatNum(data,datasize);
	int *gpudata,*result;
	clock_t *time;
	cudaMalloc((void**)&gpudata,sizeof(int)*datasize);
	cudaMalloc((void**)&result,sizeof(int)*THREAD_NUM);
	cudaMalloc((void**)&time,sizeof(clock_t));
	cudaMemcpy(gpudata,data,sizeof(int)*THREAD_NUM,cudaMemcpyHostToDevice);
	sumOfSquare<<<1,THREAD_NUM,0>>>(gpudata,result,time);

	int sum[THREAD_NUM];
	clock_t time_used;
	cudaMemcpy(&sum,result,sizeof(int)*THREAD_NUM,cudaMemcpyDeviceToHost);
	cudaMemcpy(&time_used,time,sizeof(clock_t),cudaMemcpyDeviceToHost);
	cudaFree(gpudata);
	cudaFree(result);
	cudaFree(time);
	
	int final_sum=0;
	int i;
	for(i=0;i<THREAD_NUM;i++)
		final_sum+=sum[i];
	cout<<"sum is:"<<final_sum<<"and time used is: "<<time_used<<endl;

	int	sum_cpu=0;
	clock_t cputime=clock();
	for(i=0;i<datasize;i++)
		sum_cpu+=data[i]*data[i];
	cputime=clock()-cputime;
	cout<<"cpu sum is:"<<sum_cpu<<"and time used is:"<<cputime<<endl;

	return 0;
}

