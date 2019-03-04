from django.shortcuts import render

import json
from django.views import View

from portal.views import JsonMixin
from .models import Question
from .models import QuestionSet
from .models import Answer
from .models import College
from . import model_choices

from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator

from portal.responses import *

class AdminPortal(JsonMixin):
	def __init__(self, request):
		super(AdminPortal, self).__init__()
		self.request = request

	def _college_exists(self, token):
		colg = College.objects.filter(token=token)
		if colg.exists():
			return True
		return False

	def _get_token(self, limit=None):
		import base64
		import hashlib
		import random
		import uuid
		# token = base64.b64encode(hashlib.sha256(str(random.getrandbits(256))).digest(), random.choice(['rA', 'aZ', 'gQ', 'hH', 'hG', 'aR', 'DD'])).rstrip('==')
		token = str(uuid.uuid4()).replace('-','')
		if limit:
			return token[:limit]
		return token

	def _get_request_time(self):
		from datetime import datetime
		return datetime.now()

	def _get_college(self, token):
		if self._college_exists(token):
			return College.objects.filter(token=token).first()
		return None

	def _get_college_questions(self, college):
		return [qset._get_qset_questions(qset.identifier, college.token) for qset in QuestionSet.objects.filter(college=college)]


	def _create_college(self, post):
		token = self._get_token()
		colg = College(name=post['name'], contact=post['contact'],
			email=post['email'], token=token)
		colg.save()
		return colg

	def _valid_question_data(self, post):
		if not isinstance(post['answer'], list):
			return False
		if post['type'] not in [typ for typ,label in QUESTION_TYPES]:
			return False
		return True
	def _create_question(self, post):
		question.save()
		ans_objs = [Answer(description=ans['description'], question=question) for ans in post['answer']]
		ans_set = Answer.objects.bulk_create(ans_objs)
		return (question, True)

	def _valid_question_set_data(self,identifier, post):
		if identifier is None and post['action']=='set_create':
			return True
		qset = QuestionSet.objects.filter(identifier=identifier)
		if qset.exists():
			if 'action' in post and (post['action']=='add' or post['action']=='remove') and (
				'questions' in post and len(post['questions'])>0):
				return True
			if 'action' not in post and ('questions' not in post or 'college' not in post):
				return True
			if 'action' in post and post['action'] == 'set_create':
				return True
			if ('action' in post and post['action']) and ('college_token' in post and post['college_token']):
				return True
			if 'name' in post and post['name'] == '':
				return False
			if 'time_limit' in post and post['time_limit'] == '':
				return False
		return False


	def _get_or_create_question_set(self, identifier, college=None, **kwargs):
		# use it when creating new question set via ajax post

		qset = QuestionSet.objects.filter(identifier=identifier, **kwargs)
		qset = qset.filter(college=college, **kwargs) if college else qset
		if qset.exists():
			return qset.first()

		new_set = QuestionSet(identifier=identifier, **kwargs)
		if college is not None:
			new_set = QuestionSet(identifier=identifier, college=college , **kwargs)
		new_set.save()
		return new_set
	def _create_questionset(self, post, **kwargs):
		identifier = self._get_token(limit=8)
		qset_dict = {key:value for key,value in post.items() if str(key) in [str(f.name) for f in QuestionSet._meta.get_fields()]}

		qset = self._get_or_create_question_set(identifier=identifier, **qset_dict)

		if 'questions' in post:
			qset = qset._update_question_set_questions(post)
		return (qset, True) 

	def _update_questionset(self, identifier, post, **kwargs):
		qset = self._get_or_create_question_set(identifier, **kwargs)
		qset_dict = {key:value for key,value in post.items() if str(key) in [str(f.name) for f in QuestionSet._meta.get_fields()] and str(key) != 'identifier'}
		print ('qset_dict {}\n'.format(qset_dict))
		if 'questions' in post:
			qset._update_question_set_questions(post)
		if 'college_token' in post:
			qset._update_question_set_questions(post, college_token=post['college_token'])

		for name,val in qset_dict.items(): setattr(qset,name,val)
		qset.save()
		return qset

	def _add_question_to_set(self, identifier, question):
		qset = QuestionSet.objects.get_or_create(identifier=identifier)
		if question.pk not in qset.question_arr:
			qset.question_arr = qset.question_arr.append(question.pk)
			return qset.save()
		return qset

	def _get_qset_questions(self, identifier, token):
		qset = self._get_or_create_question_set(identifier, college=self._get_college(token))
		return qset._get_all_questions()

	def _get_question(self, pk):
		q = Question.objects.filter(pk=pk)
		if q.exists():
			return q.first()
		return None


class BaseView(JsonMixin, View):

	@method_decorator(csrf_exempt)
	def dispatch(self, request, *args, **kwargs):
		# if not request.user.is_authenticated():
			# return self.return_json(response_403('User authentication required'))
		return super(BaseView, self).dispatch(request, *args, **kwargs)

class CollegeView(BaseView):

	model_class = College

	def get(self, request, token=None, *args, **kwargs):
		admin = AdminPortal(request)
		if token:
			colg = admin._get_college(token)

		return self.return_json(response([admin._get_college_questions(clg) for clg in College.objects.all() if clg]))

	def post(self, request, token=None, *args, **kwargs):
		post = json.loads(request.body)
		admin = AdminPortal(request)
		college = admin._create_college(post)
		return self.return_json(response_201('College Created', 'token', college.token))
college_view = CollegeView.as_view()

class QuestionView(BaseView):

	model_class = Question

	def get(self, request, *args, **kwargs):
		admin = AdminPortal(request)
		return self.return_json(response(admin._get_qset_questions()))

	def post(self, request, *args, **kwargs):
		post = json.loads(request.body)
		admin = AdminPortal(request)
		if admin._valid_question_data(post):
			question, created = admin._create_question(post)
			return self.return_json(response_201('Question is created', 'question_id', question.pk))
		return self.return_json(response_400('Invalid Question data'))

question_view = QuestionView.as_view()

class QuestionSetView(BaseView):

	model_class = QuestionSet

	def get(self, request, identifier=None, token=None, *args, **kwargs):
		admin = AdminPortal(request)
		print( 'kwargs {}\n'.format(self.kwargs))
		identifier = self.kwargs['identifier'] if 'identifier' in self.kwargs else None 
		token = self.kwargs['token'] if 'token' in self.kwargs else None
		if token:
			# return college qsets
			college = admin._get_college(token)
			return self.return_json(response(admin._get_qset_questions())) if college else self.return_json(response_400())
		if identifier:
			# return qsets
			qset = admin._get_or_create_question_set(identifier)
			return self.return_json(response(qset._get_all_questions()))
		
		return self.return_json(response_400('Identifier not set'))

	def post(self, request, identifier, token=None, *args, **kwargs):
		admin = AdminPortal(request)
		# identifier = self.kwargs['identifier'] if 'identifier' in self.kwargs else None
		# token = self.kwargs['token'] if 'token' in self.kwargs else None
		post = json.loads(request.body)
		if admin._valid_question_set_data(identifier,post):
			if identifier:
				# update qset details
				qset = admin._update_questionset(identifier, post)
				return self.return_json(response_200('Question Set updated'))
			if token and 'action' in post and post['action'] is not None:
				# update qset details for specific college token
				qset = admin._get_or_create_question_set(identifier, college = admin._get_college(token))
				qset_updated = qset._update_question_set_questions(self._get_question(), post, post['action'])
				return self.return_json(response(qset_updated._get_details()))
			
			qset, created = admin._create_questionset(post)
			return self.return_json(response_201('QuestionSet is created', 'question_set_id', qset.identifier))
		return self.return_json(response_400())

question_set_view = QuestionSetView.as_view()

		
