from django.urls import path , re_path
from . import views

urlpatterns = [
	
	re_path(r'(?P<college_token>\w+)-(?P<identifier>\w+)/register/?', views.register_view),
    re_path(r'(?P<college_token>\w+)-(?P<identifier>\w+)/me-(?P<student_token>\w+)/?$', views.exam_view),
]