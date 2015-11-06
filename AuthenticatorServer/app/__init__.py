from flask import Flask, g, session
from flask.ext.redis import FlaskRedis

redis_store = FlaskRedis()
#login_manager = LoginManager()

app = Flask(__name__)
app.config.update(
    DEBUG=True,
    REDIS_URL = "redis://@localhost:6379/0",
    SECRET_KEY="super encrypted stuff"
)
redis_store.init_app(app)
#login_manager.init_app(app)

"""
@login_manager.user_loader
def load_user(user_id):
    return redis_store.hmget(user_id, "uuid")
"""
from app.routes.login import login
from app.routes.home import home
app.register_blueprint(login)
app.register_blueprint(home)


