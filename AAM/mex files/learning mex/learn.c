   
  /*printf("%d %d",nhls,nrhs);*/
  double *a=mxGetPr(prhs[0]);
  double *b;
  int m=mxGetM(prhs[0]);
  int n=mxGetN(prhs[0]);
  plhs[0]=mxCreateDoubleMatrix(m*n,1,mxREAL);
   b=mxGetPr(plhs[0]);
  /*printf("%f %d %d\n",*a,m,n);*/
  int i,j;
  mxArray *lhs[1],*rhs[1];
  rhs[0] = mxCreateDoubleMatrix(max, 1, mxREAL);
    /* pass the pointers and let fill() fill up data */
    mxSetM(rhs[0], m);
    mxSetN(rhs[0], n);
  mexCallMATLAB(1,lhs,1,a,'max');
  printf("%f ",lhs);
  return ;
  for (i=0;i<m;i++)
  {
    for(j=0;j<n;j++)
    {
      b[j*m+i]=a[j*m+i]+1;
    }
  }
    displayArray(b,m,n);