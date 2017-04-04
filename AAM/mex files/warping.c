#include "mex.h"
#include "image_interpolation.c"
#include<stdlib.h>
#include<string.h>
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
int **CreateDynamicArray(int t_row,int t_col)
{
  int **array;
  int j;
 array=(int **)malloc(t_row * sizeof(int *));
 for(j=0;j<t_row;j++)
 {
    array[j]=(int *)malloc(t_col * sizeof(int) );
 }
 return array;
}
void getTriangleVerticesFromIndex(double *points,int points_x,int points_y, int triangleVertices[3][2],int *index)
{
  int i;
  for (i=0;i<3;i++)
  {
    triangleVertices[i][0]=points[index[i]];
    triangleVertices[i][1]=points[index[i]+points_x];
  }
}
double  computeBarycentricCoefficients(int triangleVertices[3][2],double *coordinates,int x,int y)
{
  double x1,y1,x2,y2,x3,y3;
  double alpha,beta,gamma,denominator,temp;
  x1=triangleVertices[0][0];
  y1=triangleVertices[0][1];
  x2=triangleVertices[1][0];
  y2=triangleVertices[1][1];
  x3=triangleVertices[2][0];
  y3=triangleVertices[2][1];
  denominator= (-x2*y3) +  (x2*y1) + (x1*y3) + (x3*y2) - (x3*y1) - (x1*y2);
  temp=(y*x3) - (x1*y) - (x3*y1) - (y3*x) +(x1*y3) + (x*y1);
  beta=temp/denominator;
  temp=(x*y2) - (x*y1) - (x1*y2) - (x2*y) + (x2*y1) + (x1*y);
  gamma=temp/denominator;
  alpha=1-(beta+gamma);
  coordinates[0]=alpha;
  coordinates[1]=beta;
  coordinates[2]=gamma;
  return *coordinates;
}
int checkValidCoordinates(double *coordinates)
{
   int i,result;
   for (i=0;i<3;i++)
   {
      if(coordinates[i]>=(0-.000001) && coordinates[i]<=(1+.000001))
      {
	result=1;
      }
      else
      {
	result=0;
	break;
      }
   }
   return result;
}
void getIndexFromConnectivityList(double *connectivityList,int *index ,int triangleNumber)
{
  int i,pos,factor=0;
  for(i=0;i<3;i++)
 {
   pos=triangleNumber+i+factor;
   index[i]=(int)connectivityList[pos]-1; /* indexing in C is from 0 and not from 1*/
   factor=factor+111;   /* 111 number of triangles are there */
 }
 
}
void cartesianToBarycentric(double *coordinates,double *points,int points_x,int points_y,double *connectivityList,int connectivityList_x,int triangleNumber,int pixel_x,int pixel_y)
{
 int i,j,t_row=3,t_col=2;
 int index[3],triangleVertices[3][2];
 int pos,result;
 /*triangleVertices=CreateDynamicArray(t_row,t_col);*/
 getIndexFromConnectivityList(connectivityList,index,triangleNumber);
  getTriangleVerticesFromIndex(points,points_x,points_y,triangleVertices,index);
  *coordinates=computeBarycentricCoefficients(triangleVertices,coordinates,pixel_x,pixel_y); 
}
void getTrainingTriangleVerticesFromIndex(int triangleVertices[3][2],int *index,double *x,double *y)
{ 
  int i;
  for(i=0;i<3;i++)
  {
    triangleVertices[i][0]=(int)x[index[i]];
    triangleVertices[i][1]=(int)y[index[i]];
  }
  
}
void barycentricToCartesian(double BarycentricCoordinates[3],int triangleVertices[3][2],double cartesian[2])
{
  int i,j;
  double val;
  for(j=0;j<2;j++)
  {
    val=0;
    for(i=0;i<3;i++)
    {
      val=val+BarycentricCoordinates[i]*triangleVertices[i][j];
    }
    cartesian[j]=val;
  }
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
double *Image=mxGetPr(prhs[0]);
int Image_m=mxGetM(prhs[0]);
int Image_n=mxGetN(prhs[0]);
double *points=mxGetPr(prhs[1]);
int points_x=mxGetM(prhs[1]);
int points_y=mxGetN(prhs[1]);
double *connectivityList=mxGetPr(prhs[2]);
int connectivityList_x=mxGetM(prhs[2]);
int no_of_triangles=mxGetM(prhs[2]);
double *training_x_cood=mxGetPr(prhs[3]);
double *training_y_cood=mxGetPr(prhs[4]);
int training_size=mxGetM(prhs[3]);
int Texture_m=Image_m;
int Texture_n=Image_n;
mxArray *Texture=mxCreateDoubleMatrix(Texture_m,Texture_n,mxREAL);
double *texture=mxGetPr(Texture);
double BarycentricCoordinates[3];
int index[3],triangleVertices[3][2];
int i,j,k,is_valid_coordinate,count=0;
mxArray *CartesianCoordinates=mxCreateDoubleMatrix(1,2,mxREAL);
const char *type_of_interpolation="cubic";
mxArray *interpolation=mxCreateString(type_of_interpolation);
mxArray *PixelIntensity;
double cartesian[2];
Image=transposeArray(Image,Image_m,Image_n);
mxArray *rhs[4];
rhs[0]=mxCreateDoubleMatrix(Texture_m,Texture_n,mxREAL);
double *input_to_interp2_function=mxGetPr(rhs[0]);
copyArray(Image,input_to_interp2_function,Image_m,Image_n);
rhs[3]=interpolation;
int TextureSize=Texture_m*Texture_n;
mxArray *x_cood=mxCreateDoubleMatrix(1,TextureSize,mxREAL);
mxArray *y_cood=mxCreateDoubleMatrix(1,TextureSize,mxREAL);
double *x_ptr=mxGetPr(x_cood);
double *y_ptr=mxGetPr(y_cood);
double *pixelFill;
mxArray *indexForRemovingInterpolationError=mxCreateDoubleMatrix(Texture_m,Texture_n,mxREAL);
double *ptr=mxGetPr(indexForRemovingInterpolationError);
int numberOfPointsMapped=0;
for (i=0;i<Texture_m;i++)
{
  for(j=0;j<Texture_n;j++)
  {
    for(k=0;k<no_of_triangles;k++)
    {
      cartesianToBarycentric(BarycentricCoordinates,points,points_x,points_y,connectivityList,connectivityList_x,k,i+1,j+1);
      is_valid_coordinate=checkValidCoordinates(BarycentricCoordinates);
      if(is_valid_coordinate==1)
      {
	numberOfPointsMapped++;
	getIndexFromConnectivityList(connectivityList,index,k);
	getTrainingTriangleVerticesFromIndex(triangleVertices,index,training_x_cood,training_y_cood);
	barycentricToCartesian(BarycentricCoordinates,triangleVertices,cartesian);
       /*texture[i*Texture_n+j]=interpolate_2d_cubic_gray(cartesian[0],cartesian[1],&Image_m,Image);
       printf("%f \n",texture[i*Texture_m+j]);*/
        x_ptr[count]=cartesian[0];
       y_ptr[count]=cartesian[1];
       /*mexCallMATLAB(1,&PixelIntensity,4,rhs,"interpfast");
       pixelFill=mxGetPr(PixelIntensity);       
       texture[j*Texture_n+i]=*pixelFill;*/
       ptr[j*Texture_m+i]=1;
       break;
      }
    }  
    count++;
  }
}
rhs[1]=x_cood;
rhs[2]=y_cood;
mexCallMATLAB(1,&PixelIntensity,4,rhs,"interpfast");
pixelFill=mxGetPr(PixelIntensity);
for(i=0;i<Texture_m;i++)
  for(j=0;j<Texture_n;j++)
  {
    if(ptr[j*Texture_m+i]!=1)
    {
      texture[j*Texture_m+i]=0;
      continue;
    }
   texture[j*Texture_m+i]=pixelFill[i*Texture_m+j];
  }
 /*texture=transposeArray(texture,Texture_m,Texture_n);*/
plhs[0]= Texture;
plhs[1]=indexForRemovingInterpolationError;
printf("\nNumber of pts:  %d",numberOfPointsMapped);
}