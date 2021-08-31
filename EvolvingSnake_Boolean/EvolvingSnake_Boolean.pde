final int step = 10;        // Step size of the snake (keep at 10)

// Parameters
final int stamina = 5;                      // Number of times the snake can cross the field before running out of energy
final float mutation_factor = 0.05;         // Percentage of the genes that mutate (0-1)
final float mutation_amp = 1/5;             // Multiplication factor controlling the amplitude of the mutations
final int pop_size = 100;                   // Population size
final int Nmutate = 10;                     // Number of snakes that move on to next generation
final int gen_max = 150;                    // Max generation to which the evolution runs
final boolean initialize = false;           // When true, the genotype in the current folder is used for gen 1

// At the last generation, the program pauses. Click on the window and press space to play last gen.
final int fps = 80;  // Frames/steps per second at which last gen is played

int generation = 0;
int high_score;

int[] graph_data = new int[0];
FitnessGraph graph;

boolean play_last = false;
boolean freeze = false;
boolean game_beaten = false;

Population pop;

void setup() {
  size(200, 200);       // Size of the playing field (in this case 20 by 20 blocks)
  frameRate(2000);
  smooth();
  noStroke();
  pop = new Population(pop_size);
  graph = new FitnessGraph();
  generation++;
  println("Generation " + generation);
}

void draw() {
  background(0);
  if (freeze) {
    delay(10000);
    exit();
  } else if (!pop.allDead()) {
    if (generation!=gen_max || play_last) {  
      pop.update();
      if (play_last) {
        pop.show();
      }
    }
  } else {
    int[][] best = pop.getBest();
    high_score = best[0][0];
    graph_data = append(graph_data, high_score);
    println("High score = " + high_score);
    
    if (high_score >= 399) {
      game_beaten = true;
      println("A snake ate all the apples!!");
    }
    
    if (generation > gen_max-1 || game_beaten) {
      pop.allSnakes[best[1][0]].show();           // Show best snake for last freeze frame
      save1DFile(float(graph_data), "data.dat");  // Save graph data
      freeze = true;
    } else {
      pop.mutate(best, mutation_factor);
      generation++;
      println("");
      println("Generation " + generation);
    }
  }
}

void keyPressed() {
  if (generation==gen_max) {
    frameRate(fps);
    play_last = true;
  }
}

public void save1DFile(float[] arr, String name) {
    String[] lines = new String[1];
    lines[0] = "";
    
    for (int i=0; i<arr.length; i++) {
      if (i==arr.length-1) {
        lines[0] += arr[i];
      } else {
        lines[0] += arr[i] + ",";
      }
    }
    saveStrings(name, lines);
  }
