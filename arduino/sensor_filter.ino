
#include <DHT.h>

#define DHT_PIN 10
#define DHT_TYPE DHT11

DHT dht(DHT_PIN, DHT_TYPE);

const unsigned long SAMPLE_INTERVAL_MS = 2000;
const int WINDOW = 5;

float tempBuffer[WINDOW];
float humBuffer[WINDOW];

int nextIndex = 0;
int sampleCount = 0;

unsigned long lastSample = 0;

void setup() {
  Serial.begin(115200);
  dht.begin();

  // CSV header for MATLAB
  Serial.println(
    "time_ms,temp_C,humidity_pct,temp_avg_C,humidity_avg_pct"
  );
}

void loop() {
  unsigned long now = millis();

  if (now - lastSample < SAMPLE_INTERVAL_MS) {
    return;
  }
  lastSample = now;

  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  if (isnan(temp) || isnan(hum)) {
    Serial.println("ERROR");
    return;
  }

  tempBuffer[nextIndex] = temp;
  humBuffer[nextIndex] = hum;

  nextIndex = (nextIndex + 1) % WINDOW;

  if (sampleCount < WINDOW) {
    sampleCount++;
  }

  float tempSum = 0;
  float humSum = 0;

  for (int i = 0; i < sampleCount; i++) {
    tempSum += tempBuffer[i];
    humSum += humBuffer[i];
  }

  float tempAvg = tempSum / sampleCount;
  float humAvg = humSum / sampleCount;

  Serial.print(now);
  Serial.print(",");
  Serial.print(temp, 2);
  Serial.print(",");
  Serial.print(hum, 2);
  Serial.print(",");
  Serial.print(tempAvg, 2);
  Serial.print(",");
  Serial.println(humAvg, 2);
}
