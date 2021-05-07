from web3 import Web3
import json


class Blockchain:
    # account_address  - 0x0D10b2c2a567CdEE28130AcefEe3Ce4B29A33E66
    # employee_address - 0x656c7A6b11351A10f4A2aa6E1d7fBAFCA6680aE7

    def __init__(self, account_address, contract_address):
        self.account_address = account_address
        self.contract_address = contract_address
        self.infura_url = 'https://ropsten.infura.io/v3/7fefe3f8f0764aa1abdf21bc3c1e4570'
        self.private_key = '6e880d6a2829c2172f17c035f36726e6da46cb51661c4e6b584af1795ea9edaf'
        self.w3 = Web3(Web3.HTTPProvider(self.infura_url))
        self.w3.eth.defaultAccount = account_address
        self.balance = self.w3.eth.getBalance(account_address)
        with open('app/rosreestr.abi') as f:
            self.abi = json.load(f)
        self.contract = self.w3.eth.contract(
            address=self.contract_address, abi=self.abi)
        self.nonce = self.w3.eth.getTransactionCount(self.account_address)

    def getBalance(self):
        return self.w3.fromWei(self.balance, 'ether')

    def sendTransaction(self, transaction):
        signed_tr = self.w3.eth.account.signTransaction(
            transaction, private_key=self.private_key)
        self.w3.eth.sendRawTransaction(signed_tr.rawTransaction)

    def getOwner(self):
        return self.contract.functions.GetOwner().call()

    def changeOwner(self, newOwner):
        transaction = self.contract.functions.ChangeOwner(newOwner).buildTransaction({
            'gas': 3000000,
            'gasPrice': self.w3.toWei('1', 'gwei'),
            'from': self.account_address,
            'nonce': self.nonce
        })
        self.sendTransaction(transaction)

    def addEmployee(self, emplAddr, name, position, phoneNumber):
        transaction = self.contract.functions.AddEmployee(emplAddr, name, position, phoneNumber).buildTransaction({
            'gas': 3000000,
            'gasPrice': self.w3.toWei('1', 'gwei'),
            'from': self.account_address,
            'nonce': self.nonce
        })
        self.sendTransaction(transaction)

    def getEmployee(self, emplAddr):
        return self.contract.functions.GetEmployee(emplAddr).call()

    def editEmployee(self, emplAddr, name, position, phoneNumber):
        transaction = self.contract.functions.EditEmployee(emplAddr, name, position, phoneNumber).buildTransaction({
            'gas': 3000000,
            'gasPrice': self.w3.toWei('1', 'gwei'),
            'from': self.account_address,
            'nonce': self.nonce
        })
        self.sendTransaction(transaction)

    def deleteEmployee(self, emplAddr):
        transaction = self.contract.functions.DeleteEmployee(emplAddr).buildTransaction({
            'gas': 3000000,
            'gasPrice': self.w3.toWei('1', 'gwei'),
            'from': self.account_address,
            'nonce': self.nonce
        })
        self.sendTransaction(transaction)

    def addHome(self, homeAddr, area, cost):
        transaction = self.contract.functions.AddHome(homeAddr, area, cost).buildTransaction({
            'gas': 3000000,
            'gasPrice': self.w3.toWei('1', 'gwei'),
            'from': self.account_address,
            'nonce': self.nonce
        })
        self.sendTransaction(transaction)
