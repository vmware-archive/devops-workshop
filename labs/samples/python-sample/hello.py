from flask import Flask
from flask import render_template as render
from flask import request
from flask import abort
import os

app = Flask(__name__)

# Port number is required to fetch from env variable
# http://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#PORT

cf_port = int(os.getenv("PORT"))

"""[summary]
    Most simple example web application.
[description]
    Most simple example web application for Flask on Cloud Foundry.
    You can access this with "http://<yourapp_url>/".
"""


@app.route('/')
def hello():
    return 'Hello World.'


"""[summary]
    Cloud Foundry app container environmental variables / HTTP request headers.
[description]
    Cloud Foundry app container environmental variables / HTTP request headers.
    You can access this with "http://<yourapp_url>/vars/".
"""


@app.route('/vars')
def showCFVariables():
    cf_var_dict = {}

    # Get all environment variables from the CF application container
    for k in os.environ:
        cf_var_dict[k] = os.getenv(k)

    # Get the HTTP request header
    headers = request.headers

    return render('index.html', cf_variables=cf_var_dict, http_headers=headers)


"""[summary]
    Source IP address restriction example.
[description]
    Source IP address access restriction on application level.
    You can access this with "http://<yourapp_url>/ip/".
    And allowed source IP can be configured with "allowed_ip" parameter.

    If you access from allowed IP, you can see the page with 200 OK response.
    If your access is denied, you will see 403 response.

    This uses X-Forwarded-For HTTP request header and restrict the access
    to app. If you want to use this to entire application, you can use
    before_request() decorator. For more details, please refer Flask
    official documentation.
    ( http://flask.pocoo.org/docs/0.10/api/#flask.Flask.before_request )
"""


@app.route('/ip')
def showIp():
    srcIp = request.access_route[0]
    allowed_ip = '192.0.2.1'

    # Please change the src IP you would like to allows
    if srcIp != allowed_ip:
        abort(403)

    return 'Your IP %s is allowed' % srcIp

if __name__ == '__main__':
    # Diego cells do not provide VCAP_APP_HOST
    # It is required to set as "0.0.0.0"
    # http://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html#VCAP-APP-HOST
    app.run(host='0.0.0.0', port=cf_port, debug=True)
