from flask import Blueprint, Response

home = Blueprint('home', __name__, url_prefix='/')


@home.route('/')
def home_page():
    return "This is the home page."
