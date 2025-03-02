const int vscode = 2;
const int arduino = 3;
const int krita = 4;
const int yt = 5;
const int cs = 6;
const int lol = 7;
const int potPin = A0;

int lastVolume = -1;  // To detect changes in potentiometer

void setup() {
  pinMode(vscode, INPUT_PULLUP);
  pinMode(arduino, INPUT_PULLUP);
  pinMode(krita, INPUT_PULLUP);
  pinMode(yt, INPUT_PULLUP);
  pinMode(cs, INPUT_PULLUP);
  pinMode(lol, INPUT_PULLUP);

  Serial.begin(9600);  // Start serial communication
}

void loop() {
  // Buttons Section
  if (digitalRead(vscode) == LOW) {
    Serial.println("VSCode");
    delay(500);  // Debounce delay
  }
  if (digitalRead(arduino) == LOW) {
    Serial.println("Arduino");
    delay(500);
  }
  if (digitalRead(krita) == LOW) {
    Serial.println("Krita");
    delay(500);
  }
  if (digitalRead(yt) == LOW) {
    Serial.println("YouTube");
    delay(500);
  }
  if (digitalRead(cs) == LOW) {
    Serial.println("CounterStrike2");
    delay(500);
  }
  if (digitalRead(lol) == LOW) {
    Serial.println("LeagueOfLegends");
    delay(500);
  }

  // Potentiometer Section
  int potValue = analogRead(potPin);           // Read potentiometer (0-1023)
  int volume = map(potValue, 0, 1023, 0, 100);  // Map to volume (0-100%)

  if (abs(volume - lastVolume) > 1) {           // Send only if value changes significantly
    Serial.print("Volume:");
    Serial.println(volume);
    lastVolume = volume;                        // Update last value
  }

  delay(50);  // Small delay for stability
}
