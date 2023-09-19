from flask import request, jsonify, make_response
import db_connection as db


def register_user():
    connection = db.create_connection()
    cursor = connection.cursor()
    userid = request.json.get("userid")
    username = request.json.get("username")
    email = request.json.get("email")
    password = request.json.get("password")
    cursor.callproc(
        "users_crud_package.register_user", [userid, username, email, password]
    )
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "User Register"}), 201)


def authenticate_user():
    connection = db.create_connection()
    cursor = connection.cursor()
    userid = request.json.get("userid")
    password = request.json.get("password")
    user_cursor = cursor.callfunc(
        "users_crud_package.authenticate_user", db.CURSOR, [userid, password]
    )
    user = [
        dict(zip([column[0] for column in user_cursor.description], row))
        for row in user_cursor
    ]
    return make_response(jsonify(user), 201)
