from flask import Blueprint, Response, request, session, url_for, redirect, render_template
import os, string, time
from app import redis_store
from app.notification import send_notification
from app import app
import random

login = Blueprint('login', __name__, url_prefix='/login')

@login.route('')
def login_page():
	if session.get('username'):
		return render_template("login.html")
	return render_template("register.html")

@login.route('/get_code')
def get_code():
	username = session.get("username")
	if username:
		if not redis_store.get(username+":pinged"):
			token_hex = redis_store.hmget(username, "push_key")[0]
			redis_store.setex(username+":pinged", True, 60)
			random_str = str(random.randint(1, 100000000)) #''.join([x % 10 for x in os.urandom(8)])
			send_notification(token_hex, random_str)
			redis_store.setex(username+":temp_key", random_str, 30)

			return random_str

	code_bytes = os.urandom(128)
	code = ''.join(map(lambda x: string.ascii_letters[ord(x)%len(string.ascii_letters)], code_bytes))
	if username:
		redis_store.setex(username+":temp_key", str(code), 30)
	else:
		redis_store.setex(code, False, 30)

	return str(code)


@login.route('/get_cookie', methods=['POST'])
def get_cookie():
	one_time_code = request.form.get('one_time_code')
	valid = redis_store.get(one_time_code)
	if valid and redis_store.hget(valid, "uuid"):
		session["logged_in"] = True
		session["username"] = valid
		redis_store.set(valid+":logged_in", True)
		return "successful login"
	return "failed"




#MOBILE ENDPOINTS

@login.route('/register', methods=['POST'])
def register():
	username = request.form.get('username')
	uuid = request.form.get('uuid')
	push_key = request.form.get('push_key')
	one_time_code = request.form.get('one_time_code')
	print("{} {} {} {}".format(username, uuid, push_key, one_time_code))

	if not (username and uuid and push_key and one_time_code):
		return "ERROR - INVALID INFO"
	key = redis_store.get(one_time_code)
	if not one_time_code:
		return "INCORRECT ONE TIME CODE"
	redis_store.hmset(username, {"uuid": uuid, "push_key":push_key})
	redis_store.setex(one_time_code, username, 60)

	return "Great success!"

@login.route('/auth', methods=['POST'])
def authenticate():
	username = request.form.get('username')
	uuid = request.form.get('uuid')
	one_time_code = request.form.get('one_time_code')

	if not (username and uuid and one_time_code):
		return "ERROR - INVALID INFO"
	key = redis_store.get(username+":temp_key")
	correct_uuid = redis_store.hmget(username, "uuid")[0]
	if not(one_time_code and uuid) or uuid != correct_uuid or (key != one_time_code):
		return "INCORRECT AUTH INFO"

	redis_store.setex(one_time_code, username, 30)
	return "valid login!"


