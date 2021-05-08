pragma solidity >=0.6.0 <=0.8.3;
pragma experimental ABIEncoderV2;

contract Owned
{
    address payable private owner;
    
    constructor() public
    {
        owner = payable(msg.sender);
    }
    
    modifier Onlyowner
    {
        require(
            msg.sender == owner, 
            'Only owner can do it'
            );
        _;
    }
    
    function ChangeOwner(address payable newOwner) public Onlyowner
    {
        owner = newOwner;
    }
    
    function GetOwner() public returns (address)
    {
        return owner;
    }
}

contract ROSReestr is Owned
{
    uint256 private price = 1;
    
    enum RequestType {NewHome, EditHome}
    enum OwnerOperation {Add, Edit, Delete}
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }   
    
    struct Owner{
        string name;
        uint passSer;
        uint passNum;
        uint256 date;
        string phoneNumber;
        bool isset;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
        bool isset;
    }
    
    struct Request
    {
        RequestType requestType;
        OwnerOperation operation;
        string homeAddress;
        uint area;
        uint cost;
        uint result;
        address adr;
        bool isProcessed;
    }
    
    struct Employee
    {
        string nameEmployee;
        string position;
        string phoneNumber;
        bool isset;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    address[] requestsInitiator;
    address[] listhome;
    string[] addresses;
    mapping(string => Home) private homes;
    mapping(address => Home) private homess;
    mapping(string => Ownership[]) private ownerships;
    
    uint private amount;

    
    modifier OnlyEmployee
    {
        require(
            employees[msg.sender].isset != false,
            'lya ti krisa'
            );
        _;
    }
    
    modifier Costs(uint value)
    {
        require(
            msg.value >= value,
            'Not enough funds!!'
            );
        _;
    }
    
    
    function AddHome(string memory _adr, uint _area, uint _cost) public
    {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homess[msg.sender] = h;
        homes[_adr] = h;
        listhome.push(msg.sender);
        addresses.push(_adr);
    }
    
    function AddEmployee(address empl, string memory _name, string memory _position, string memory _phoneNumber) public Onlyowner
    {
        Employee memory e;
        e.nameEmployee = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        employees[empl] = e;
        e.isset = true;
    }
    
    function GetEmployee(address empl) public Onlyowner returns (string memory nameEmployee, string memory _position, string memory _phoneNumber)
    {
        return (employees[empl].nameEmployee, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function EditEmployee(address empl, string memory _newname, string memory _newposition, string memory _newphoneNumber) public Onlyowner
    {
        employees[empl].nameEmployee = _newname;
        employees[empl].position = _newposition;
        employees[empl].phoneNumber = _newphoneNumber;
    }
    
    function DeleteEmployee(address empl) public Onlyowner returns (bool)
    {
        if(employees[msg.sender].isset == true){
            delete employees[empl];
            return true;
        }
        return false;
    }
    
    function GetHome(string memory adr) public returns (uint _area, uint _cost)
    {
        return (homes[adr].area, homes[adr].cost);
    }
    
    function AddRequest(uint rType, string memory adr, uint area, uint cost, address newOwner) public Costs(1e12) payable returns (bool)
    {
        Request memory r;
        r.requestType = rType == 0? RequestType.NewHome: RequestType.EditHome;
        r.homeAddress = adr;
        r.area = area;
        r.cost = cost;
        r.result = 0;
        r.adr = rType==0?address(0):newOwner;
        r.isProcessed = false;
        requests[msg.sender] = r;
        requestsInitiator.push(msg.sender);
        amount += msg.value;
        return true;
    }
    
    function GetRequest() public OnlyEmployee returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestsInitiator.length);
        uint[] memory types = new uint[](requestsInitiator.length);
        string[] memory homeAddresses = new string[](requestsInitiator.length);
        for(uint i=0;i!=requestsInitiator.length;i++){
            ids[i] = i;
            types[i] = requests[requestsInitiator[i]].requestType == RequestType.NewHome ? 0: 1;
            homeAddresses[i] = requests[requestsInitiator[i]].homeAddress;
        }
        return (ids, types, homeAddresses);
    }
    
    function GetListHome() public view returns (string[] memory, uint[] memory, uint[] memory)
    {
        string[] memory Address = new string[](listhome.length);
        uint[] memory costss = new uint[](listhome.length);
        uint[] memory areas = new uint[](listhome.length);
        for(uint i = 0; i != listhome.length; i++)
        {
            Address[i] = homess[listhome[i]].homeAddress;
            costss[i] = homess[listhome[i]].cost;
            areas[i] = homess[listhome[i]].area;
        }
        return (Address, costss, areas);
    }
    
    function GetlistOwner() public view returns (bool)
    {
        
        return true;
    }
    
    function NewCost(uint256 newCost) public Onlyowner
    {
        price = newCost;
    }
    
    function GetCost() public returns (uint nowcost)
    {
        return price;
    }
    
    function ProcessRequest(uint Id) public OnlyEmployee returns (uint)
    {
        if(Id<0 || Id>=requestsInitiator.length) return 1;
        Request memory r = requests[requestsInitiator[Id]];
        if(r.requestType == RequestType.NewHome && homes[r.homeAddress].isset)
        {
            delete requests[requestsInitiator[Id]];
            delete requestsInitiator[Id];
            
            return 2;
        } 
        if(r.requestType == RequestType.NewHome)
        {
            //add new Home
            AddHome(r.homeAddress, r.area, r.cost);
            //set ownership
            Ownership memory ownership;
            ownership.homeAddress = r.homeAddress;
            ownership.owner = requestsInitiator[Id];
            ownership.p = 1;
            ownerships[r.homeAddress].push(ownership);
        }
        delete requests[requestsInitiator[Id]];
        delete requestsInitiator[Id];
        return 0;
    }
}
