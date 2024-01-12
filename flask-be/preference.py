from flask import request
from flask_restx import Namespace, Resource
import preference_dao as preference

ns = Namespace("preference", description="Users operations")


@ns.route("/<int:facility_id>")
class GetAllPreference(Resource):
    def get(self, facility_id):
        return preference.sel_pre_all_poc(facility_id)


@ns.route("/me")
class GetPreferenceMe(Resource):
    def get(self):
        facility_id = request.args.get("facility_id")
        users_id = request.args.get("users_id")
        return preference.sel_pre_me_poc(facility_id, users_id)


@ns.route("/")
class AddPreference(Resource):
    def post(self):
        return preference.ins_pre_poc()


@ns.route("/<int:id>")
class UpdatePreference(Resource):
    def put(self, id):
        return preference.upd_pre_poc(id)
