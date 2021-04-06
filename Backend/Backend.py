from flask import Flask, request, jsonify
from flask_cors import CORS
from MariaDB_Base import MariaDB_Base

app = Flask(__name__)
CORS(app)

base = MariaDB_Base()

@app.route('/registration', methods=['POST'])
def user_registration():
    ret = {}
    try:

        content = request.get_json()
        username = content['username']
        email = content['email']
        password = content['password']

        if (username is None or email is None or password is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.register(email, username, password)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


@app.route('/login', methods=['POST'])
def user_login():
    ret = {}
    try:
        content = request.get_json()
        username = content['username']
        password = content['password']

        if (username is None or password is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.login(username, password)

        base.close_connection()

        return jsonify(ret)
    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)

@app.route('/allUserPlants', methods=['GET'])
def all_user_plants():
    ret = {}
    try:
        content = request.get_json()
        username = content['username']

        if (username is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.allUserPlants(username)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)

@app.route('/allPlants', methods=['GET'])
def all_plants():
    ret = {}
    try:
        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.allPlants(username)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


if __name__ == "__main__":
    app.run("127.0.0.1", 5436, True)