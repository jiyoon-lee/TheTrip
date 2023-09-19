from flask import request, jsonify, make_response
import db_connection as db


def sel_pre_all_poc(facility_id):
    return


def sel_pre_me_poc(facility_id, users_id):
    connection = db.create_connection()
    cursor = connection.cursor()
    preference_cursor = cursor.callfunc(
        "preference_curd_package.sel_pre_me_fun", db.CURSOR, [facility_id, users_id]
    )
    data = []
    for row in preference_cursor:
        row_as_dict = {
            desc[0]: value for desc, value in zip(preference_cursor.description, row)
        }
        data.append(row_as_dict)
    return make_response(jsonify(data), 200)


def ins_pre_poc():
    connection = db.create_connection()
    cursor = connection.cursor()
    liked = request.json.get("liked")
    facility_id = request.json.get("facility_id")
    users_id = request.json.get("users_id")
    print(liked)
    print(facility_id)
    print(users_id)
    cursor.callproc(
        "preference_curd_package.ins_pre_poc", [liked, facility_id, users_id]
    )
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "Preference Added"}), 201)


def upd_pre_poc(id):
    connection = db.create_connection()
    cursor = connection.cursor()
    liked = request.json.get("liked")
    cursor.callproc("preference_curd_package.upd_pre_poc", [liked, id])
    connection.commit()
    return make_response(jsonify({"status": "ok", "data": "Preference Updated"}), 201)
