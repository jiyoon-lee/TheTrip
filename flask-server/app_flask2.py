from flask import Flask
from flask_restx import Api, Resource
from flask_cors import CORS


import facility_dao as facility
import users_dao as users
import comments_dao as comments
import preference_dao as preference

app = Flask(__name__)
CORS(app, origins="http://localhost:3000")


@app.route("/")
def index():
    return "Welcome My App"


api = Api(
    app,
    version="1.0",
    title="My App API",
    description="A simple My App API",
    doc="/api/",
)


# facility
@api.route("/facilities")
class GetAllFacility(Resource):
    def get(self):
        return facility.get_all_facility()


@api.route("/facility/<int:facility_id>")
class GetFacility(Resource):
    def get(self, facility_id):
        return facility.get_facility(facility_id)


# users
@api.route("/signup")
class RegisterUser(Resource):
    def post(self):
        return users.register_user()


@api.route("/login")
class AuthenticateUser(Resource):
    def post(self):
        return users.authenticate_user()


# comments
@api.route("/comment/<int:facility_id>")
class GetComments(Resource):
    def get(self, facility_id):
        return comments.sel_com_fun(facility_id)


@api.route("/comment")
class AddComment(Resource):
    def post(self):
        return comments.ins_com_poc()


@api.route("/comment/<int:id>")
class UpdateComment(Resource):
    def put(self, id):
        return comments.upd_com_poc(id)


@api.route("/comment/<int:id>")
class DeleteComment(Resource):
    def delete(self, id):
        return comments.del_com_poc(id)


# preference
# app.add_url_rule('/preference/<int:facility_id>', view_func=preference.sel_pre_poc, methods=['GET'])
@api.route("/preferenceme/<int:facility_id>/<int:users_id>")
class GetPreference(Resource):
    def get(self, facility_id, users_id):
        return preference.sel_pre_me_poc(facility_id, users_id)


@api.route("/preference")
class AddPreference(Resource):
    def post(self):
        return preference.ins_pre_poc()


@api.route("/preference/<int:id>")
class UpdatePreference(Resource):
    def put(self, id):
        return preference.upd_pre_poc(id)


if __name__ == "__main__":
    app.run(debug=True)
