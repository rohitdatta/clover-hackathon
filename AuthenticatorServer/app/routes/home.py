from flask import Blueprint, Response, render_template, session
import os
from app import redis_store

home = Blueprint('home', __name__, url_prefix='')

@home.route('/')
def home_page():
	if session.get('username'):
		return render_template("login.html")
	return render_template("register.html")


@home.route('/logged_in', methods=['GET'])
def is_logged_in():
	print("{} {}".format(session.get('is_logged_in'), session.get('username')))
	return render_template("portal.html")

@home.route('/logout', methods=['GET'])
def clear_db():
	redis_store.flushall()
	return render_template("register.html")