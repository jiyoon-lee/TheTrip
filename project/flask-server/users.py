from flask_restx import Namespace, Resource
import users_dao as users

ns = Namespace('sign', description='Users operations')
    
# users
@ns.route('/up')
class RegisterUser(Resource):
    def post(self):
        return users.register_user()

@ns.route('/in')
class AuthenticateUser(Resource):
    def post(self):
        return users.authenticate_user()