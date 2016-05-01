import java.util.ArrayList;
import java.util.Collections;
import ketai.sensors.*;
import ketai.camera.*;

KetaiSensor sensor;
KetaiCamera cam;
KetaiCamera backCam;
KetaiCamera frontCam;

float cursorX, cursorY;
float light = 0;
boolean task1 = true;
//red = 0; green = 1; blue = 2; yellow = 3;
int avgRed;
int avgGreen;
int avgBlue;
int chosenTarget = -1;
float pTime;
float lTime;

  private class Target
  {
    int target = 0;
    int action = 0;
  }

  int trialCount = 5; //this will be set higher for the bakeoff
  int trialIndex = 0;
  ArrayList<Target> targets = new ArrayList<Target>();
     
  int startTime = 0; // time starts when the first click is captured
  int finishTime = 0; //records the time of the final click
  boolean userDone = false;
  int countDownTimerWait = 0;
  
  void setup() {
    size(600,600); //you can change this to be fullscreen
    frameRate(60);
    sensor = new KetaiSensor(this);
    sensor.start();
    orientation(PORTRAIT);
    imageMode(CENTER);
    cam = new KetaiCamera(this, width, height, 24); //parent, width, height, frames per sec
    cam.setCameraID(1); // id 0: backfacing; id 1: frontfacing
    
    rectMode(CENTER);
    textFont(createFont("Arial", 40)); //sets the font to Arial size 20
    textAlign(CENTER);
    
    for (int i=0;i<trialCount;i++)  //don't change this!
    {
      Target t = new Target();
      t.target = ((int)random(1000))%4;
      //t.action = ((int)random(1000))%2;
      targets.add(t);
      //println("created target with " + t.target + "," + t.action);
    }
    
    Collections.shuffle(targets); // randomize the order of the button;
  }

  void draw() {

    background(80); //background is light grey
    noStroke(); //no stroke
    
    countDownTimerWait--;
    
    if (startTime == 0)
      startTime = millis();
    
    if (trialIndex==targets.size() && !userDone)
    {
      userDone=true;
      finishTime = millis();
    }
    
    if (userDone)
    {
      text("User completed " + trialCount + " trials", width/2, 50);
      text("User took " + nfc((finishTime-startTime)/1000f/trialCount,1) + " sec per target", width/2, 150);
      return;
    }
    
    Target t = targets.get(trialIndex);
    
    if (task1){
    fill(255);//white
    text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, 50);
    text("Target #" + ((t.target)+1), width/2, 100);
    }
    int targetNum = t.target;
    if (task1){
      if (targetNum == chosenTarget){
        println("target chosen");
        task1 = false;
        chosenTarget = -1;
      }
    }
    
    if (!task1){
    if (t.action==1)
     text("LEFT", width/2, 150);
    else
      text("RIGHT", width/2, 150);
    }
    
    if (lTime > pTime) { //left to right
      if (t.action == 0) {
        println("right direction");
        trialIndex++;
        lTime = 0;
        pTime = 0;
        task1 = true;
      }
      else {
        println("wrong direction");
      } 
    }
    
    else if (lTime < pTime) {
      if(t.action == 1){
        println("right direction");
        lTime = 0;
        pTime = 0;
        trialIndex++;
        task1 = true;
      }
      else {
        println("wrongDirection");
      }
    }
    
  }

void mousePressed(){
  println("here");
  if (cam.isStarted()){
    println("camera started");
  cam.read();
  cam.loadPixels();
  float red = 0;
  float green = 0;
  float blue = 0; 
  for (int index = 0; index < cam.pixels.length; index++){
    red += red(cam.pixels[index]);
    green += green(cam.pixels[index]);
    blue += blue(cam.pixels[index]);
  }
  red = red/(cam.pixels.length);
  green = green/(cam.pixels.length);
  blue = blue/(cam.pixels.length);
  if (red > (Math.abs(red-255))) {avgRed = 1;}
  else {avgRed = 0;}
  
  if (green > (Math.abs(green-255))) {avgGreen= 1;}
  else {avgGreen = 0;}
  
  if (blue > (Math.abs(blue-255))) {avgBlue = 1;}
  else {avgBlue = 0;}
  
  if (avgRed == 1 && avgGreen == 0 && avgBlue == 0) 
    chosenTarget = 0;
  
  else if (avgRed == 0 && avgGreen == 1 && avgBlue == 0) 
    chosenTarget = 1;
  
  else if (avgRed == 0 && avgGreen == 0 && avgBlue == 1) 
    chosenTarget = 2;
  
  else  //should i specify?
    chosenTarget = 3;
  
  task1 = false;
  }
  else {
    cam.start();
  }  
}

void onProximityEvent(float d){
  if (!task1)
    pTime = millis();
}

void onLightEvent(float v){
  if (!task1)
    lTime = millis();
  else 
    light = v;
}

//red: 255, 0 , 0
//green: 0, 255, 0
//blue: 0, 0, 255
//yellow: 255, 255, 0