from flask import Flask, request, jsonify
from flask_cors import CORS
from MariaDB_Base import MariaDB_Base
from werkzeug.serving import WSGIRequestHandler

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

@app.route('/allUserPlants', methods=['POST'])
def all_user_plants():
    ret = {}
    try:
        content = request.get_json()
        print('content: {}'.format(content))
        row_guid = content['row_guid']

        if (row_guid is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.allUserPlants(row_guid)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)

@app.route('/allPlants', methods=['POST'])
def all_plants():
    ret = {}
    try:
        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.allPlants()

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


@app.route('/newUserPlant', methods=['POST'])
def newUserPlant():
    ret = {}
    try:
        content = request.get_json()
        row_guid = content['row_guid']
        plant_id = content['plant_id']

        if (row_guid is None or plant_id is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.newUserPlant(row_guid, plant_id)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


@app.route('/updateLastWatering', methods=['POST'])
def updateLastWatering():
    ret = {}
    try:
        content = request.get_json()
        id = content['id']

        if (id is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.updateLastWatering(id)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)



@app.route('/getProfileInfo', methods=['POST'])
def getProfileInfo():
    ret = {}
    try:
        content = request.get_json()
        row_guid = content['row_guid']

        if (row_guid is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.getProfileInfo(row_guid)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


@app.route('/deleteUserPlant', methods=['POST'])
def deleteUserPlant():
    ret = {}
    try:
        content = request.get_json()
        id = content['id']

        if (id is None):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.deleteUserPlant(id)

        base.close_connection()

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


@app.route('/changePassword', methods=['POST'])
def change_password():
    ret = {}
    try:
        content = request.get_json()
        old_password = content['old_password']
        new_password= content['new_password']
        confirm_password= content['confirm_password']
        row_guid= content['row_guid']

        if (old_password is None or new_password is None or confirm_password is None or row_guid is None):
            ret['success'] = False
            return jsonify(ret)

        if (new_password != confirm_password):
            ret['success'] = False
            return jsonify(ret)

        if (base.connect_to_database() is False):
            ret['success'] = False
            return jsonify(ret)

        ret = base.change_password(old_password, new_password, row_guid)

        return jsonify(ret)

    except Exception as e:
        print(e)
        ret['success'] = False
        return jsonify(ret)


if __name__ == "__main__":
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    #app.run("192.168.1.194", 5436, True)
    app.run("127.0.0.1", 5436, True)