from django.db import models

import json
import ast

from . import model_choices

class College(models.Model): #Description: Attrs of college
    name = models.CharField(null=True, max_length=900)
    logo = models.CharField(null=True, max_length=900)
    contact = models.CharField(null=True, max_length=900)
    email = models.CharField(null=True, max_length=900)
    code = models.CharField(null=True, max_length=900)
    # meta
    token = models.CharField(null=True, max_length=900)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(null=True)

    class Meta:
        get_latest_by = "created_at"

class QuestionSet(models.Model):#Description: Model to maitain different question set for different college"""
    created_at = models.DateTimeField(auto_now_add=True)

    name = models.CharField(null=True, max_length=50)
    question_arr = models.CharField(max_length=900, null=True)
    time_limit = models.IntegerField(null=True)
    identifier = models.CharField(null=True, max_length=900)

    # realtions
    college = models.ForeignKey(College, null=True,on_delete=models.CASCADE)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(null=True)

    def setquestion_arr(self, i):
        self.question_arr = list(int(i))

    def getquestion_arr(self):
        return list(self.question_arr)

    def _get_details(self):
        return {'name': self.name, 'questions': self._get_all_questions(),
        'time_limit': self.time_limit, 'identifier': self.identifier, 'college_token': self.college.token}

    def _get_all_questions(self):

        print ('self.question_arr {}'.format(type(self.question_arr)))

        question_list = lambda arr: [int(i) for i in ast.literal_eval(arr)] if not isinstance(arr, list) and arr is not None else [int(i) for i in arr ]
        return [q._get_question() for q in [Question.objects.get(pk=pk) for pk in question_list(self.question_arr)]]

    def _update_college(college_token=None):
        college = College.objects.filter(token=college_token)
        self.college = college.first() if college.exists() else self.college
        self.save()
        return self
    def _update_question_set_questions(self, post, college_token=None):
        college = College.objects.filter(token=college_token) if college_token else None
        self.college = college.first() if college_token and college.exists() and post['action'] == 'add'  else None
        self.save()
        print ('type {} \n'.format(type(self.question_arr)))
        question_list = lambda arr: [int(i) for i in ast.literal_eval(arr)] if not isinstance(arr, list) and arr is not None else [int(i) for i in arr ]

        qset_append = lambda i: question_list(self.question_arr)+[i] if self.question_arr else [i]
        qset_remove = lambda i:[pk for pk in question_list(self.question_arr) if pk != i] if self.question_arr else []
        # actions = {'remove': qset_remove(pk)}
        # actions['add'] = actions['set_create'] = actions['set_update'] = qset_append(pk)
        if 'questions' in post:
            for pk in post['questions']:
                if post['action'] == 'add' and pk not in question_list(self.question_arr):
                    self.question_arr = qset_append(pk)
                    self.save()
                if post['action'] == 'remove' and pk in question_list(self.question_arr):
                    self.question_arr = qset_remove(pk)
                    self.save()
                if post['action'] == 'set_create' or post['action'] == 'set_update':
                    self.question_arr = qset_append(pk)
                    self.save()
        return self
            



    class Meta:
        pass

class Question(models.Model):
    """
    Description: Attrs of a question
    """
    OBJECTIVE='OBJECTIVE'
    FILL_UP = 'FILL_UP'
    CODE='CODE'
    CHECK_BOX ='CHECK_BOX'
    QUESTION_TYPES = (
	(OBJECTIVE, 'Objective'),
	(FILL_UP, 'Fill Up'),
	(CODE, 'Code'),
	(CHECK_BOX, 'Check Box')
	)
    description = models.CharField(null=True, max_length=1500)
    question_type = models.CharField(choices=QUESTION_TYPES, max_length=100, default=FILL_UP)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(null=True)

    def _get_question(self, student=False):
        ans_set = Answer.objects.filter(question=self)
        # return {'question':self.description, 'id': self.pk, 'type':self.question_type,
        #     'answers': [ans._get_readonly_answers() if student else ans._get_answers() for ans in ans_set]}
        return {
        'question':self.description, 'id': self.pk, 'type':self.question_type,
        'answers': [ans._get_readonly_answers() if student else ans._get_answers() for ans in ans_set]
        }

    def _get_student_questions(self, student, qset, stud_ans):
        chkbox_ans = lambda ans: ast.literal_eval(ans.first().description) if (ans.exists() and ans.first().description is not None) else []
        stud_ans_set = Answer.objects.filter(question=self)
        stud_ans = stud_ans.filter(question=self, question_set=qset)
        return {
        'question': self.description, 'id': self.pk, 'type':self.question_type,
        'answers': [ans._get_readonly_answers() for ans in stud_ans_set] if self.question_type=='checkbox' or self.question_type=='objective' else None,
        # 'user_answer': ast.literal_eval(stud_ans.first().description) if (stud_ans.exists() and self.question_type=='checkbox' and stud_ans.first().description is not None) else [] if (stud_ans.exists() and self.question_type=='checkbox' and stud_ans.first().description is None) else usr_ans
        'user_answer': chkbox_ans(stud_ans) if self.question_type=='checkbox' else stud_ans.first().description if stud_ans.exists() and stud_ans.first().description else None 
        }

    class Meta:
        pass

class Answer(models.Model):
    """
    Description: Attrs of a answer
    """

    description = models.CharField(null=True, max_length=900)
    is_correct = models.BooleanField(default=False)

    # relations
    question = models.ForeignKey(Question,on_delete=models.CASCADE)
    # meta
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(null=True)

    def _get_answers(self):
        return {'description':self.description, 'is_correct': self.is_correct,'question_id':self.question.pk}  if self else None

    def _get_readonly_answers(self):
        return {'description':self.description} if self.question.question_type=='checkbox' or self.question.question_type=='objective' else None


    class Meta:
        pass