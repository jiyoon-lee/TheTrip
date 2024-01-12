from flask import request, jsonify, make_response
import db_connection as db


def sel_com_fun(facility_id):
    connection = db.create_connection()
    cursor = connection.cursor()
    comment_cursor = cursor.callfunc(
        "comments_curd_package.sel_com_fun", db.CURSOR, [facility_id]
    )
    comment = []
    for row in comment_cursor:
        row_as_dict = {
            desc[0]: value for desc, value in zip(comment_cursor.description, row)
        }
        comment.append(row_as_dict)
    return make_response(jsonify({"status": "ok", "data": comment}), 200)


def ins_com_poc():
    connection = db.create_connection()
    cursor = connection.cursor()
    content = request.json.get("content")
    createdby = request.json.get("createdby")
    facility_id = request.json.get("facility_id")
    users_id = request.json.get("users_id")
    cursor.callproc(
        "comments_curd_package.ins_com_poc", [content, createdby, facility_id, users_id]
    )
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "Comment Added"}), 201)


def upd_com_poc(id):
    connection = db.create_connection()
    cursor = connection.cursor()
    content = request.json.get("content")
    cursor.callproc("comments_curd_package.upd_com_poc", [content, id])
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "Comment Updated"}), 201)


def del_com_poc(id):
    connection = db.create_connection()
    cursor = connection.cursor()
    cursor.callproc("comments_curd_package.del_com_poc", [id])
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "Comment Delete"}), 201)


def test_com_poc():
    connection = db.create_connection()
    cursor = connection.cursor()
    print(request.json)
    connection.commit()
