from flask import Flask
from flask_cors import CORS

import facility_dao as facility
import users_dao as users
import comments_dao as comments
import preference_dao as preference

app = Flask(__name__)
CORS(app, origins="*")


@app.route("/")
def index():
    return "Welcome My App"


# facility
app.add_url_rule("/facilities", view_func=facility.get_all_facility, methods=["GET"])
app.add_url_rule(
    "/facility/<int:facility_id>", view_func=facility.get_facility, methods=["GET"]
)

# users
app.add_url_rule("/users", view_func=users.register_user, methods=["POST"])
app.add_url_rule("/login", view_func=users.authenticate_user, methods=["POST"])

# comments
app.add_url_rule(
    "/comment/<int:facility_id>", view_func=comments.sel_com_fun, methods=["GET"]
)
app.add_url_rule("/comment", view_func=comments.ins_com_poc, methods=["POST"])
app.add_url_rule("/comment/<int:id>", view_func=comments.upd_com_poc, methods=["PUT"])
app.add_url_rule(
    "/comment/<int:id>", view_func=comments.del_com_poc, methods=["DELETE"]
)

# preference
# app.add_url_rule('/preference/<int:facility_id>', view_func=preference.sel_pre_poc, methods=['GET'])
app.add_url_rule(
    "/preferenceme/<int:facility_id>/<int:users_id>",
    view_func=preference.sel_pre_me_poc,
    methods=["GET"],
)
app.add_url_rule("/preference", view_func=preference.ins_pre_poc, methods=["POST"])
app.add_url_rule(
    "/preference/<int:id>", view_func=preference.upd_pre_poc, methods=["PUT"]
)


if __name__ == "__main__":
    app.run(debug=True)
