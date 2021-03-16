pragma solidity ^0.7.4;

contract HomeList
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
        RequestType requestType;
        Home home;
        uint result;
        address adr;
    }
    
    struct Employee
    {
        string name;
        string position;
        string phoneNumber;
        bool isEmployee;
    }
    
    mapping(string => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    function AddHome(string memory _adr, uint _area, uint _cost) public {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns (uint _area, uint _cost){
        return (homes[adr].area, homes[adr].cost);
    }
    
    function isEmployee(string memory _name) public returns(bool _isEmployee){
        return employees[_name].isEmployee;
    }
    
    function AddEmployee(string memory _name, string memory _position, string memory _phoneNumber) public {
        Employee memory e;
        e.name = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        e.isEmployee = true;
        employees[_name] = e;
    }
    
    function GetEmployee(string memory name) public returns (string memory _position, string memory _phoneNumber){
        return (employees[name].position, employees[name].phoneNumber);
    }
    
    function UpdateEmployee(string memory _searchName, string memory _newName, string memory _newPosition, string memory _newPhoneNumber) public {
       if(!isEmployee(_searchName)) revert();
       bytes memory lengthName = bytes(_newName);
       bytes memory lengthPosition = bytes(_newPosition);
       bytes memory lengthPhoneNumber = bytes(_newPhoneNumber);
       if(lengthName.length != 0) employees[_searchName].name = _newName;
       if(lengthPosition.length != 0) employees[_searchName].position = _newPosition;
       if(lengthPhoneNumber.length != 0) employees[_searchName].phoneNumber = _newPhoneNumber;
    }
}
