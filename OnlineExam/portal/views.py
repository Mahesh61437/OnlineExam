from django.shortcuts import render

# Create your views here.
from django.http import JsonResponse

import json
import pytz
import dateutil.parser
import datetime
from django.views import View
# local imports
from .models import Student
from .models import StudentAnswer

from admin_portal.models import Question
from admin_portal.models import QuestionSet
from admin_portal.models import Answer
from admin_portal.models import College


from django.conf import settings

from . import responses
# to be removed
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator


class JsonMixin(object):
	def get_data(self, context):
		return context

	def return_json(self, context, *args, **kwargs):
		return JsonResponse(self.get_data(context, *args, **kwargs))


class Portal(JsonMixin):
	def __init__(self, request):
		super(Portal, self).__init__()
		self.request = request
		self.resuming_exam = False
		if 'HTTP_RESUME_EXAM' in request.META:
			self.resuming_exam = True if request.META['HTTP_RESUME_EXAM'] == 'true' else False

	def _valid_exam(self, college_token, identifier,student_token):
		colg = College.objects.filter(token=college_token)
		valid_exam = True if colg.exists() else False
		qset = QuestionSet.objects.filter(identifier=identifier)
		valid_exam = True if valid_exam and colg.exists and qset.filter(college=colg) else False
		student = Student.objects.filter(token=student_token)
		valid_exam = True if valid_exam and colg.exists() and student.filter(college=colg.first()) else False
		return valid_exam
		# colg = colg.filter(question_set=qset.first()) if qset.exists() else colg
		# student = student.filter(student_token=student_token) if colg.exists
		# student = student.filter(question_set=qset.first()) if qset.exists() else student
		# return True if colg.exists() and qset.exists() and student.exists() else False

	def _valid_registration(self, college_token, identifier):
		reg_qset = QuestionSet.objects.filter(identifier=identifier)
		true_qset = True if reg_qset.exists() else False
		reg_colg = College.objects.filter(token=college_token)
		return True if true_qset and reg_qset.filter(college=reg_colg.first()).exists() else False

	def _valid_registration_data(self, post):
		post_keys = ['name','reg_no','college','department','gender','email','phone','dob'] if not self.resuming_exam else ['reg_no']
		valid_post = True
		for k,v in post.items(): valid_post = False if k not in post_keys else True
		return valid_post

	def _valid_user_answers(self, post):
		valid_data = False
		if 'results' in post and isinstance(post['results'], list) and 'time_remaining' in post:
			for dat in post['results']: valid_data = True if 'user_answer' and 'id' in dat else False 
		return valid_data

	def _check_and_get_registered_stud(self, post, college_token, identifier):
		result_tup = (None, False)
		if ((self._valid_registration(college_token, identifier) and self._valid_registration_data(post)) or 
			(self._valid_registration(college_token, identifier) and self.resuming_exam)):
			student = Student.objects.filter(college=College.objects.get(token=college_token), reg_no=post['reg_no'])
			qset = QuestionSet.objects.get(identifier=identifier, college=College.objects.get(token=college_token))
			if self.resuming_exam and student.exists():

				# if resuming time is less than the assigned time limit then save the additional log mins to the timer
				# if the login time exceeds the assigned time limit so setting the left mins to 0
				student.update(time_left=self._get_time_left(student.first(),time_remaining = None ))
				
				# Student.objects.filter(pk=student.first().pk).update(time_left=self._get_time_left(student.first()))
			return (student.first(), True) if student.exists() else result_tup
		return result_tup

	def _get_exam_details(self, college_token, identifier, student_token):
		colg = College.objects.get(token=college_token)
		qset = QuestionSet.objects.get(identifier=identifier, college=colg)
		student = Student.objects.get(token=student_token, college=colg)
		return student._get_questions(qset)
		# variable will be removed after debug
		# resp = (colg.first() if college.exists else None, qset.first() if qset.exists() else None, 
		# 	student.first() if student.exists() else None)
		# return resp

	def _get_request_time(self):
		return datetime.datetime.now(pytz.timezone(settings.TIME_ZONE))

	def _get_time_left(self, student, time_remaining=None):

		# if student.time_left < time_remaining:
			# return student.time_left
		if self.resuming_exam and time_remaining is None:
			# on resuming the exam calculate the additional mins for the student
			# calculating the difference in mins between resuming time and exam_started time
			delta = self._get_request_time() - student.exam_started_at
			# print 'delta seconds ', (delta.total_seconds() % 3600) / 60
			print ('delta mins', (delta.seconds%3600)//60)
			print ('delta seconds ', delta.seconds % 60)
			# print 'delta_mins ', '{}.{}'.format((delta.total_seconds() % 3600)//60, delta.seconds % 60)
			delta_mins = float('{}.{}'.format((delta.seconds%3600)//60, delta.seconds % 60))
			# if resuming time is less than the assigned time limit then return the additional log mins to the timer
			# else return 0 (which indicates that the user have no mins left)
			return (student.time_left - delta_mins) if (student.time_left - delta_mins) >= 0 else 0
		else:
			# return difference between the left time for the student and submiited value (both floats)
			diff = student.time_left - (student.time_left - time_remaining)
			return diff if not int(diff) == 0 else 0


	def _get_dob(self, date_string):
		try:
			# return datetime.datetime.strptime(date_string, "%Y-%m-%d").date()
			return dateutil.parser.parse(date_string)
		except ValueError as e:
			return None

	def _get_token(self, student=None):
		import base64
		import hashlib
		import random
		token = base64.b64encode(hashlib.sha256(str(random.getrandbits(256))).digest(),
			random.choice(['rA', 'aZ', 'gQ', 'hH', 'hG', 'aR', 'DD']).encode('utf8')).rstrip('==')
		if student:
			return student.token
		return token

	def _get_identifier(self):
		import base64
		import hashlib
		import random
		return base64.b64encode(hashlib.sha256(str(random.getrandbits(256))).digest(),
			random.choice(['rA', 'aZ', 'gQ', 'hH', 'hG', 'aR', 'DD']).encode('utf8')).rstrip('==')[:8]

	def _get_college(self, college_token):
		if college_token:
			clg = College.objects.filter(token=college_token)
			return clg.first() if clg.exists() and QuestionSet.objects.filter(college=clg.first()) else None
		return None


	def _register_or_get_student(self, post, college_token, identifier):
		student, registered = self._check_and_get_registered_stud(post, college_token, identifier)
		qset = QuestionSet.objects.get(identifier=identifier)
		if registered:
			return (student, qset)
		college = self._get_college(college_token)
		if college and not self.resuming_exam:
			student = Student(name=post['name'],reg_no=post['reg_no'],department=post['department'],
				college_name=post['college'], gender=post['gender'],email=post['email'],phone=str(post['phone']),
				dob=self._get_dob(post['dob']),token=self._get_token(),college=college,
				exam_started_at=self._get_request_time(), time_left = qset.time_limit)
			student.save()
			return (student, qset)
		return (None, None)


	def _updated_user_answers(self, post, student_token, identifier):
		student = self._get_student(student_token)
		qset = QuestionSet.objects.get(identifier=identifier)
		stud_ans = StudentAnswer.objects.filter(student=student)
		for objec in post['results']:
			ques = Question.objects.get(pk=objec['id'])
			stud_ans = stud_ans.filter(student=student, question=ques, question_set=qset)
			if not stud_ans.exists():
				stud_answ, created = StudentAnswer.objects.update_or_create(student=student, question=ques, question_set=qset)
				stud_answ.description = [str(i.decode('utf-8').strip()) for i in objec['user_answer']]  if isinstance(objec['user_answer'], list) else objec['user_answer'] if objec['user_answer'] is not None else None
				stud_answ.submitted_at=self._get_request_time() if objec['user_answer'] is not None else None
				stud_answ.save()
				# submitted_at=self._get_request_time() if stud_ans.first() is None and objec['user_answer'] is not None else self._get_request_time() if (stud_ans.first().submitted_at is None and stud_ans.first().description is None and objec['user_answer'] is not None) else stud_ans.first().submitted_at)

			# stud_ans.update(submitted_at=self._get_request_time() if objec['user_answer'] is not None and stud_ans.first() is None else stud_ans.first().submitted_at if stud_ans.first() else None)
			stud_ans.update(
				description=[str(i.decode('utf-8').strip()) for i in objec['user_answer']]  if isinstance(objec['user_answer'], list) else objec['user_answer'] if objec['user_answer'] is not None else None, 
				submitted_at=stud_ans.first().submitted_at if stud_ans.first() and objec['user_answer']==stud_ans.first().description else self._get_request_time() if stud_ans.first() and objec['user_answer'] is not None else None
				)
			# stud_ans.update(description=objec['user_answer'] if objec['user_answer'] is not None else stud_ans.first().description if stud_ans.first() else None,
			# 	submitted_at=self._get_request_time() if objec['user_answer'] is not None and stud_ans.first() is None else stud_ans.first().submitted_at if stud_ans.first() else None)

				# )
		Student.objects.filter(pk=student.pk).update(last_submitted_at = self._get_request_time(), time_left=self._get_time_left(student,time_remaining = float(post['time_remaining'])))
		return True


		# return self.return_json(response_400('Invalid user answer data'))

	def _get_student(self, stud_token):
		student = Student.objects.filter(token=stud_token)
		return student.first() if student.exists() else None

	def _get_student_details(self, stud_token):
		stud = Student.objects.filter(token=stud_token)
		if stud.exists():
			return {'questions':stud.first()._get_questions()}
		return None




class BaseView(JsonMixin, View):

	@method_decorator(csrf_exempt)
	def dispatch(self, request, *args, **kwargs):
		# if 'token' not in request.META:
		# 	return self.return_json(response_417('token'))
		return super(BaseView, self).dispatch(request, *args, **kwargs)

class RegisterView(BaseView):

	def get(self, request, college_token, identifier, *args, **kwargs):
		portal = Portal(request)
		if portal._valid_registration(college_token, identifier):
			return self.return_json(response_200('OK'))
		return self.return_json(response_400('Invalid Registration'))

	def post(self, request, college_token, identifier, *args, **kwargs):
		post = json.loads(request.body)
		portal = Portal(request)
		if portal._valid_registration(college_token, identifier) and portal._valid_registration_data(post):
			student, qset = portal._register_or_get_student(post, college_token, identifier)
			return self.return_json(response(stud_details(student, qset))) if student and qset else self.return_json(response_400('Invalid Student'))
		return self.return_json(response_400('Invalid Registration'))
register_view = RegisterView.as_view()

class ExamView(BaseView):

	def get(self, request, college_token, identifier,student_token, *args, **kwargs):
		portal = Portal(request)
		if portal._valid_exam(college_token, identifier, student_token):
			data = portal._get_exam_details(college_token, identifier, student_token)
			return self.return_json(response(data))
			# student_details = stud_details()
			# questions = portal._get_student(student_token)
		return self.return_json(response_400('Invalid Exam'))

	def post(self, request, college_token, identifier,student_token, *args, **kwargs):
		portal = Portal(request)
		post = json.loads(request.body.decode("utf-8"))
		if portal._valid_exam(college_token, identifier, student_token) and portal._valid_user_answers(post):
			updated = portal._updated_user_answers(post, student_token, identifier)
			return  self.return_json(response_204('Answers Updated'))
		return self.return_json(response_400('Invalid Exam or Data'))

exam_view = ExamView.as_view()



