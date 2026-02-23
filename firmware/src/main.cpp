#include <Arduino.h>
#include <WiFi.h>
#include <esp_wifi.h>
#include <WiFiManager.h>
#include <HTTPClient.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoOTA.h>
#include <ESPmDNS.h>
#include <Wire.h>
#include <sps30.h>
#include <LittleFS.h>

#define I2C_SDA 32
#define I2C_SCL 33

AsyncWebServer server(80);
SPS30 sps30;
sps_values vals;

float pm1 = 0, pm25 = 0, pm10 = 0;
unsigned long lastSensorRead = 0;
int updateInterval = 5;

char sensorId[20] = "SENSOR_01";
char serverUrl[100] = "http://onyx-server.local:8000/air-quality";
char intervalStr[5] = "5";

bool shouldSaveConfig = false;

void saveConfigCallback() {
  shouldSaveConfig = true;
}

void loadConfig() {
  if (LittleFS.exists("/config.txt")) {
    File f = LittleFS.open("/config.txt", "r");
    if (f) {
      f.readBytesUntil('\n', sensorId, sizeof(sensorId));
      f.readBytesUntil('\n', serverUrl, sizeof(serverUrl));
      f.readBytesUntil('\n', intervalStr, sizeof(intervalStr));
      f.close();
      // Remove trailing newlines
      sensorId[strcspn(sensorId, "\r\n")] = 0;
      serverUrl[strcspn(serverUrl, "\r\n")] = 0;
      intervalStr[strcspn(intervalStr, "\r\n")] = 0;
      updateInterval = atoi(intervalStr);
      if (updateInterval < 5) updateInterval = 5;
      Serial.println("Config loaded from LittleFS");
    }
  }
}

void saveConfig() {
  File f = LittleFS.open("/config.txt", "w");
  if (f) {
    f.println(sensorId);
    f.println(serverUrl);
    f.println(updateInterval);
    f.close();
    Serial.println("Config saved to LittleFS");
  }
}

void setup() {
  Serial.begin(115200);
  delay(3000);
  Serial.println("\n\n=== Air Quality Sensor Starting ===");
  
  if (!LittleFS.begin(true)) {
    Serial.println("LittleFS Mount Failed");
  }
  
  // Clear old config and WiFi credentials (remove this block after all sensors updated)
  LittleFS.remove("/config.txt");
  Serial.println("Cleared old config - using new defaults");
  WiFi.mode(WIFI_STA);
  WiFi.disconnect(true, true);
  delay(1000);
  esp_wifi_restore();
  Serial.println("Cleared WiFi credentials");
  delay(1000);
  
  Wire.begin(I2C_SDA, I2C_SCL, 100000); 

  if (sps30.begin(&Wire) != 0) {
    Serial.println("SPS30 Init Fail");
  }
  
  sps30.reset();
  delay(2000);
  sps30.start();

  WiFiManager wm;
  WiFiManagerParameter custom_sensor_id("sensor_id", "Sensor ID", sensorId, 20);
  WiFiManagerParameter custom_server("server", "Server URL", serverUrl, 100);
  WiFiManagerParameter custom_interval("interval", "Interval (sec)", intervalStr, 5);
  wm.addParameter(&custom_sensor_id);
  wm.addParameter(&custom_server);
  wm.addParameter(&custom_interval);
  wm.setSaveConfigCallback(saveConfigCallback);

  Serial.println("Starting WiFiManager...");
  if (!wm.autoConnect("AirQuality-AP")) {
    Serial.println("WiFi connect failed, restarting...");
    ESP.restart();
  }
  Serial.println("WiFi connected!");

  if (!MDNS.begin(sensorId)) {
    Serial.println("mDNS responder failed");
  } else {
    Serial.println("mDNS responder started");
  }

  if (shouldSaveConfig) {
    strncpy(sensorId, custom_sensor_id.getValue(), sizeof(sensorId) - 1);
    strncpy(serverUrl, custom_server.getValue(), sizeof(serverUrl) - 1);
    updateInterval = atoi(custom_interval.getValue());
    if (updateInterval < 5) updateInterval = 5;
    saveConfig();
  }
  
  Serial.printf("Sensor ID: %s\n", sensorId);
  Serial.printf("Server URL: %s\n", serverUrl);

  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(LittleFS, "/index.html", "text/html");
  });

  server.on("/data", HTTP_GET, [](AsyncWebServerRequest *request){
    char json[250];
    snprintf(json, sizeof(json), "{\"sensor_id\":\"%s\",\"pm1\":%.1f,\"pm25\":%.1f,\"pm10\":%.1f,\"interval\":%d}",
             sensorId, pm1, pm25, pm10, updateInterval);
    request->send(200, "application/json", json);
  });

  server.on("/clean", HTTP_GET, [](AsyncWebServerRequest *request){
    sps30.clean();
    request->send(200, "text/plain", "OK");
  });

  server.on("/reset-wifi", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200, "text/plain", "WiFi credentials cleared. Restarting...");
    delay(1000);
    WiFiManager wm;
    wm.resetSettings();
    ESP.restart();
  });

  ArduinoOTA.setHostname(sensorId);
  ArduinoOTA.begin();
  server.begin();
  
  Serial.print("Webpage active at: http://");
  Serial.println(WiFi.localIP());
}

void postToServer() {
  if (strlen(serverUrl) == 0) {
    Serial.println("[ERROR] No server URL configured");
    return;
  }
  
  Serial.println("\n=== POST DEBUG ===");
  Serial.printf("WiFi connected: %s\n", WiFi.isConnected() ? "YES" : "NO");
  Serial.printf("WiFi SSID: %s\n", WiFi.SSID().c_str());
  Serial.printf("Local IP: %s\n", WiFi.localIP().toString().c_str());
  Serial.printf("Gateway: %s\n", WiFi.gatewayIP().toString().c_str());
  Serial.printf("DNS: %s\n", WiFi.dnsIP().toString().c_str());
  
  HTTPClient http;
  String url = String(serverUrl) + "/api/readings/";
  Serial.printf("Target URL: %s\n", url.c_str());
  
  // Try DNS resolution
  IPAddress resolvedIP;
  if (WiFi.hostByName("onyx-server.local", resolvedIP)) {
    Serial.printf("DNS resolved onyx-server.local -> %s\n", resolvedIP.toString().c_str());
  } else {
    Serial.println("[ERROR] DNS resolution FAILED for onyx-server.local");
  }
  
  http.begin(url);
  http.addHeader("Content-Type", "application/json");
  http.setTimeout(10000);  // 10 second timeout
  
  char payload[200];
  snprintf(payload, sizeof(payload), 
    "{\"sensor_id\":\"%s\",\"pm1\":%.2f,\"pm25\":%.2f,\"pm10\":%.2f}",
    sensorId, pm1, pm25, pm10);
  Serial.printf("Payload: %s\n", payload);
  
  Serial.println("Sending POST...");
  int httpCode = http.POST(payload);
  if (httpCode > 0) {
    Serial.printf("[OK] HTTP %d\n", httpCode);
    if (httpCode == 200) {
      Serial.printf("Response: %s\n", http.getString().c_str());
    }
  } else {
    Serial.printf("[ERROR] POST failed: %s (code %d)\n", http.errorToString(httpCode).c_str(), httpCode);
  }
  http.end();
  Serial.println("==================\n");
}

void loop() {
  if (millis() - lastSensorRead >= (updateInterval * 1000UL)) {
    lastSensorRead = millis();
    Serial.println("Reading sensor...");
    if (sps30.GetValues(&vals) == 0) {
      pm1  = vals.MassPM1;
      pm25 = vals.MassPM2;
      pm10 = vals.MassPM10;
      
      // Skip posting if all values are zero (sensor warmup/cycle issue)
      if (pm1 == 0.0 && pm25 == 0.0 && pm10 == 0.0) {
        Serial.println("Skipping zero reading");
      } else {
        postToServer();
      }
    } else {
      Serial.println("SPS30 read failed");
    }
  }
  ArduinoOTA.handle(); 
}
