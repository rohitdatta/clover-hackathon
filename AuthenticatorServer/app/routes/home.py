from flask import Blueprint, Response, render_template, session
import os

home = Blueprint('home', __name__, url_prefix='/home')

@home.route('/test')
def home_page():
	if session.get('username'):
		return render_template("login.html")
	return render_template("register.html")