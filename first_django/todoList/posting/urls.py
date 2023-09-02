from django.contrib import admin
from django.urls import include, path
from posting import views

app_name='posting'

urlpatterns = [
    path(''),
    path('admin/', admin.site.urls),
    # posting이라는 주소를 받았을 때 posting app으로 연결
    path('posting/', include('posting.urls')),
    path('addTask',views.addTask,name='addTask')
]
