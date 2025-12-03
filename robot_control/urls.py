from django.urls import path
from . import views

app_name = 'robot_control'

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('api/status/', views.api_status, name='api_status'),
    path('api/position/', views.api_position, name='api_position'),
    path('api/events/', views.api_events, name='api_events'),
    path('api/force-torque/', views.api_force_torque, name='api_force_torque'),
    path('api/tasks/', views.api_tasks, name='api_tasks'),
    path('api/modules/<str:task>/', views.api_modules, name='api_modules'),
    path('api/start/', views.api_start, name='api_start'),
    path('api/stop/', views.api_stop, name='api_stop'),
    path('api/reset-pp/', views.api_reset_pp, name='api_reset_pp'),
    path('api/set-pp/', views.api_set_pp, name='api_set_pp'),
]
