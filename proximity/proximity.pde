import java.util.ArrayList;
import java.util.Collections;
import ketai.sensors.*;

KetaiSensor sensor;

float cursorX, cursorY;
//boolean selected = false;
int pTime = 0;
int lTime = 0;

  private class Target
  {
    //int target = 0;
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
  
    rectMode(CENTER);
    textFont(createFont("Arial", 40)); //sets the font to Arial size 20
    textAlign(CENTER);
    
    for (int i=0;i<trialCount;i++)  //don't change this!
    {
      Target t = new Target();
      //t.target = ((int)random(1000))%4;
      t.action = ((int)random(1000))%2;
      targets.add(t);
      println("created target with " + t.target + "," + t.action);
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
    
    fill(255);//white
    text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, 50);
    //text("Target #" + (targets.get(trialIndex).target)+1, width/2, 100);
    Target t = targets.get(trialIndex);
    
    if (t.action==0)
      text("RIGHT", width/2, 150);
    else
      text("LEFT", width/2, 150);
         
    if (lTime > pTime) { //left to right
      if (t.action == 0) {
        println("right direction");
        trialIndex++;
        lTime = 0;
        pTime = 0;
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
      }
      else {
        println("wrongDirection");
      }
    }
  } 
  
void onProximityEvent(float d){
  pTime = millis();
}

void onLightEvent(float v){
  lTime = millis();
}