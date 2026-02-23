from django.db import models


class Sensor(models.Model):
    sensor_id = models.CharField(max_length=50, unique=True, primary_key=True)
    display_name = models.CharField(max_length=100)
    ip_address = models.CharField(max_length=45, null=True, blank=True)
    last_seen = models.DateTimeField(auto_now=True)
    pm1 = models.FloatField(null=True, blank=True)
    pm25 = models.FloatField(null=True, blank=True)
    pm10 = models.FloatField(null=True, blank=True)

    def __str__(self):
        return self.display_name


class Reading(models.Model):
    sensor = models.ForeignKey(Sensor, on_delete=models.CASCADE, related_name='readings')
    pm1 = models.FloatField()
    pm25 = models.FloatField()
    pm10 = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-timestamp']

    def __str__(self):
        return f"{self.sensor.display_name} @ {self.timestamp}"
