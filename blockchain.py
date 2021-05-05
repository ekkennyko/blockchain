from web3 import Web3
import json

infura_url = 'https://ropsten.infura.io/v3/7fefe3f8f0764aa1abdf21bc3c1e4570'
address = '0x0D10b2c2a567CdEE28130AcefEe3Ce4B29A33E66'
contract_address = '0x109D6da25d444698036A07D4b418dFFfaC424CE2'
private_key = '6e880d6a2829c2172f17c035f36726e6da46cb51661c4e6b584af1795ea9edaf'

w3 = Web3(Web3.HTTPProvider(infura_url))
w3.eth.defaultAccount = address
balance = w3.eth.getBalance(address)
print(w3.fromWei(balance, 'ether'))

with open('homelist.abi') as f:
    abi = json.load(f)

contract = w3.eth.contract(address=contract_address, abi=abi)

print(contract.functions.GetOwner().call())

nonce = w3.eth.getTransactionCount(address)

empl_tr = contract.functions.AddEmployee('0x656c7A6b11351A10f4A2aa6E1d7fBAFCA6680aE7', 'Nelbisoff Aysen', 'SysAdmin', '+79241231231').buildTransaction({
    'gas': 3000000,
    'gasPrice': w3.toWei('1', 'wei'),
    'from': address,
    'nonce': nonce,
})
signed_tr = w3.eth.account.signTransaction(empl_tr, private_key=private_key)
w3.eth.sendRawTransaction(signed_tr.rawTransaction)

print(contract.functions.GetEmployee(
    '0x656c7A6b11351A10f4A2aa6E1d7fBAFCA6680aE7').call())
