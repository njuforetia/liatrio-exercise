import datetime
import time
from flask import Flask

app = Flask(__name__)


@app.route('/')
def george_example():
       return({
                "timestamp": time.time(), 
                "message": "Automate all the things!"
            })
