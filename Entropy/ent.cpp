/*Small program to quickly get entropy of image
 * call using ent(data, bins)
 *  Data    input image, must be of type uint8
 *  bins    number of bins to use (Note must be greater then the largest 
 *          value in A and B)
 */ 

#include "mex.h"
#include "matrix.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    //check inputs
    if (nrhs != 2 || (nlhs != 1 && nlhs != 0)) {
      mexErrMsgIdAndTxt("MI:BadNArgs", 
                        "Need 2 inputs and 1 output.");
    }
    if (!mxIsUint8(prhs[0])) {
      mexErrMsgIdAndTxt("MI:BadTypeInput", 
                        "1st input must be an UINT8 matrix.");
    }
        
    //gets size of variables
    const int* sizeD = mxGetDimensions(prhs[0]);
    size_t sizeY = sizeD[0];
    size_t sizeX = sizeD[1];
    size_t sizeXY = sizeX*sizeY;
    
    //get value of input variables
    uint8_T *Data = (uint8_T *) mxGetData(prhs[0]);
    double *binsIn = mxGetPr(prhs[1]);
    
    //setup outputs
    plhs[0] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    double *ent = mxGetPr(plhs[0]);
    
    //local variables
    int bins = ((int)(binsIn[0]));
    double *h = new double[bins];

    int x, y;
    int i;
       
    //setup histogram
    for(i = 0; i < bins; i++){
        h[i] = 0;
    }
    
    //get histogram
    for(x = 0; x < sizeX; x++){
        for(y = 0; y < sizeY; y++){
            if((y + x*sizeY) < bins){
                h[Data[y + x*sizeY]]++;
            }
        }
    }
       
    //normalize histogram
    for(i = 0; i < bins; i++){
        h[i] = ((double)(h[i])) / sizeXY;
    }
          
    //calculate entropy
    ent[0] = 0;  
    for(i = 0; i < bins; i++){
        
        if(h[i] != 0){
            ent[0] -= h[i]*log(h[i])/log(2.0);
        }
    }
            
    delete h;
}