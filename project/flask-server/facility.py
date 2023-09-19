from flask import request
from flask_restx import Namespace, Resource
import facility_dao as facility

ns = Namespace("facility", description="Facility operations")


@ns.route("/all")
class GetAllFacility(Resource):
    def get(self):
        category = request.args.get("category")
        address = request.args.get("address")
        return facility.get_all_facility(category, address)


@ns.route("/")
class GetFacility(Resource):
    def get(self):
        name = request.args.get("name")
        return facility.get_facility(name)
