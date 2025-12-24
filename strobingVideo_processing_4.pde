import ddf.minim.*;
import ddf.minim.ugens.*;

import processing.video.*;

Movie movie;
boolean help=true;
int movieWidth, movieHeight;
float frequency=40; //hz

Minim minim;
AudioOutput out;

Oscil      wave;

void setup() {
  size(displayWidth, displayHeight);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "launch2.mp4");
  movie.loop();
  frameRate(frequency*2);  //this is important
  movieWidth=width/4;
    // initialize the minim and out objects
  minim = new Minim(this);
  out   = minim.getLineOut();
  wave = new Oscil( frequency, 1, Waves.SINE ); 
  wave.patch( out );
}

void movieEvent(Movie m) {
  m.read();
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    movie = new Movie(this, selection.getAbsolutePath());
    movie.loop();
  }
}

void keyPressed()
{
  if (keyCode==UP)
    movieWidth+=10;
  if (keyCode==DOWN)
    if (movieWidth>10)
      movieWidth-=10;
  if (key=='h')
    help=!help;
  if (key=='o')
    selectInput("Select a video file to play:", "fileSelected");
}

void draw() {
  try {
    movieHeight=movieWidth*movie.height/movie.width;
  }
  catch(Exception e) {
    movieHeight=movieWidth*2/3;
  }
  if (frameCount % 2 ==0)
    fill(0);
  else
    fill(255);
  rect(0, 0, width, height);
  /*
  if (movie.available() == true) {
   movie.read();
   }
   */
  image(movie, width/2-movieWidth/2, height/2-movieHeight/2, movieWidth, movieHeight);
  fill(255);
  if (help)
  {
    text("framerate: "+frameRate, 0, 20);
    text("press 'o' to open video", 0, 40);
    text("press 'h' to toggle the help text", 0, 60);
    text("use up/down arrow keys to increase/decrease video size", 0, 80);
    if(abs(frameRate-(2*frequency)) > frequency*.1)  // if greater than a 10% error in frequency, let us know
      text("the actual frame rate is more than 10% lower than the requested framerate -- the strobing frequency is less than we'd like", 0, 100);
  }
}
