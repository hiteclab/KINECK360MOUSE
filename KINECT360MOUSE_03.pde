/********************************************************

KINECT360MOUSE V0.3
Control of the movement of the mouse using a Kinect 360.
Control de movimiento del mouse usando un Kinect 360.
https://github.com/hiteclab/KINECT360MOUSE

*********************************************************
ENGLISH
*********************************************************

Developed by Jose David Cuartas
Hypermedia Lab of Technologies for Communication
University Los Libertadores
Bogotá, Colombia, 2016.
GPL license V3

This code is based in the example: "Kinect4WinExample" 
from the Kinect4WinSDK library in processing 3.0

***********************************************************
ESPAÑOL
***********************************************************

Desarrollado por Jose David Cuartas Correa
Laboratorio Hipermedia de Tecnologias para Comunicación
Fundación Universitaria Los Libertadores
Bogotá, Colombia, 2016.
Licencia GPL Versión 3 

Este código se basa en el ejemplo: "Kinect4WinExample" 
de la Librería Kinect4WinSDK en Processing 3.0
********************************************************/


import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

import javax.swing.*;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.InputEvent; 

int mousestate=-1;
Robot mouse;


Kinect kinect;
ArrayList <SkeletonData> bodies;

float hx=0, hy=0, hz, lx, ly, rx, ry;

void setup()
{
  size(displayWidth, displayHeight);
  background(0);
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
  
  try
  {
    mouse = new Robot();
  }
  catch (AWTException e)
  {
    println("Java Robot not supported");
    exit();
  }
  
}

void draw() {
  background(0);
  
  //image(kinect.GetImage(), 0, 0, 800, 600);// show the image of the camera at 800x600 resolution

  // Read joints from Skeleton
  for (int i=0; i<bodies.size (); i++) 
  {
    keyjoints(bodies.get(i));
  }
  
  fill(255);
  rect(hx,hy,10,10);
  fill(255,0,0);
  rect(lx,ly,10,10);
  fill(0,255,0);
  rect(rx,ry,10,10);

  if(mousestate==1){

    // Move the mouse with the right hand
    mouse.mouseMove(int(rx), int(ry));
    
    // Press left click of the mouse
    if (ly<150) {
      rect(width-100,0,100,100);
      mouse.mousePress(InputEvent.BUTTON1_MASK);
      mouse.mouseRelease(InputEvent.BUTTON1_MASK);
    } /*else
  
    if (ly>height-100) {
      rect(width-100,0,100,100);
      mouse.mousePress(InputEvent.BUTTON3_MASK);
      mouse.mouseRelease(InputEvent.BUTTON3_MASK);    
    }*/
}
text("Hitec Lab, Fundación Universitaria Los Libertadores, Bogotá, Colombia, 2016.",20,20);
}

void keyjoints(SkeletonData _s) 
{

  rx= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width;
  ry= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height;

  lx= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x*width;
  ly= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y*height;
  
  hx= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HEAD].x*width;
  hy= _s.skeletonPositions[Kinect.NUI_SKELETON_POSITION_HEAD].y*height;
  
}



void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}


void keyPressed(){
if(key==' ')mousestate=mousestate*-1;;
}