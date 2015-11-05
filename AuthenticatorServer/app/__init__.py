from flask import Flask, g, session
from flask.ext.redis import FlaskRedis

redis_store = FlaskRedis()


app = Flask(__name__)
app.config.update(
    DEBUG=True,
    REDIS_URL = "redis://@localhost:6379/0"
)
redis_store.init_app(app)

from app.routes.login import login
from app.routes.home import home


app.register_blueprint(login)
app.register_blueprint(home)