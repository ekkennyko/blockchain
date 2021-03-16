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
        uint id;
        string name;
        string position;
        string phoneNumber;
        bool isEmployee;
    }
    
    mapping(uint => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    uint countIDEmployees = 0;
    
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
    
    function isEmployee(uint _id) private returns(bool _isEmployee){
        return employees[_id].isEmployee;
    }
    
    function AddEmployee(string memory _name, string memory _position, string memory _phoneNumber) public {
        Employee memory e;
        e.id = countIDEmployees;
        e.name = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        e.isEmployee = true;
        employees[countIDEmployees] = e;
        countIDEmployees++;
    }
    
    function GetEmployee(uint id) public returns (string memory _name, string memory _position, string memory _phoneNumber){
        return (employees[id].name, employees[id].position, employees[id].phoneNumber);
    }
    
    function UpdateEmployee(uint _searchId, string memory _newName, string memory _newPosition, string memory _newPhoneNumber) public {
       if(!isEmployee(_searchId)) revert();
       if(bytes(_newName).length != 0) {  employees[_searchId].name = _newName; }
       if(bytes(_newPosition).length != 0) { employees[_searchId].position = _newPosition; }
       if(bytes(_newPhoneNumber).length != 0) { employees[_searchId].phoneNumber = _newPhoneNumber; }
    }
}