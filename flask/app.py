from flask import Flask, jsonify as j, request
from blockchain import *


app = Flask(__name__)


@app.route('/balance/<address>/')
def balance(address):
    return j({"address": address, "balance": balance(address)})


@app.route("/track/<address>/", methods=["POST"])
def track(address):
    assert request.method == "POST"
    data = request.json
    assert isinstance(data, list)
    for i in data:
        assert isinstance(i.get("timestamp"), int)
        assert isinstance(i.get("latitude"), float)
        assert isinstance(i.get("longitude"), float)
    send_track(address, data)
    return "succses", 200



if __name__ == '__main__':
    app.run()
