# Student Response Models

response = lambda arr: {'status':True, 'status_code':200, 'results':arr}
response_obj = lambda obj: {'status':True, 'status_code':200, 'results':obj}
response_200 = lambda msg: {'status':True, 'status_code':200, 'message':'{}'.format(msg)}
response_400 = lambda msg: {'status':False, 'status_code':400, 'message':'Bad Request - {}'.format(msg)}
response_500 = {'status':False, 'status_code':500, 'message':'Internal Server Error'}

response_201 = lambda msg,key,value: {'status':True, 'status_code':201, 'message':'{}'.format(msg), key:value} if key else {'status_code':201, 'message':'{}'.format(msg)}
response_204 = lambda msg: {'status':True, 'status_code': 204, 'message':'{}'.format(msg) if msg else 'Updated'}
response_403 = lambda msg: {'status':False,  'status_code':403, 'message':'Forbidden Request - {}'.format(msg)}
response_412 = {'status':False,  'status_code':412, 'message':'Precondition Failed'}
response_417 = lambda s: {'status':False, 'status_code':417, 'message':'Expected Request header "{}" is not found'.format(s)}

stud_details = lambda stud, qset: {
				'name' :stud.name,
				'reg_no' :stud.reg_no,
				'department' :stud.department,
				'college_name' :stud.college_name,
				'gender' :stud.gender,
				'email' :stud.email,
				'phone' :stud.phone,
				'dob' :stud.dob,
				'token' :stud.token,
				'exam_started_at': stud.exam_started_at,
				'last_submitted_at' : stud.last_submitted_at,
				'time_limit': qset.time_limit,
				'time_left': stud.time_left
				}

questions = lambda q_set: {
'status':True,
'status_code': 200,
'results': [q._get_question() for q in q_set]

}