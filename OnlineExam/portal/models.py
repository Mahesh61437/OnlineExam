from django.db import models

# Create your models here.
import ast
# App imports
from admin_portal.model_choices import *
from admin_portal import models as admin_models

class Student(models.Model):
    """
    Description: Profile attrs of a student
    """
    # attrs
    name = models.CharField(null=True, max_length=900)
    reg_no = models.CharField(null=True, max_length=900)
    department = models.CharField(null=True, max_length=900)
    college_name = models.CharField(null=True, max_length=900)
    gender = models.CharField(max_length=20, choices=GENDER_CHOICES, null=True)
    email = models.CharField(null=True, max_length=900)
    phone = models.CharField(null=True, max_length=900)
    dob = models.DateField(null=True)
    # extra
    website  = models.CharField(null=True, max_length=900)
    github_url = models.CharField(null=True, max_length=900)
    resume = models.CharField(null=True, max_length=900)
    # meta
    token = models.CharField(null=True, max_length=900)
    exam_started_at = models.DateTimeField(null=True)
    last_submitted_at = models.DateTimeField(null=True)
    time_left = models.FloatField(null=True)
    #relations
    college = models.ForeignKey(admin_models.College,on_delete = models.CASCADE)


    def _get_questions(self, question_set):
        # queset = admin_models.QuestionSet.objects.get(college=self.college)
        stud_ans = StudentAnswer.objects.filter(student=self)
        for i in ast.literal_eval(question_set.question_arr): print ('type {}'.format(str(i)))
        # questions = [
        # {'data': ques._get_student_questions(self,question_set),
        # 'user_answer': stud_ans.objects.filter(question=ques).first()._get_student_answer(ques) if stud_ans.filter(question=ques).exists() else None  }
        #                 for ques in [admin_models.Question.objects.get(pk=int(i)) for i in ast.literal_eval(question_set.question_arr)]]
        questions = [ques._get_student_questions(self,question_set, stud_ans) for ques in [admin_models.Question.objects.get(pk=int(i)) for i in ast.literal_eval(question_set.question_arr)]]

        return questions
        # 'user_answers': {for ans in StudentAnswer.objects.filter(student=self, question_set=queset)}}
        # answers = [{ans.} for ans in StudentAnswer.objects.filter(student=self, question_set=queset)]

    def _get_student_answers(self, qset, question):
        stud_ans = StudentAnswer.objects.filter(student=self, question_set=qset, question=question)
        return {'description': ans.description if ans.description else None for ans in stud_ans}

    class Meta:
        pass

class StudentAnswer(models.Model):
    """
    Description: Model to store the student answers
    """
    
    description = models.CharField(null=True, max_length=900)

    # relations
    student = models.ForeignKey(Student,on_delete=models.CASCADE)
    question = models.ForeignKey(admin_models.Question,on_delete=models.CASCADE)
    question_set = models.ForeignKey(admin_models.QuestionSet,on_delete=models.CASCADE)

    # meta details
    submitted_at = models.DateTimeField(null=True)

    def _get_student_answer(self, question):
        ans = self.objects.filter(question=question)
        return ans.first().description if ans.exists() else None


    class Meta:
        pass