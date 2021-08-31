class NeuralNetwork {
  
  int n_input, n_hidden, n_output;
  float[][] weights1, weights2;
  float[] bias;
  
  NeuralNetwork(int Ninput, int Nhidden, int Noutput, float[][] NNweights1, float[][] NNweights2, float[] NNbias) {
    n_input = Ninput;
    n_hidden = Nhidden;
    n_output = Noutput;
    weights1 = NNweights1;
    weights2 = NNweights2;
    bias = NNbias;
  }
  
  float[] outputs(float[] inputs) {
    float[] hidden = new float[n_hidden];
    float[] outputs = new float[n_output];
    hidden = MMult(inputs, weights1);
    outputs = MMult(hidden, weights2);
    return outputs;
  }
  
  float dotProd(float[] ar1, float[] ar2) {
    float sum = 0;
    for (int i=0; i<ar1.length; i++) {
      sum += ar1[i] * ar2[i];
    }
    return sum;
  }
  
  float[] MMult(float[] M1, float[][] M2) {
    int n1 = M1.length;
    int n2 = M2.length;
    float multi[] = new float[n2];
      
    for(int i=0;i<n2;i++){    
      multi[i]=0;      
      for(int j=0;j<n1;j++) {      
        multi[i]+=M1[j]*M2[i][j];      
      }  
    }
    return multi;
  }
}
