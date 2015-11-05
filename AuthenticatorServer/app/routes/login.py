from flask import Blueprint, Response, request
import os, string
from app import redis_store


login = Blueprint('login', __name__, url_prefix='/login')


@login.route('')
def test():
    return "Test this"


@login.route('/get_code', methods=['POST'])
def get_code():
	username = request.form.get('username')
	if not username:
		return "ERROR NO USERNAME"
	code_bytes = os.urandom(128)
	code = ''.join(map(lambda x: string.printable[ord(x)%len(string.printable)], code_bytes))
	redis_store.setex(username+":temp_key", "random_shit", 15)
	return str(code)

@login.route('/register', methods=['POST'])
def register():
	username = request.form.get('username')
	uuid = request.form.get('uuid')
	push_key = request.form.get('push_key')
	one_time_code = request.form.get('one_time_code')
	print("{} {} {} {}".format(username, uuid, push_key, one_time_code))

	if not (username and uuid and push_key and one_time_code):
		return "ERROR - INVALID INFO"
	key = redis_store.get(username+":temp_key")
	if key != one_time_code:
		print("KEY: {} ONE_TIME_CODE: {}".format(key, one_time_code))
		return "INCORRECT ONE TIME CODE"
	redis_store.hmset(username, {"uuid": uuid, "push_key":push_key})
	return "Great success!"



@login.route('/auth', methods=['POST'])
def authenticate():
	pass