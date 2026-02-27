from django.urls import path
from . import views
from . import toolpath

app_name = 'robot_control'

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('api/status/', views.api_status, name='api_status'),
    path('api/position/', views.api_position, name='api_position'),
    path('api/live-log/', views.api_live_log, name='api_live_log'),
    path('api/events/', views.api_events, name='api_events'),
    path('api/events/detailed/', views.api_events_detailed, name='api_events_detailed'),
    path('api/events/latest/', views.api_events_latest, name='api_events_latest'),
    path('api/force-torque/', views.api_force_torque, name='api_force_torque'),
    path('api/tasks/', views.api_tasks, name='api_tasks'),
    path('api/modules/<str:task>/', views.api_modules, name='api_modules'),
    path('api/start/', views.api_start, name='api_start'),
    path('api/stop/', views.api_stop, name='api_stop'),
    path('api/reset-pp/', views.api_reset_pp, name='api_reset_pp'),
    path('api/set-pp/', views.api_set_pp, name='api_set_pp'),
    path('api/diagnostics/', views.api_diagnostics, name='api_diagnostics'),
    path('api/signals/', views.api_signals_list, name='api_signals_list'),
    # Toolpath Generator
    path('toolpath/', views.toolpath_generator, name='toolpath_generator'),
    path('api/toolpath/generate/', views.api_generate_toolpath, name='api_generate_toolpath'),
    path('api/toolpath/upload-original/', views.api_upload_original_progmod, name='api_upload_original_progmod'),
    path('api/toolpath/pull-irc5/', views.api_pull_irc5_files, name='api_pull_irc5_files'),
    path('api/toolpath/params/', toolpath.api_toolpath_params, name='api_toolpath_params'),
    path('api/toolpath/params/save/', toolpath.api_toolpath_save_params, name='api_toolpath_save_params'),
    path('api/toolpath/pattern-points/', views.api_pattern_points, name='api_pattern_points'),
    path('api/reload-program/', views.api_reload_program, name='api_reload_program'),
    path('api/tool-changer/', views.api_tool_changer, name='api_tool_changer'),
    path('api/activity-log/', views.api_activity_log, name='api_activity_log'),
    path('api/irc5/force-data/', views.api_force_data, name='api_force_data'),
    path('api/irc5/start-force-monitor/', views.api_start_force_monitor, name='api_start_force_monitor'),
]
