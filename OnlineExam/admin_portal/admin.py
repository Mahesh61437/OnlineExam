from django.contrib import admin

from .models import Question
from .models import QuestionSet
from .models import Answer
from .models import College

admin.site.register(Question)
admin.site.register(QuestionSet)
admin.site.register(Answer)
admin.site.register(College)
