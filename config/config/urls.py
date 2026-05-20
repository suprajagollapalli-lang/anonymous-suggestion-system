from django.contrib import admin
from django.urls import path
from suggestions import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.form_view),
    path('submit/', views.submit_view),
    path('success/', views.success_view),
    path('health/', views.health_check),
    path('dashboard/', views.dashboard),
]
