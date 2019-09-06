from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods = ['GET'])
def fill_form1():
    return "Hello World!" + request.path

@app.route("/", methods = ['POST'])
def respond_to_request():
    return "Hello World!" + request.path



if __name__ == "__main__":
    app.run()