from flask import Flask
from flask_restx import Api
from flask_cors import CORS

import facility
import users
import comments
import preference

app = Flask(__name__)
# CORS(app, origins="*")
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)


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

# Add the namespaces
api.add_namespace(facility.ns)
api.add_namespace(users.ns)
api.add_namespace(comments.ns)
api.add_namespace(preference.ns)

if __name__ == "__main__":
    app.run(debug=True)
