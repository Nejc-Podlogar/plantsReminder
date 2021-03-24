from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/registration', methods=['POST'])
def user_registration():

    ret = {}
    ret['test'] = 'test'

    return jsonify(ret)

@app.route('/login', methods=['POST'])
def user_login():
    ret = {}
    ret['test'] = 'test'

    return jsonify(ret)


if __name__ == "__main__":
    app.run("127.0.0.1", 5436, True)