// number of readings per step
#define n 50 
int data[n]; 
unsigned int total = 0;     
int average = 0;
float sd; 
int direction = 1; 
char d = 0; 
int valuesensor, i; 
int sensorPin = A0; 
int pin_step = 5;  
int pin_direction = 4; 

void setup() 
{
  Serial.begin(9600);
  // Define output pins
  pinMode(pin_step, OUTPUT);
  pinMode(pin_direction, OUTPUT);
}

void loop()
{
if(Serial.available()>0); 
  d= Serial.read(); 
  // Define moving direction of the Light Dependent Resistor (LDR)
  if(d=='1')   direction = 1;
  if(d=='2')   direction = 0;  
  digitalWrite(pin_direction, direction);
  
  // move LDR 7000 steps 
  for (int p=0 ; p < 7000; p++) 
  {
    total=0.0;
    for (int i=0 ; i < n; i++)
    {
    data[i] = analogRead(sensorPin); 
    total += data[i];           
    }
    // calculate average of the readings
    average = total / n;  
    total=0.0;
    // calculate the standard deviation
    for (int i=0 ; i < n; i++)
    {
    total += (data[i]-average)*(data[i]-average);           
    }
    sd = sqrt(total / n); 
    // print to Serial port 
    Serial.print(average); 
    Serial.print(" ");
    Serial.print(p);
    Serial.print("  ");
    Serial.println(sd); 

    //define the velocity of the stepper motor
    digitalWrite(pin_step, 1); 
    delay(1);
    digitalWrite(pin_step, 0);
    delay(1);
   }
 }
}
