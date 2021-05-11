from web3 import Web3
from flask import Flask, render_template, request
import json

app = Flask(__name__)

infura_url = 'https://ropsten.infura.io/v3/a9d9a6319c034ed4a25b63cfe3ad36e3'
address = '0x694Cf957B6f0667dA92DACB8A88cd9D8322c20E4'
contract_address = '0x8Bd20cCCC11647789215AfF32866cEf5942093cF'
private_key = 'f63a58d1eae986a845a9e160ae3028a68016d215c9202ac04ae47e502ae523ce'

w3 = Web3(Web3.HTTPProvider(infura_url))
w3.eth.defaultAccount = address
balance = w3.eth.getBalance(address)
print(w3.fromWei(balance, 'ether'))
with open('rosreestr.abi') as f:
    abi = json.load(f)
contract = w3.eth.contract(address=contract_address, abi=abi)
nonce = w3.eth.getTransactionCount(address)

@app.route('/')
def index():
    kt_tr = contract_address
    owner_tr = contract.functions.GetOwner().call()
    return render_template("index.html", res = owner_tr, kt_tr = kt_tr)

@app.route('/Employee')
def emp():
    return render_template("employee.html")

@app.route('/Home')
def home():
    return render_template("home.html")

@app.route('/Request')
def request():
    return render_template("request.html")

@app.route('/Cost')
def cost():
    cost_tr = contract.functions.GetCost().call()
    return render_template("cost.html", res = cost_tr)

@app.route('/AddEmployee', methods=['POST'])
def addEmployee():
    nonce = w3.eth.getTransactionCount(address)
    empl = request.form.get("empl")
    name = request.form.get("name")
    position = request.form.get("position")
    phonenumber = request.form.get("phonenumber")
    if (empl != "" and name != ""):
        empl_tr = contract.functions.AddEmployee(empl, name, position, phonenumber).buildTransaction({
            'gas': 3000000,
            'gasPrice': w3.toWei('0.1', 'gwei'),
            'from': address,
            'nonce': nonce,
        })
        addemp_tr = w3.eth.account.signTransaction(empl_tr, private_key=private_key)
        w3.eth.sendRawTransaction(addemp_tr.rawTransaction)
        return render_template("employee.html")

@app.route('/GetEmployee', methods=['POST'])
def getEmployee():
    empl = request.form.get("empl")
    res = (contract.functions.GetEmployee(empl).call())
    return render_template("employee.html", res = res)

@app.route('/EditEmployee', methods=['POST'])
def editEmployee():
    nonce = w3.eth.getTransactionCount(address)
    empl = request.form.get("empl")
    newname = request.form.get("newname")
    newposition = request.form.get("newposition")
    newphonenumber = request.form.get("newphonenumber")
    if (empl != ""):
        empl_tr = contract.functions.EditEmployee(empl, newname, newposition, newphonenumber).buildTransaction({
            'gas': 3000000,
            'gasPrice': w3.toWei('1', 'gwei'),
            'from': address,
            'nonce': nonce,
        })
        editemp_tr = w3.eth.account.signTransaction(empl_tr, private_key=private_key)
        w3.eth.sendRawTransaction(editemp_tr.rawTransaction)
        return render_template("employee.html")

@app.route('/AddHome', methods=['POST'])
def addHome():
    nonce = w3.eth.getTransactionCount(address)
    homeAddress = request.form.get("homeAddress")
    area = request.form.get("area")
    cost = request.form.get("cost")
    if (homeAddress != ""):
        home_tr = contract.functions.AddHome(homeAddress, int(area), int(cost)).buildTransaction({
            'gas': 3000000,
            'gasPrice': w3.toWei('1', 'gwei'),
            'from': address,
            'nonce': nonce,
        })
        signed_tr = w3.eth.account.signTransaction(home_tr, private_key=private_key)
        w3.eth.sendRawTransaction(signed_tr.rawTransaction)
        return render_template("home.html")

@app.route('/GetHome', methods=['POST'])
def getHome():
    homeAddress = request.form.get("homeAddress")
    res = (contract.functions.GetHome(homeAddress).call())
    return render_template("home.html", homeAddress = homeAddress, res = res)

@app.route('/EditCost', methods=['POST'])
def editCost():
    nonce = w3.eth.getTransactionCount(address)
    newCost = request.form.get("newCost")
    if (newCost != ""):
        home_tr = contract.functions.NewCost(int(newCost)).buildTransaction({
            'gas': 3000000,
            'gasPrice': w3.toWei('1', 'gwei'),
            'from': address,
            'nonce': nonce,
        })
        cost_tr = w3.eth.account.signTransaction(home_tr, private_key=private_key)
        w3.eth.sendRawTransaction(cost_tr.rawTransaction)
        return render_template("cost.html")

@app.route('/AddRequest', methods=['POST'])
def addrequest():
    nonce = w3.eth.getTransactionCount(address)
    rType = request.form.get("rType")
    homeAddress = request.form.get("homeAddress")
    area = request.form.get("area")
    cost = request.form.get("cost")
    newOwner = request.form.get("newOwner")
    addreq_tr = contract.functions.AddRequest(int(rType), str(homeAddress), int(area), int(cost), newOwner).buildTransaction({
        'gas': 3000000,
        'gasPrice': w3.toWei('1', 'gwei'),
        'from': address,
        'nonce': nonce,
        'value': w3.toWei('100', 'wei'),
    })
    req_tr = w3.eth.account.signTransaction(addreq_tr, private_key=private_key)
    w3.eth.sendRawTransaction(req_tr.rawTransaction)
    return render_template("request.html")   

@app.route('/GetRequest', methods=['POST'])
def getRequest():
    res = contract.functions.GetRequest().call()
    return render_template("request.html", res = res)

@app.route('/GetListHome', methods=['POST'])
def getlisthome():
    res = contract.functions.GetListHome().call()
    return render_template("home.html", result = res)

@app.route('/ProcessRequest', methods=['POST'])
def processreq():
    nonce = w3.eth.getTransactionCount(address)
    idk = request.form.get("idk")
    procreq_tr = contract.functions.ProcessRequest(int(idk)).buildTransaction({
        'gas': 3000000,
        'gasPrice': w3.toWei('1', 'gwei'),
        'from': address,
        'nonce': nonce,
    })
    req_tr = w3.eth.account.signTransaction(procreq_tr, private_key=private_key)
    w3.eth.sendRawTransaction(req_tr.rawTransaction)
    return render_template("request.html")


if __name__ == "__main__":
    app.run(debug=True)