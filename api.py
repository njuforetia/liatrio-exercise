import datetime
import time
from flask import Flask

app = Flask(__name__)


@app.route('/')
def home():
    return({"msg": "Welcome home george! Go to '/posts' endpoint for the actual text result"})

@app.route('/posts')
def george_example():
       return({
                "author": "George Njuacha", 
                "project": "Liatrio", 
                "time": datetime.datetime.now(),
                "timestamp": time.time(), 
                "message": "Automate all the things!"
            })