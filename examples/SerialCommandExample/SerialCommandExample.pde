// Demo Code for SerialCommand Library using alternate Serial Port
// Steven Cogswell & Josh Adler
// May 2011, March 2024

#include <SerialCommand.h>

#define arduinoLED 13   // Arduino LED on board

SerialCommand sCmd(Serial4);     // The demo SerialCommand object

void setup() {
  pinMode(arduinoLED, OUTPUT);      // Configure the onboard LED for output
  digitalWrite(arduinoLED, LOW);    // default to LED off

  Serial4.begin(9600);

  // Setup callbacks for SerialCommand commands
  sCmd.addCommand("ON",    LED_on);          // Turns LED on
  sCmd.addCommand("OFF",   LED_off);         // Turns LED off
  sCmd.addCommand("HELLO", sayHello);        // Echos the string argument back
  sCmd.addCommand("P",     processCommand);  // Converts two arguments to integers and echos them back
  sCmd.setDefaultHandler(unrecognized);      // Handler for command that isn't matched  (says "What?")
  Serial4.println("Ready");
}

void loop() {
  sCmd.readSerial();     // We don't do much, just process serial commands
}


void LED_on() {
  Serial4.println("LED on");
  digitalWrite(arduinoLED, HIGH);
}

void LED_off() {
  Serial4.println("LED off");
  digitalWrite(arduinoLED, LOW);
}

void sayHello() {
  char *arg;
  arg = sCmd.next();    // Get the next argument from the SerialCommand object buffer
  if (arg != NULL) {    // As long as it existed, take it
    Serial4.print("Hello ");
    Serial4.println(arg);
  }
  else {
    Serial4.println("Hello, whoever you are");
  }
}


void processCommand() {
  int aNumber;
  char *arg;

  Serial4.println("We're in processCommand");
  arg = sCmd.next();
  if (arg != NULL) {
    aNumber = atoi(arg);    // Converts a char string to an integer
    Serial4.print("First argument was: ");
    Serial4.println(aNumber);
  }
  else {
    Serial4.println("No arguments");
  }

  arg = sCmd.next();
  if (arg != NULL) {
    aNumber = atol(arg);
    Serial4.print("Second argument was: ");
    Serial4.println(aNumber);
  }
  else {
    Serial4.println("No second argument");
  }
}

// This gets set as the default handler, and gets called when no other command matches.
void unrecognized(const char *command) {
  Serial4.println("What?");
}
