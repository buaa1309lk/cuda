#include<iostream>
#include<cuda_runtime.h>
using namespace std;
bool InitCUDA()
{
	int count;
	cudaGetDeviceCount(&count);
	if(count==0)
	{
		cout<<"there is no device"<<endl;
		return 0;
	}

	int i;	
	for(i=0;i<count;i++)
	{
		cudaDeviceProp prop;
		if(cudaGetDeviceProperties(&prop,i)==cudaSuccess)
		{
			if(prop.major>=1)
				break;
		}
	}

	if(i==count){
		cout<<"There is no device supproting CUDA 1.X"<<endl;
		return 0;
	}

	cudaSetDevice(i);
		return true;
}

int main()
{
	using namespace std;
	if(!InitCUDA())
		return 0;
	cout<<"CUDA INITIALIZED"<<endl;
	return 0;
}
