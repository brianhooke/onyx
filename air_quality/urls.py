from django.urls import path
from . import views

app_name = 'air_quality'

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('api/sensors/', views.api_sensors, name='api_sensors'),
    path('api/sensors/<str:sensor_id>/', views.api_sensor_update, name='api_sensor_update'),
    path('api/sensors/<str:sensor_id>/reset-wifi/', views.api_reset_wifi, name='api_reset_wifi'),
    path('api/readings/', views.api_readings, name='api_readings'),
    path('api/readings/history/', views.api_readings_history, name='api_readings_history'),
]
