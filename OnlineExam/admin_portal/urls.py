from django.urls import path , re_path
from . import views
urlpatterns = [
	
	re_path('college/?$', views.college_view),
	re_path('college/(?P<token>)/?$', views.college_view),
	re_path('questions/?$', views.question_view),
	re_path('questionSet/?$', views.question_set_view),
	re_path('questionSet/(?P<identifier>\w+)/(?P<token>\w+)/?$', views.question_set_view),
	re_path('questionSet/(?P<identifier>\w+)/?', views.question_set_view),
    # path(r'(?P<token>)-(?P<identifier>)/?', views.exam_view),
]