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
float maxThresh = 2000; // max sensing distance

int _data [] = new int[0];

Minim minim;
AudioPlayer file;
//replace the sample.mp3 with your audio file name here
String audioName = "LeaveMeAlone.mp3";
String path;

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
}

void draw() {
  background(255);
  PImage img = kinect2.getDepthImage();
  
  int[] depth = kinect2.getRawDepth();
    
  int skip = 8; // Dots density
  println(_data[0]);
  for(int x = 0; x < img.width; x+=skip) {
       for(int y = 0; y < img.height; y+=skip) {
           int index = x + y * img.width;
           float b = brightness (img.pixels[index]); // closer = brighter
           float z = map(b, 0, 255, 150, -250);
           int offset = x + y * kinect2.depthWidth;
           int d = depth[offset];
           if (d > minThresh && d < maxThresh) { 
               if (_data[0] > 10 && _data[0] <= 400) {
                 fill(0, 255, 0);
                 pushMatrix();
                 translate(x, y, z);
                 //noStroke();
                 ellipse(0, 0, 3, 3);
                 //textSize(10); // text
                 //text("H", 0, 0); // text
                 popMatrix();
               } else
               //if (_data[0] > 800 && _data[0] <= 1600 ) {
               //  fill(255, 255, 0);
               //  pushMatrix();
               //  translate(x, y, z);                   
               //  textSize(10); // text
               //  text("Y", 0, 0); // text
               //  popMatrix();
               //} else
               //if (_data[0] > 400 && _data[0] <= 4000 ) {
               //  fill(0, 255, 0);
               //  pushMatrix();
               //  translate(x, y, z);
               //  ellipse(0, 0, 4, 4);
               //  //textSize(10); // text
               //  //text("H", 0, 0); // text
               //  popMatrix();
               //} else
               if (_data[0] > 400 ) {
                 fill(random(255-b*2),random(255-b*2),random(255-b*2)); // random color
                 pushMatrix();
                 translate(x, y, z);                   
                 //textSize(14); // text
                 rect(0, 0, 8, 8);
                 //text( "" + char( int( random(33,126) ) ), 0, 0 ); // random text
                 popMatrix();
               }
       } else {
       }
    }
  }
                if (_data[0] > 3000 ) {
                  //println("checking if sound is playing");
                  //println(file.isPlaying());
                  if (!file.isPlaying()) {
                    //println("trying to play");
                    file.rewind();
                    file.play();
                    } else {
                    }
               } 
}

void serialEvent(Serial myPort)
{
  try {
    // Grab the data off the serial port. See: 
    // https://processing.org/reference/libraries/serial/index.html
    String inString = myPort.readStringUntil('\n');
    inString = trim(inString);
    //distanceCm = Integer.parseInt(inString);
    _data = int(split(inString, ','));
    //println(_data);
  }
  catch(Exception e) {
    println(e);
  }
}