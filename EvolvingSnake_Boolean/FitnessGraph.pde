class FitnessGraph extends PApplet {
  FitnessGraph(){
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  
  void settings() {
      size(900,600); 
   }
   
   void setup() {
       background(255);
       frameRate(30);
   }
   
   void draw() {
      background(220);
      fill(0);
      strokeWeight(1);
      
      // Text
      textSize(15);
      textAlign(CENTER,CENTER);
      text("Generation", width/2,height-10);
      translate(10,height/2);
      rotate(PI/2);
      text("Score", 0,0);
      rotate(-PI/2);
      translate(-10,-height/2);
      textSize(10);
      
      float x = 50;
      float y = height-35;
      float dx = (width-50) / (round(gen_max/10)+1);
      float dy = (height-50) / 20;
      for(int i=0; i<=round(gen_max/10); i++) {
         text(i*10,x,y);
         x+=dx;
      }
      x = 35;
      y = height-50;
      for(int i=0; i<200; i+=10) {
         text(i,x,y); 
         line(50,y,width,y);
         y-=dy;
      }
      strokeWeight(2);
      stroke(255,0,0);
      
      // Data line
      int score = 0;
      for(int i=0; i<graph_data.length; i++) {
         int newscore = graph_data[i];
         line(50+(i*dx/10),height-50-(score*dy/10),50+((i+1)*dx/10),height-50-(newscore*dy/10));
         score = newscore;
      }
      
      // Frame
      stroke(0);
      strokeWeight(5);
      line(50,0,50,height-50);
      line(50,height-50,width,height-50);
   }
}
