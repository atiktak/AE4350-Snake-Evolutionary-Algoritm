class Population {
  
  final int Ninput = 2;
  final int Nhidden = 3;
  final int Noutput = 4;
  
  int popSize;
  
  Snake[] allSnakes;
  
  Population(int size) {
    popSize = size;
    allSnakes = new Snake[popSize];
    if (!initialize) {
      for (int i=0; i<popSize; i++) {
        float[][] weights1 = randomWeight(Nhidden, Ninput);
        float[][] weights2 = randomWeight(Noutput, Nhidden);
        float[] bias = randomBias(Nhidden);
        allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
      }
    } else {
      float[][] weights1 = load2DFile("weights1.dat", Nhidden, Ninput);
      float[][] weights2 = load2DFile("weights2.dat", Noutput, Nhidden);
      float[] bias = load1DFile("bias.dat");
      for (int i=0; i<popSize; i++) {
        allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
      }
    }
  }
  
  void update() {
    for (int i=0; i<allSnakes.length; i++) {
      if (!allSnakes[i].dead) {
        allSnakes[i].look();
        allSnakes[i].decide();
        allSnakes[i].move();
      }
    }
  }
  
  void show() {
    for (int i=0; i<allSnakes.length; i++) {
      if (!allSnakes[i].dead) {
        allSnakes[i].show();
      }
    }
  }
  
  void mutate(int[][] best, float f) {
    float[][] bestWeights1 = allSnakes[best[1][0]].weights1;
    float[][] bestWeights2 = allSnakes[best[1][0]].weights2;
    float[] bestBias = allSnakes[best[1][0]].bias;
    
    // Write Genotype to log.txt before mutating
    save2DFile(bestWeights1, "weights1.dat");
    save2DFile(bestWeights2, "weights2.dat");
    save1DFile(bestBias, "bias.dat");

    // Save best snakes from last generation
    Snake[] bestSnakes = new Snake[Nmutate];
    for (int i=0; i<Nmutate; i++) {
      bestSnakes[i] = allSnakes[best[1][i]];
    }
    
    // New population
    allSnakes = new Snake[popSize];

    // All snakes mutate from one top individual
    //for (int i=0; i<popSize; i++) {
    //  if (i==0) {
    //    float[][] weights1 = bestSnakes[i].weights1;
    //    float[][] weights2 = bestSnakes[i].weights2;
    //    float[] bias = bestSnakes[i].bias;
    //    allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
    //  } else {
    //  float[][] factor1 = randomFactor2D(Nhidden, Ninput, f);
    //  float[][] factor2 = randomFactor2D(Noutput, Nhidden, f);
    //  float[] factor3 = randomFactor1D(Nhidden, f);
    //  //float[][] weights1 = MAddelem(factor1, bestWeights1);
    //  //float[][] weights2 = MAddelem(factor2, bestWeights2);
    //  float[][] weights1 = MAddelem2D(factor1, bestWeights1);
    //  float[][] weights2 = MAddelem2D(factor2, bestWeights2);
    //  float[] bias = MAddelem1D(factor3, bestBias);
    //  allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
    //  }
    //}
    
    // Best selection of last generation stay and the others result from mutated combinations
    for (int i=0; i<popSize; i++) {
      if (i<Nmutate) {
        float[][] weights1 = bestSnakes[i].weights1;
        float[][] weights2 = bestSnakes[i].weights2;
        float[] bias = bestSnakes[i].bias;
        allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
      } else {
        int n1 = round(random(Nmutate-1));
        int n2 = round(random(Nmutate-1));
        float[][] weights1 = bestSnakes[n1].weights1;
        float[][] weights2 = bestSnakes[n2].weights2;
        float[] bias = bestSnakes[n1].bias;
        
        float[][] factor1 = randomFactor2D(Nhidden, Ninput, f);
        float[][] factor2 = randomFactor2D(Noutput, Nhidden, f);
        float[] factor3 = randomFactor1D(Nhidden, f);
        
        //weights1 = MMelem2D(factor1, weights1);
        //weights2 = MMelem2D(factor2, weights2);
        //bias = MMelem1D(factor3, bias);
        
        weights1 = MAddelem2D(factor1, weights1);
        weights2 = MAddelem2D(factor2, weights2);
        bias = MAddelem1D(factor3, bias);
        
        allSnakes[i] = new Snake(Ninput, Nhidden, Noutput, weights1, weights2, bias);
      }
    }
    
  }
  
  int[][] getBest() {
    int[][] best = new int[2][Nmutate];
    
    for (int i=0; i<allSnakes.length; i++) {
      if (allSnakes[i].lvl > best[0][Nmutate-1]) {
        best[0][Nmutate-1] = allSnakes[i].lvl;
        best[1][Nmutate-1] = i;
        best = sort2D(best);
      }
    }
    
    return best;
  }
  
  boolean allDead() {
    for (int i=0; i<allSnakes.length; i++) {
      if (!allSnakes[i].dead) {
        return false;
      }
    }
    return true;
  }
  
  float[][] randomWeight(int n1, int n2) {
    float [][] weights = new float[n1][n2];
    for (int i=0; i<n1; i++) {
      for (int j=0; j<n2; j++) {
        weights[i][j] = random(-1,1);
      }
    }
    return weights;
  }  
    
  float[] randomBias(int n) {
    float [] bias = new float[n];
    for (int i=0; i<n; i++) {
      bias[i] = random(-1,1);
    }
    return bias;
  }
  
  float[][] randomFactor2D(int n1, int n2, float f) {
    float[][] factor = new float[n1][n2];
    for (int i=0; i<n1; i++) {
      for (int j=0; j<n2; j++) {
        float rand = random(1);
        if (rand<f) {
          factor[i][j] = randomGaussian()/5;
        } else {
          factor[i][j] = 0;
        }
      }
    }
    return factor;
  }
  
  float[] randomFactor1D(int n1, float f) {
    float[] factor = new float[n1];
    for (int i=0; i<n1; i++) {
        float rand = random(1);
        if (rand<f) {
          factor[i] = randomGaussian()*mutation_amp;
        } else {
          factor[i] = 0;
        }
    }
    return factor;
  }
  
  int[][] sort2D(int[][] arr) { // Sorts 2D array by first row
    int[] ref = reverse(sort(arr[0]));
    int[][] sorted = new int[arr.length][arr[0].length];
    
    for (int i=0; i<arr[0].length; i++) {
      for (int j=0; j<arr[0].length; j++) {
        if (arr[0][j]==ref[i]) {
          sorted[0][i] = arr[0][j];
          sorted[1][i] = arr[1][j];
          break;
        }
      }
    }
    return sorted;
  }
  
  float[][] MMelem2D(float[][] M1, float[][] M2) {
    int r = M1.length;
    int c = M1[0].length;
    float multi[][] = new float[r][c];
      
    for(int i=0;i<r;i++){        
      for(int j=0;j<c;j++) {      
        multi[i][j] = M1[i][j]*M2[i][j];      
      }
    }
    return multi;
  }
  
  float[] MMelem1D(float[] M1, float[] M2) {
    int l = M1.length;
    float multi[] = new float[l];
      
    for(int i=0;i<l;i++){          
        multi[i] = M1[i]*M2[i];      
    }
    return multi;
  }
  
  float[][] MAddelem2D(float[][] M1, float[][] M2) {
    int r = M1.length;
    int c = M1[0].length;
    float multi[][] = new float[r][c];
      
    for(int i=0;i<r;i++){        
      for(int j=0;j<c;j++) {      
        multi[i][j] = M1[i][j]+M2[i][j];
        if (multi[i][j]>1) {
          multi[i][j] = 1;
        } else if (multi[i][j]<-1) {
          multi[i][j] = -1;
        }
      }
    }
    return multi;
  }
  
  float[] MAddelem1D(float[] M1, float[] M2) {
    int l = M1.length;
    float multi[] = new float[l];
      
    for(int i=0;i<l;i++){          
        multi[i] = M1[i]+M2[i];
        if (multi[i]>1) {
          multi[i] = 1;
        } else if (multi[i]<-1) {
          multi[i] = -1;
        }
    }
    return multi;
  }
  
  float[][] Mavg2D(float[][] M1, float[][] M2) {
    int r = M1.length;
    int c = M1[0].length;
    float avg[][] = new float[r][c];
    
    for(int i=0;i<r;i++){        
      for(int j=0;j<c;j++) {      
        avg[i][j] = (M1[i][j]+M2[i][j])/2;      
      }
    }
    return avg;
  }
  
  float[] Mavg1D(float[] M1, float[] M2) {
    int l = M1.length;
    float avg[] = new float[l];
      
    for(int i=0;i<l;i++){        
        avg[i] = (M1[i]+M2[i])/2;      
    }
    return avg;
  }
  
  void save2DFile(float[][] arr, String name) {
    String[] lines = new String[arr.length];
    
    for (int i=0; i<arr.length; i++) {
      lines[i] = "";
      for (int j=0; j<arr[0].length; j++) {
        if (j==arr[0].length-1) {
          lines[i] += arr[i][j];
        } else {
          lines[i] += arr[i][j] + ",";
        }
      }
    }
    saveStrings(name, lines);
  }
  
  float[][] load2DFile(String name, int r, int c){
    String[] lines = loadStrings(name);
    float[][] arr = new float[r][c];
    
    for (int i=0; i<lines.length; i++) {
      String[] temp = split(lines[i], ',');
      for (int j=0; j<temp.length; j++) {
        arr[i][j] = float(temp[j]);
      }
    }
    return arr;
  }
  
  float[] load1DFile(String name){
    String[] lines = loadStrings(name);
    float[] arr = new float[0];
    
    String[] temp = split(lines[0], ',');
    for (int j=0; j<temp.length; j++) {
      arr = append(arr, float(temp[j]));
    }
    return arr;
  }
  
}
