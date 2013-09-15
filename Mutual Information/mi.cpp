/*Small program to quickly get mi
 * call using mi(A, B, normal, bins)
 *  A       input image, must be of type uint8
 *  B       second input image, must be of uint8 and same size as A
 *  normal  0 for standrad mi, 1 for NMI
 *  bins    number of bins to use (Note must be greater then the largest 
 *          value in A and B, there is no error checking)
 */ 

#include "mex.h"
#include "matrix.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    //check inputs
    if (nrhs != 4 || (nlhs != 1 && nlhs != 0)) {
      mexErrMsgIdAndTxt("MI:BadNArgs", 
                        "Need 4 inputs and 1 output.");
    }
    if (!mxIsUint8(prhs[0])) {
      mexErrMsgIdAndTxt("MI:BadTypeInput", 
                        "1st input must be an UINT8 matrix.");
    }
    if (!mxIsUint8(prhs[1])) {
      mexErrMsgIdAndTxt("MI:BadTypeInput", 
                        "2nd input must be an UINT8 matrix.");
    }
        
    //gets size of variables
    const int* sizeD = mxGetDimensions(prhs[0]);
    size_t sizeY = sizeD[0];
    size_t sizeX = sizeD[1];
    size_t sizeXY = sizeX*sizeY;
    
    sizeD = mxGetDimensions(prhs[1]);

    //check size
    if ((sizeY != sizeD[0]) || (sizeX != sizeD[1])) {
      mexErrMsgIdAndTxt("MI:BadTypeInput", 
                        "Images must be of the same size.");
    }
    
    //get value of input variables
    uint8_T *A = (uint8_T *) mxGetData(prhs[0]);
    uint8_T *B = (uint8_T *) mxGetData(prhs[1]);
    double *normal = mxGetPr(prhs[2]);
    double *binsIn = mxGetPr(prhs[3]);
    
    //setup outputs
    plhs[0] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    double *mi = mxGetPr(plhs[0]);
    
    //local variables
    int bins = ((int)(binsIn[0]));
    int *h = new int[bins*bins];
    double *hDoub = new double[bins*bins];
    double *hA = new double[bins];
    double *hB = new double[bins];

    int x, y;
    int i, j;
            
    double entB, entA, entAB;
       
    //setup histograms
    for(i = 0; i < bins; i++){
        hB[i] = 0;
        hA[i] = 0;
        
        for(j = 0; j < bins; j++){
            h[i + j*bins] = 0;
        }
    }
    
    //get joint histogram
    for(x = 0; x < sizeX; x++){
        for(y = 0; y < sizeY; y++){            
            h[B[y + x*sizeY] + bins*A[y + x*sizeY]]++;
        }
    }
       
    //normalize and move to double histogram
    for(i = 0; i < bins; i++){
        for(j = 0; j < bins; j++){
            hDoub[i + bins*j] = ((double)(h[i + bins*j])) / sizeXY;
        }
    }
    
    //Get individual histograms
    for(i = 0; i < bins; i++){
        for(j = 0; j < bins; j++){
            hA[i] += hDoub[j + i*bins];
            hB[i] += hDoub[i + j*bins];
        }
    }
          
    //calculate entropy
    entAB = 0; entB = 0; entA = 0;  
    for(i = 0; i < bins; i++){
        
        if(hA[i] != 0){
            entA -= hA[i]*log(hA[i])/log(2.0);
        }
        if(hB[i] != 0){
            entB -= hB[i]*log(hB[i])/log(2.0);
        }
        
        for(j = 0; j < bins; j++){
            if(hDoub[i + bins*j] != 0){
                entAB -= hDoub[i + bins*j]*log(hDoub[i + bins*j])/log(2.0);
            }
        }
    }
    
    //calculate mi
    if(normal[0]){
        mi[0] = (entB + entA)/entAB;
    }
    else{
        mi[0] = entB + entA - entAB;
    }
            
    delete h; delete hDoub; delete hA; delete hB;
}