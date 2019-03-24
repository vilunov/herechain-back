from flask import Flask, jsonify as j, request
from blockchain import *


app = Flask(__name__)


@app.route('/balance/<address>/')
def balance(address):
    return j({"address": address, "balance": balance(address)})


@app.route("/track/<address>/", methods=["GET", "POST"])
def track(address):
    if request.method == "GET":
        return j(get_track(address))
    elif request.method == "POST":
        data = request.json
        print(data)
        assert isinstance(data, list)
        for i in data:
            assert isinstance(i.get("timestamp"), int)
            assert isinstance(i.get("latitude"), float)
            assert isinstance(i.get("longitude"), float)
        send_track(address, data)
        return j("success")
    raise Exception("Invalid method")



if __name__ == '__main__':
    app.run()
