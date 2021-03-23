pragma solidity ^0.7.4;

contract Owned
{
    constructor()
    {
        owner = msg.sender;
    }
    address private owner;
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
        Home home;
        address owner;
        uint procent;
    }
    
    struct Owner
    {
        string name;
        uint passSer;
        uint passNum;
        uint256 date;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        address owner;
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
    mapping(uint => Request) private requests;
    
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;

    uint requestCount = 0;
    
    modifier OnlyEmployee
    {
        require(
            employees[msg.sender].isEmployee != false,
            'Only Employee can do it'
            );
            _;
    }
    
    function AddHome(string memory _adr, uint _area, uint _cost) public OnlyEmployee
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public OnlyEmployee returns (uint _area, uint _cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }
    
    function isEmployee(address empl) private returns(bool _isEmployee)
    {
        return employees[empl].isEmployee;
    }
    
    function AddEmployee(address empl, string memory _name, string memory _position, string memory _phoneNumber) public OnlyOwner
    {
        Employee memory e;
        e.name = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        e.isEmployee = true;
        employees[empl] = e;
    }
    
    function GetEmployee(address empl) public OnlyOwner returns (string memory _name, string memory _position, string memory _phoneNumber)
    {
        return (employees[empl].name, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function UpdateEmployee(address empl, string memory _newName, string memory _newPosition, string memory _newPhoneNumber) public OnlyOwner
    {
        if(!isEmployee(empl)) revert();
        string memory empty = "";
        Employee storage e = employees[empl];
        if(bytes(_newName).length != bytes(empty).length) { e.name = _newName; }
        if(bytes(_newPosition).length != bytes(empty).length) { e.position = _newPosition; }
        if(bytes(_newPhoneNumber).length != bytes(empty).length) { e.phoneNumber = _newPhoneNumber; }
    }
    
    function RemoveEmployee(address empl) public OnlyOwner
    {
        delete employees[empl];
    }

     function AddHewHomeRequest(address request, string memory homeAddress, uint area, uint cost) public
     {
        Home memory h;
        Request memory r;

        h.homeAddress = homeAddress;
        h.area = area;
        h.cost = cost;

        r.new = req;
        req.requestType = RequestType.NewHome;
        req.home = h;
        req.result = 0;
        requests[requestCount] = r;
        requestCount++;
    }

    function GetRequestsList() public OnlyEmployee view returns (Request[] memory request)
    {
        request = new Request[](requestCount);
        for (uint i = 0; i < requestCount; i++)
            request[i] = requests[i];
        return request;
    }
}