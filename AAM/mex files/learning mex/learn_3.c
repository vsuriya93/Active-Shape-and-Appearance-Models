#include "mex.h"
/* 
* the gateway function
* takes input
*/
 void copyArray(double *a,double *result,int m,int n)
{
int i,j;
for(i=0;i<m;i++)
  for(j=0;j<n;j++)
    result[j*m+i]=a[j*m +i]; 
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
double *  transposeArray(double *a,int m,int n)
{
  int i,j;
  mxArray  *x=mxCreateDoubleMatrix(m,n,mxREAL);
  double *b=mxGetPr(x);
  for(i=0;i<m;i++)
  {
    for(j=0;j<n;j++)
    {
      b[j*m+i]=a[i*n+j];
    }
   /* printf("\n");*/
  }
  return b;
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
double *a=mxGetPr(prhs[0]);
int m=mxGetM(prhs[0]);
int n=mxGetN(prhs[0]);
mxArray *rhs,*lhs;
rhs=mxCreateDoubleMatrix(m,n,mxREAL);
double *c=mxGetPr(rhs);
copyArray(a,c,m,n);
mexCallMATLAB(1,&lhs,1,&rhs,"max");
double *res=mxGetPr(lhs);
int m_res=mxGetM(lhs);
int n_res=mxGetN(lhs);
displayArray(res,m_res,n_res);
}