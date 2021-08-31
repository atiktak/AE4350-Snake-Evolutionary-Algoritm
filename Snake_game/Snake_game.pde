float speed=10;
float x = 20;
float y = 20;
float[] snakeX = new float[0];
float[] snakeY = new float[0];
float[] apple = new float[2];

int elementSize = 10;
int directionX = 1;
int directionY = 0;

int lvl = 0;
float fitness = 0;

boolean direction_change = false;
boolean apple_check = false;


void setup() {
  frameRate(10);
  size(200, 200);
  smooth();
  noStroke();
  ellipseMode(RADIUS);
  apple[0] = elementSize*round(random((width-elementSize)/elementSize));
  apple[1] = elementSize*round(random((height-elementSize)/elementSize));
}

void draw() {
  background(0);
  
  // Snake tail
  for (int i = 0; i < lvl; i++) {
    
    // Tail bite test
    if (snakeX[i]==x && snakeY[i]==y && i!=lvl-1) {
      lvl = 0;
      snakeX = new float[0];
      snakeY = new float[0];
      println("You bit your tail!");
      background(255, 0, 0);
      return;
    }
    
    // Shift tail positions
    if (i==lvl-1) {
      snakeX[i] = x;
      snakeY[i] = y;  
    } else {
      snakeX[i] = snakeX[i+1];
      snakeY[i] = snakeY[i+1];
    }
    
    // Draw tail
    fill (color(0, 255, 0)); 
    //fill (color(random(255), random(255), random(255))); 
    rect(snakeX[i], snakeY[i], elementSize, elementSize);
  }
  
  // Snake position
  x=x+speed*directionX;
  y=y+speed*directionY;
  
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

  fill (color(255, 0, 0));
  rect(apple[0],apple[1],elementSize,elementSize);
  fill (color(0, 255, 0));
  rect(x, y, elementSize, elementSize);
  fill (color(255, 0, 0)); 
  ellipse(x+elementSize/3,y+elementSize/3,elementSize/4,elementSize/4);
  
  // Check whether apple is eaten
  if (apple[0]==x && apple[1]==y) {
      apple[0] = elementSize*round(random((width-elementSize)/elementSize));
      apple[1] = elementSize*round(random((height-elementSize)/elementSize));
      apple_check = false;
      
      // Respawn apple if it's on the snake
      while (!apple_check) {
        apple_check = true;
        if (apple[0]==x && apple[1]==y) {
          apple[0] = elementSize*round(random((width-elementSize)/elementSize));
          apple[1] = elementSize*round(random((height-elementSize)/elementSize));
          apple_check = false;
        }
        for (int i = 0; i < lvl; i++) {
          if (snakeX[i]==apple[0] && snakeY[i]==apple[1]) {
              apple[0] = elementSize*round(random((width-elementSize)/elementSize));
              apple[1] = elementSize*round(random((height-elementSize)/elementSize));
              apple_check = false;
          }
        } 
      }

      lvl++;
      println(lvl);
        snakeX = append(snakeX, x);
        snakeY = append(snakeY, y);
  }
  direction_change = false;
}

void keyPressed() {
  if (key == CODED && !direction_change) {
    if (keyCode == LEFT && directionX==0) {
      directionX=-1;
      directionY=0;
    }
    else if (keyCode == RIGHT && directionX==0) {
      directionX=1;
      directionY=0;
    }
    else if (keyCode == UP && directionY==0) {
      directionY=-1;
      directionX=0;
    }
    else if (keyCode == DOWN  && directionY==0) {
      directionY=1;
      directionX=0;
    }
  direction_change = true;
  }
}
