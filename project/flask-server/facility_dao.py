from flask import jsonify, make_response
import db_connection as db


def get_all_facility(category, address):
    connection = db.create_connection()
    cursor = connection.cursor()
    facilities_cursor = cursor.callfunc(
        "facility_crud_package.sel_fac_fun", db.CURSOR, [category, address]
    )
    facilities = []
    for row in facilities_cursor:
        row_as_dict = {
            desc[0]: value for desc, value in zip(facilities_cursor.description, row)
        }
        facilities.append(row_as_dict)
    return make_response(jsonify(facilities), 200)


def get_facility(name):
    connection = db.create_connection()
    cursor = connection.cursor()
    facility_cursor = cursor.callfunc(
        "facility_info_crud_package.sel_fac_info_fun", db.CURSOR, [name]
    )
    facility = [
        dict(zip([column[0] for column in facility_cursor.description], row))
        for row in facility_cursor
    ]
    return make_response(jsonify(facility), 200)
