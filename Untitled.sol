pragma solidity ^0.7.4;

contract Owned
{

	address payable private owner;

    constructor() public
    {
        owner = msg.sender;
    }

    modifier OnlyOwner
    {
        require(
            msg.sender == owner,
            'Only owner can do it'
            );
            _;
    }
    
    function ChangeOwner(address newOwner) public OnlyOwner
    {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address)
    {
        return owner;
    }
}

contract HomeList is Owned
{
    enum RequestType { NewHome, EditHome }
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint procent;
    }
    
    struct Owner
    {
        string name;
        uint passSer;
        uint passNum;
        uint date;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
        bool status;
    }
    
    struct Request
    {
        address new;
        RequestType requestType;
        Home home;
        uint result;
    }
    
    struct Employee
    {
        string name;
        string position;
        string phoneNumber;
        bool isEmployee;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;

    address[] requestInit;
    uint private fee = 1e12;
    
    modifier OnlyEmployee
    {
        require(
            employees[msg.sender].isEmployee != false,
            'Only Employee can do it'
            );
            _;
    }

    modifier Costs(uint value)
    {
    	require(
    		msg.value >= value,
    		'Not enough to buy'
    	);
    	_;
    }

    function ChangeFee(uint pFee) public OnlyOwner
    {
    	fee = pFee;
    }
    
    function NewHome(string memory pAdr, uint pArea, uint pCost) public OnlyEmployee
    {
        Home memory h;
        h.homeAddress = pAdr;
        h.area = pArea;
        h.cost = pCost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns (uint pArea, uint pCost)
    {
        return (homes[adr].area, homes[adr].cost);
    }

    function UpdateHome(string memory pAdr, uint pNewArea, uint pNewCost) OnlyEmployee public
    {
    	Home storage h = home[pAdr];
    	h.area = pNewArea;
    	h.cost = pNewCost;
    }
    
    function NewEmployee(address empl, string memory pName, string memory pPosition, string memory pPhoneNumber) public OnlyOwner
    {
        Employee memory e;
        e.name = pName;
        e.position = pPosition;
        e.phoneNumber = pPhoneNumber;
        e.isEmployee = true;
        employees[empl] = e;
    }
    
    function GetEmployee(address empl) public OnlyOwner returns (string memory pName, string memory pPosition, string memory pPhoneNumber)
    {
        return (employees[empl].name, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function UpdateEmployee(address empl, string memory pNewName, string memory pNewPosition, string memory pNewPhoneNumber) public OnlyOwner
    {
    	Employee storage e = employees[empl];
        if(employees[empl].isEmployee == true)
        {
 	       string memory empty = "";
 	       Employee storage e = employees[empl];
 	       if(bytes(_newName).length != bytes(empty).length) { e.name = pNewName; }
 	       if(bytes(_newPosition).length != bytes(empty).length) { e.position = pNewPosition; }
 	       if(bytes(_newPhoneNumber).length != bytes(empty).length) { e.phoneNumber = pNewPhoneNumber; }
        }
        else revert();
    }
    
    function RemoveEmployee(address empl) public OnlyOwner returns(bool)
    {
    	if(employees[empl].isEmployee == true)
    	{
        	delete employees[empl];
        	return true;
    	}
    	return false;
    }

     function AddHewHomeRequest(address request, string memory homeAddress, uint area, uint cost) public
     {
        Home memory h;
        Request memory r;

        h.homeAddress = homeAddress;
        h.area = area;
        h.cost = cost;

        r.new = rType == 0 ? address(0) : newOwner;
        req.requestType = rType == 0 ? RequestType.NewHome : RequestType.EditHome;
        req.home = h;
        req.result = false;
        requests[msg.sender] = r;
        requestInit.push(msg.sender);
    }

    function GetRequestList() public OnlyEmployee returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestInit.length);
        uint[] memory types = new uint[](requestInit.length);
        string[] memory homeAddresses = new string[](requestInit.length);
        for(uint i=0; i!=requestInit.length; i++)
        {
            ids[i] = i;
            types[i] = requests[requestInit[i]].requestType == RequestType.NewHome ? 0 : 1;
            homeAddresses[i] = requests[requestInit[i]].home.homeAddress;
        }
        return (ids, types, homeAddresses);
    }
}