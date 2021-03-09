pragma solidity ^0.7.4;

contract HomeStruct
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
    }
    
    mapping(address => Employee) private employees;
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
}
