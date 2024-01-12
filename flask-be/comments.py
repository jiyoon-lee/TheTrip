from flask_restx import Namespace, Resource
import comments_dao as comments

ns = Namespace("comments", description="Comments operations")


@ns.route("/<int:facility_id>")
class GetComments(Resource):
    def get(self, facility_id):
        return comments.sel_com_fun(facility_id)


@ns.route("/")
class AddComment(Resource):
    def post(self):
        return comments.ins_com_poc()


@ns.route("/<int:id>")
class UpdateComment(Resource):
    def put(self, id):
        return comments.upd_com_poc(id)


@ns.route("/<int:id>")
class DeleteComment(Resource):
    def delete(self, id):
        return comments.del_com_poc(id)
