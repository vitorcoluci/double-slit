//Import libraries
import grafica.*;
import processing.serial.*;
import controlP5.*;

//Creates an object plot
public GPlot plot;

//Creates an Icon button object
public ControlP5 cp5;

//Creates an Serial class
public Serial myPort; 

//Global variables
int i=0; //variável que muda para cálculo do ponto
int points = 1; //number of points to show
int totalPoints = 1000; //number of points on the X axis
float period = 1;
long previousMillis = 0;
int duration = 1000; //duration of the sampling. This should be the same value as in the Arduino code
int cont = 0;
float Counter = 0;
int eixoY=0;
int n_loops;
int [] vetor; 

String val;


void setup(){
  size(700,450); 
    
  // Creates buttons to control the stepper motor
  cp5 = new ControlP5(this);
  cp5.addBang("LEFT")
     .setPosition(20, 120)
     .setSize(35, 40)
     .setColorBackground(color(20,18,250))
     .setColorForeground(color(255,24,3))
     .setColorActive(color(12,250,54))
     ;
     
   cp5= new ControlP5(this);
   cp5.addBang("RIGHT")
        .setPosition(20, 220)
        .setSize(35,40)
        .setColorBackground(color(250,12,20))
        .setColorForeground(color(20,18,250))
        .setColorActive(color(12,250,54))        
        ;
    
    
  //Serial communication
  myPort = new Serial(this, "COM3", 9600); 
  GPointsArray points1= new GPointsArray(points);
    
  for(i=0; i<points; i++){
     points1.add(i,0);
    }
    
  //Creates the plot
  plot = new GPlot(this);
  plot.setPos(80,30); //Adjust the left corner position
  plot.setDim(500,300); //Plot size
  
  //Plot Limits 
  plot.setXLim(0,14000); // x axis
  plot.setYLim(0, 650); //  y axis
  
  //Title and legends 
  plot.setTitleText("Light Pattern");
  plot.getXAxis().setAxisLabelText("Points");
  plot.getYAxis().setAxisLabelText("Raw Voltage");
    
  plot.activatePanning();
  plot.activateZooming(1.5);
  plot.setPoints(points1);
}

void draw (){
  background(200); 
  
  //Reading Serial port
  if ( myPort.available() > 0) {  
           val = myPort.readStringUntil('\n');         
           Counter ++ ;
            if (val != null){
                int[] vetor = int (split(val, ' ')); // 3 column data 
                eixoY = vetor[0]; // first column = average
            }
  }
  // end of serial reading
   
 // Ploting data
 GPoint lastPoint = plot.getPointsRef().getLastPoint();

 if (lastPoint == null) {
         plot.addPoint(Counter, eixoY ); 
 }
 else if (!lastPoint.isValid()|| (Counter <= 30000)) {
         plot.addPoint(Counter,eixoY);
 }
   
 plot.beginDraw();
 plot.drawBackground();
 plot.drawBox();
 plot.drawXAxis();
 plot.drawYAxis();
 plot.drawTitle();
 plot.drawLines();
 plot.drawGridLines(GPlot.BOTH);
 plot.getMainLayer();
 plot.endDraw();
  
}

// Control steeper motor - Bottom to move left
public void LEFT() {
myPort.write('1');
}

// Control steeper motor - Bottom to move right
public void RIGHT(){
myPort.write('2');
}
