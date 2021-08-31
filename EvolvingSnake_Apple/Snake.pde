class Snake {
  float x, y;
  
  float[] snakeX, snakeY;
  float[] apple = new float[2]; 
  float[] Dapple = new float[2];
  float[][] weights1, weights2;
  float[] bias;
  
  final int elementSize = 10;      // Body element size
  final float step = 10;           // Step size of the snake
  int directionX, directionY, direction;

  int Ninput, Nhidden, Noutput;

  int lvl = 0;
  int energy, energyMax;
  float fitness = 0;
  
  boolean dead = false;
  boolean ate, apple_check;
  
  NeuralNetwork brain;
  
  Snake(int n_input, int n_hidden, int n_output, float[][] in_weights1, float[][] in_weights2, float[] in_bias) {
    snakeX = new float[0];
    snakeY = new float[0];
    apple[0] = elementSize*round(random((width-elementSize)/elementSize));
    apple[1] = elementSize*round(random((height-elementSize)/elementSize));
    energyMax = round(width/step*stamina);
    energy = energyMax;
    x = round(width/2/elementSize)*elementSize;
    y = round(height/2/elementSize)*elementSize;
    
    // Assign NN properties
    Ninput = n_input;
    Nhidden = n_hidden;
    Noutput = n_output;
    weights1 = in_weights1;
    weights2 = in_weights2;
    bias = in_bias;
    
    brain = new NeuralNetwork(Ninput, Nhidden, Noutput, weights1, weights2, bias);
  }
  
  void move() {
    
    if (direction==0 && directionX==0) {
      directionX=-1;
      directionY=0;
    }
    else if (direction==1 && directionX==0) {
      directionX=1;
      directionY=0;
    }
    else if (direction==2 && directionY==0) {
      directionY=-1;
      directionX=0;
    }
    else if (direction==3  && directionY==0) {
      directionY=1;
      directionX=0;
    }
    
    // Snake tail
    for (int i = 0; i < lvl; i++) {  
      // Shift tail positions
      if (!ate) {
        if (i==lvl-1) {
          snakeX[i] = x;
          snakeY[i] = y;  
        } else {
          snakeX[i] = snakeX[i+1];
          snakeY[i] = snakeY[i+1];
        }
      }
    }
    
    // Snake head position
    x=x+step*directionX;
    y=y+step*directionY;
    
    // Domain borders
    if ((x>width-elementSize) || (x<0)) {   
      if (x > width/2) {
        x = 0;
      } else {
        x = width-elementSize; 
      }
    }
    if ((y>height-elementSize) || (y<0)) {   
      if (y > height/2) {
        y = 0;
      } else {
        y = height-elementSize;
      }
    }
    
    // Check whether tail is bitten
    for (int i = 0; i < lvl; i++) {  
      if (snakeX[i]==x && snakeY[i]==y) {
        dead = true;
        return;
      }
    }
      
    // Check whether apple is eaten
    if (apple[0]==x && apple[1]==y) {
       eat();
    } else {
       ate = false; 
    }
    
    // Drain energy
    energy = energy-1;
    if (energy==0) {
      dead = true;
    }
    
  }
  
  void eat() {
    lvl++;
    energy = energyMax;
    ate = true;
    snakeX = append(snakeX, x);
    snakeY = append(snakeY, y);
    
    if (lvl >= 399) {
      dead = true;
      return;
    }
    
    apple[0] = elementSize*round(random((width-elementSize)/elementSize));
    apple[1] = elementSize*round(random((height-elementSize)/elementSize));
    apple_check = false;
    
    // Respawn apple if it's on the snake
    while (!apple_check) {
      apple_check = true;
      if (apple[0]==x && apple[1]==y) { // on head
        apple[0] = elementSize*round(random((width-elementSize)/elementSize));
        apple[1] = elementSize*round(random((height-elementSize)/elementSize));
        apple_check = false;
      }
      for (int i = 0; i < lvl; i++) { // on tail
        if (snakeX[i]==apple[0] && snakeY[i]==apple[1]) {
            apple[0] = elementSize*round(random((width-elementSize)/elementSize));
            apple[1] = elementSize*round(random((height-elementSize)/elementSize));
            apple_check = false;
        }
      } 
    }
  }
  
  void look() {
    Dapple[0] = (apple[0] - x) % width;
    Dapple[1] = (apple[1] - y) % height;
  }
 
  void decide() {
    float[] inputs = Dapple;
    float[] outputs = brain.outputs(inputs);
    float outMax = 0;
    for (int i=0; i<Noutput; i++) {
      if (outputs[i] > outMax) {
        outMax = outputs[i];
        direction = i;
      }
    }
  }
  
  void show() {
    // Draw tail
    for (int i = 0; i < lvl; i++) {
      fill (color(0, 255, 0)); 
      rect(snakeX[i], snakeY[i], elementSize, elementSize);
    }
    
    // Draw apple
    fill (color(255, 0, 0));
    rect(apple[0],apple[1],elementSize,elementSize);
    
    // Draw head
    fill (color(0, 255, 0)); 
    rect(x, y, elementSize, elementSize);
    text(lvl,x+elementSize,y+elementSize);
    fill (color(255, 0, 0)); 
    ellipse(x+elementSize/3,y+elementSize/3,elementSize/4,elementSize/4);
  }
}
