from flask import Blueprint, Response, render_template
import os

home = Blueprint('home', __name__, url_prefix='/home')

@home.route('/test')
def home_page():
	return render_template("register.html")