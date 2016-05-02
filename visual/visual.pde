import java.util.ArrayList;
import java.util.Collections;
import ketai.sensors.*;

KetaiSensor sensor;

float cursorX, cursorY;
float light = 0;
int r,g,b;
boolean task1 = true;

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
    size(displayWidth, displayHeight); //you can change this to be fullscreen
    frameRate(60);
    sensor = new KetaiSensor(this);
    sensor.start();
    orientation(PORTRAIT);
  
    rectMode(CENTER);
    textFont(createFont("Arial", 40)); //sets the font to Arial size 20
    textAlign(CENTER);
    
    for (int i=0;i<trialCount;i++)  //don't change this!
    {
      Target t = new Target();
      t.target = ((int)random(1000))%4;
      t.action = ((int)random(1000))%2;
      targets.add(t);
      println("created target with " + t.target + "," + t.action);
    }
    
    Collections.shuffle(targets); // randomize the order of the button;
  }

void detColor(int num){
  if (num == 0) {
    r = 255;
    g = 0;
    b = 0;
  }
  else if (num == 1) {
    r = 0;
    g = 255;
    b = 0;}
  else if (num == 2) {
    r = 0;
    g = 0;
    b = 255;}
  else {
    r = 255;
    g = 255;
    b = 0;}
  
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
    
    translate(width,displayHeight);
    rotate(PI);
    
    fill(255);//white
    text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, 50);
    text("Target #" + ((targets.get(trialIndex).target)+1), width/2, 100);
    
    if (targets.get(trialIndex).action==0)
      text("UP", width/2, 150);
    else
       text("DOWN", width/2, 150);
    
    if (task1){
      for (int i=0;i<4;i++){
        fill(255);
        ellipse(i*175+100,3*(height/4),100,100);
        detColor(i);
        if(targets.get(trialIndex).target==i){
           fill(r,g,b);}
        else {
           fill(r,g,b,40);}       
        ellipse(i*175+100,3*(height/4),115,115);
      }
      
      for (int j = 0; j < 2; j++){
        if (targets.get(trialIndex).action == j){
          fill(240,240,70,50);
        }
        else {
          fill(240,240,70,10);
        }
        rect(j*(width),(height/3), 200,500);
      }
    }
       
    else {  //task 2 
      for (int i=0;i<4;i++){
        //fill(255);
        //ellipse(i*175+100,3*(height/4),100,100);
        detColor(i);
        if(targets.get(trialIndex).target==i){
           fill(r,g,b,60);}
        else {
          fill(255);
        ellipse(i*175+100,3*(height/4),100,100);
           fill(r,g,b,40);}
        ellipse(i*175+100,3*(height/4),115,115);
      }
      
      for (int j = 0; j < 2; j++){
        if (targets.get(trialIndex).action == j){
          fill(240,240,70);
        }
        else {
          fill(240,240,70,10);
        }
        rect(j*(width),(height/3), 200,500);
      }
    }
  }