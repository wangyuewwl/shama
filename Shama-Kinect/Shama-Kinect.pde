import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import org.openkinect.processing.*;
import processing.sound.*;
import processing.serial.*;  

Serial myPort;

Kinect2 kinect2;

float minThresh = 480; // min sensing distance
float maxThresh = 1400; // max sensing distance

int _data [] = new int[0];

Minim minim;
AudioPlayer file;
AudioPlayer file1;

String audioName = "Forest.mp3"; 
String audioName1 = "Water.mp3"; 
String path;
String path1;

// Forest Color Before
int rf0 = 0;
int gf0 = 100;
int bf0 = 0;

// Forest Color After
int rf01 = 173;
int gf01 = 255;
int bf01 = 50;

int rf = rf0;
int rf1 = rf0;
int gf = gf0;
int gf1 = gf0;
int bf = bf0;
int bf1 = bf0;

// Water Color Before
int rw0 = 31;
int gw0 = 164;
int bw0 = 220;

// Water Color After
int rw01 = 157;
int gw01 = 233;
int bw01 = 249;

int rw = rw0;
int rw1 = rw0;
int gw = gw0;
int gw1 = gw0;
int bw = bw0;
int bw1 = bw0;

void setup() {
  
  size(640, 480, P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  String portName = "/dev/cu.usbmodem14111";
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  path = sketchPath(audioName);
  minim = new Minim(this);
  file = minim.loadFile(path);
  path1 = sketchPath(audioName1);
  file1 = minim.loadFile(path1);
}

void draw() {
  background(255);
  
  // Forest changes color
  if (rf1 < rf01){
    rf1 = rf1 + 1;
    rf = rf + 1;
  } else {
    rf = rf - 1;
  }
    if (rf < rf0) {
      rf1 = rf0;
    }
    
   if (gf1 < gf01){
    gf1 = gf1 + 1;
    gf = gf + 1;
  } else {
    gf = gf - 1;
  }
    if (gf < gf0) {
      gf1 = gf0;
    }
    
    if (bf1 < bf01){
    bf1 = bf1 + 1;
    bf = bf + 1;
  } else {
    bf = bf - 1;
  }
    if (bf < bf0) {
      bf1 = bf0;
    }
    
      // Water changes color
  if (rw1 < rw01){
    rw1 = rw1 + 1;
    rw = rw + 1;
  } else {
    rw = rw - 1;
  }
    if (rw < rw0) {
      rw1 = rw0;
    }
    
   if (gw1 < gw01){
    gw1 = gw1 + 1;
    gw = gw + 1;
  } else {
    gw = gw - 1;
  }
    if (gw < gw0) {
      gw1 = gw0;
    }
    
    if (bw1 < bw01){
    bw1 = bw1 + 1;
    bw = bw + 1;
  } else {
    bw = bw - 1;
  }
    if (bw < bw0) {
      bw1 = bw0;
    }
    
  PImage img = kinect2.getDepthImage();
  
  int[] depth = kinect2.getRawDepth();
    
  int skip = 5; // Dots density
  for(int x = 0; x < img.width; x+=skip) {
       for(int y = 0; y < img.height; y+=skip) {
           int index = x + y * img.width;
           float b = brightness (img.pixels[index]); // closer = brighter
           float z = map(b, 0, 255, 150, -250);
           int offset = x + y * kinect2.depthWidth;
           int d = depth[offset];
           if (d > minThresh && d < maxThresh) { 
               
               //Forest Color Change
               if (_data[0] > 10000 ) {
                 fill(rf, gf, bf);
                 pushMatrix();
                 translate(x, y, z);                   
                 noStroke();
                 ellipse(0, 0, 4, 4);
                 popMatrix();
               }
               
               //Water Color Change
                 if (_data[1] > 10000 ) {
                 fill(rw, gw, bw);                 
                 pushMatrix();
                 translate(x, y, z);                   
                 noStroke();
                 textSize(12);
                 rotate(15);
                 text("~", 0, 0 );
                 popMatrix();
               }
               
       } else {
       }
    }
  }
               //Forest sound palying
               if (_data[0] > 10000 ) {
                  if (!file.isPlaying()) {
                    println("forest is playing");
                    file.rewind();
                    file.play();
                    } else {
                    }
               } 
              
              if (_data[0] < 10000 ) {
                  if (file.isPlaying()) {
                    println("forest is pause");
                    file.pause();
                    } else {
                    }
               } 
               
               //Water sound palying
               if (_data[1] > 10000 ) {
                  if (!file1.isPlaying()) {
                    println("water is playing");
                    file1.rewind();
                    file1.play();
                    } else {
                    }
               } 
               if (_data[1] < 10000 ) {
                  if (file1.isPlaying()) {
                    println("water is pause");
                    file1.pause();
                    } else {
                    }
               } 
}

void serialEvent(Serial myPort)
{
  try {
    String inString = myPort.readStringUntil('\n');
    inString = trim(inString);
    _data = int(split(inString, ','));
    print("found data: ");
    println(_data);
  }
  catch(Exception e) {
    print("caught error in serial event handler, ");
    println(e);
  }
}