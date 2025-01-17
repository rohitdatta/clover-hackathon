from flask import Blueprint, Response, render_template, session
import os
from app import redis_store

home = Blueprint('home', __name__, url_prefix='')

@home.route('/')
def home_page():
	return render_template("index.html")


@home.route('/logged_in', methods=['GET'])
def is_logged_in():
	print("{} {}".format(session.get('is_logged_in'), session.get('username')))
	return render_template("portal.html")

@home.route('/logout', methods=['GET'])
def clear_db():
	session['logged_in'] = None
	return home_page()
