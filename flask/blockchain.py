import json
import os

from web3 import eth as e, Web3, HTTPProvider
from web3.utils.encoding import to_int
from web3.middleware import geth_poa_middleware

__all__ = ("balance", "send_track", "get_track")


node1 = HTTPProvider("http://192.168.0.2:8501")
node2 = HTTPProvider("http://192.168.0.3:8502")

w3: Web3 = Web3(node1)
eth: e.Eth = w3.eth
precision = 1e6
w3.middleware_stack.inject(geth_poa_middleware, layer=0)
eth.defaultAccount = eth.accounts[0]


def read_abi():
    with open("static/abi.json") as f:
        a = json.load(f)
    return a


abi = read_abi()
contract_addr = os.environ["CONTRACT"]
contract_addr = w3.toChecksumAddress(contract_addr)


def get_contract(addr):
    return eth.contract(address=contract_addr, abi=abi)


contract = get_contract(contract_addr)


def balance(address):
    return eth.getBalance(w3.toChecksumAddress(address))


def send_track(address, track):
    address = w3.toChecksumAddress(address)
    calls = [
        contract.functions.store_trace(
            address,
            int(t["longitude"] * precision),
            int(t["latitude"] * precision),
            t["timestamp"]
        )
        for t in track
    ]
    for c in calls:
        c.transact()


def get_track(address):
    address = w3.toChecksumAddress(address)
    len = contract.functions.get_trace_length(address).call()
    return [
        dict(longitude=longitude / precision, latitude=latitude / precision, timestamp=timestamp)
        for longitude, latitude, timestamp in (
            contract.functions.get_trace_point(address, i).call()
            for i in range(len)
        )
    ]
