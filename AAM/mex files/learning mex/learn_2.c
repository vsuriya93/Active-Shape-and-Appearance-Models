#include "mex.h"
/* 
* the gateway function
* takes input
*/
 void copyArray(double *a,double *res,int m,int n)
{
int i,j;
for(i=0;i<m;i++)
  for(j=0;j<n;j++)
    res[j*m+i]=a[j*m +i]; 
}
void displayArray(double *a,int m,int n)
{
  int i,j;
for(i=0;i<m;i++)
{
 for(j=0;j<n;j++)
 { 
  printf("%f ",a[j*m+i]); 
 }
printf("\n");
}
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
double *a=mxGetPr(prhs[0]);
int m=mxGetM(prhs[0]);
int n=mxGetM(prhs[0]);
mxArray *x;
x=mxCreateDoubleMatrix(m,n,mxREAL);
double *b=mxGetPr(x);
plhs[0]=x;
double *c=mxGetPr(plhs[0]);
copyArray(a,b,m,n);
displayArray(c,m,n);
}