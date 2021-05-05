pragma experimental ABIEncoderV2;
pragma solidity ^0.7.4;

contract Owned
{
    address payable private owner;

    constructor() public
    {
        owner = msg.sender;
    }

    modifier onlyOwner
    {
        require(
            msg.sender == owner,
            'Only owner can do it'
            );
            _;
    }
    
    function changeOwner(address payable newOwner) public onlyOwner
    {
        owner = newOwner;
    }
    
    function getOwner() public returns (address)
    {
        return owner;
    }
}

contract HomeList is Owned
{
    enum RequestType { NewHome, EditHome }
    enum OwnerOp { NewOwner, ChangeOwner, AddOwner }
    address[] requestInit;
    address[] ownerInit;
    string[] homeInit;
    uint private reqCount;
    uint private transactCost;

    constructor() public
    {
        transactCost = 100 wei;
    }

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
        string passDate;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
        bool isSet;
    }
    
    struct Request
    {
        RequestType requestType;
        string homeAddress;
        uint homeArea;
        uint homeCost;
        address adr;
    }
    
    struct Employee
    {
        string name;
        string position;
        string phoneNumber;
        bool isSet;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    modifier onlyEmployee
    {
        require(
            employees[msg.sender].isSet != false,
            'Only Employee can do it'
            );
            _;
    }

    modifier costs(uint value)
    {
        require(
            msg.value >= value,
            'Not enough to buy...'
        );
        _;
    }

    function addHome(string memory adr, uint area, uint cost) public onlyEmployee
    {
        Home memory h;
        h.homeAddress = adr;
        h.area = area;
        h.cost = cost;
        homes[adr] = h;
        homeInit.push(adr);
    }

    function getHome(string memory adr) public onlyEmployee returns (Home memory)
    {
        return homes[adr];
    }

    function getHomeList() public returns (Home[] memory homesList)
    {
        homesList = new Home[](homeInit.length);
        for(uint i = 0; i < homeInit.length; i++)
            homesList[i] = homes[homeInit[i]];
        return homesList;
    }

    function getOwnerList() public returns (Owner[] memory ownersList)
    {
        ownersList = new Owner[](ownerInit.length);
        for(uint i = 0; i < ownerInit.length; i++)
            ownersList[i] = owners[ownerInit[i]];
        return ownersList;
    }

    function addEmployee(address empl, string memory name, string memory position, string memory phoneNumber) public onlyOwner costs(transactCost) payable
    {
        Employee memory e;
        e.name = name;
        e.position = position;
        e.phoneNumber = phoneNumber;
        e.isSet = true;
        employees[empl] = e;
    }

    function getEmployee(address empl) public onlyOwner returns (string memory name, string memory position, string memory phoneNumber)
    {
        return (employees[empl].name, employees[empl].position, employees[empl].phoneNumber);
    }

    function editEmployee(address empl, string memory name, string memory position, string memory phoneNumber) public onlyOwner
    {
        employees[empl].name = name;
        employees[empl].position = position;
        employees[empl].phoneNumber = phoneNumber;
    }
    
    function deleteEmployee(address empl) public onlyOwner costs(transactCost) payable returns (bool)
    {
        if (employees[empl].isSet)
        {
            delete employees[empl];
            return true;
        }
        return false;
    }
    
    function addNewHomeRequest(string memory homeAddress, uint homeArea, uint32 homeCost) public costs(transactCost) payable returns (bool)
    {
        Request memory r;
        r.requestType = RequestType.NewHome;
        r.homeAddress = homeAddress;
        r.homeArea = homeArea;
        r.homeCost = homeCost;
        r.adr = address(0);
        requests[msg.sender] = r;
        requestInit.push(msg.sender);
        reqCount += msg.value;
        return true;
    }
    
    function addEditHomeRequest(string memory homeAddress, uint homeArea,  uint32 homeCost) public costs(transactCost) payable returns (bool)
    {
        Request memory r;
        r.requestType = RequestType.EditHome;
        r.homeAddress = homeAddress;
        r.homeArea = homeArea;
        r.homeCost = homeCost;
        r.adr = address(0);
        requests[msg.sender] = r;
        requestInit.push(msg.sender);
        reqCount += msg.value;
        return true;
    }
    
    function addOwnerRequest() public costs(transactCost) payable returns (bool) 
    {
        ownerInit.push(msg.sender);
        return true;
    }
    
    function getRequestList() public onlyEmployee returns (Request[] memory request)
    {
        request = new Request[](reqCount);
        for (uint _i = 0; _i < reqCount; _i++)
            request[_i] = requests[requestInit[_i]];
        return request;
    }
    
    function processRequest(uint id) public onlyEmployee costs(transactCost) payable returns (uint) 
    {
        if (id < 0 || id >= requestInit.length)
            return 1;
        Request memory r = requests[requestInit[id]];
        if (r.requestType == RequestType.NewHome && homes[r.homeAddress].isSet)
        {
            delete requests[requestInit[id]];
            delete requestInit[id];
            return 2;
        }
        if (r.requestType == RequestType.NewHome)
        {
            addHome(r.homeAddress, r.homeArea, r.homeCost);
            Ownership memory ownership;
            ownership.homeAddress = r.homeAddress;
            ownership.owner = requestInit[id];
            ownership.procent = 1;
            ownerships[r.homeAddress].push(ownership);
        } 
        if (r.requestType == RequestType.EditHome)
        {
            homes[r.homeAddress].area = r.homeArea;
            homes[r.homeAddress].cost = r.homeCost;
        }
        delete requests[requestInit[id]];
        delete requestInit[id];
        return 0;
    }
    
    function getPrice() public returns (uint price)
    {
        return transactCost;
    }
}