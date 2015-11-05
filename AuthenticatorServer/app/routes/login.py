from flask import Blueprint, Response, request, session
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
	redis_store.setex(username+":temp_key", str(code), 15)
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

@login.route('/page', methods=['GET', 'POST'])
def create_login_page():
	if request.method == 'GET':
		return "the page"

@login.route('/auth', methods=['POST'])
def authenticate():
	username = request.form.get('username')
	uuid = request.form.get('uuid')
	one_time_code = request.form.get('one_time_code')
	if not (username and uuid and one_time_code):
		return "ERROR - INVALID INFO"
	key = redis_store.get(username+":temp_key")
	correct_uuid = redis_store.hmget(username, "uuid")[0]
	print("username: {} uuid: {} one_time_code: {}".format(username, uuid, one_time_code))
	print("CORRECT uuid: {} key: {}".format(correct_uuid, key))
	if not(one_time_code and uuid) or key != one_time_code or uuid != correct_uuid:
		return "INCORRECT AUTH INFO"

	redis_store.setex(one_time_code, "valid", 30)
	return "valid login!"


@login.route('/get_cookie', methods=['POST'])
def get_cookie():
	one_time_code = request.form.get('one_time_code')
	username = request.form.get('username')
	valid = bool(redis_store.get(one_time_code)) and redis_store.get(username+":temp_key") == one_time_code
	if valid:
		session["logged_in"] = True
		session["username"] = username
		redis_store.set(username+":logged_in", True)
		return "successful login"
	return "failed"

@login.route('/test', methods=['GET'])
def is_logged_in():
	return str(session.get("logged_in") == True)

@login.route('/flush', methods=['GET'])
def clear_db():
	redis_store.flushall()
	return "done"

