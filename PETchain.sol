pragma solidity ^ 0.6.1;

contract PETchain{
    
    bool public paused;
    address payable owner;
    bytes32 public data_id;
    bytes32 public index;
    bytes32 public key;
    string url;
       mapping (address=>bytes32) public addressmapping;
    mapping (address=>string) public authmapping;
    mapping (address=>bool) public trustedmapping;
    mapping (address=>bytes32) public keymapping;
    mapping (address=>string) public urlmapping;
   
    constructor() public { //to set the deployer of the contract as owner 
        owner=msg.sender;
    }

    function set_identifier(bytes32 _dataid, address _address,  bytes32 _key, string memory _url) public {  // owner can set and update data identifier
        require (msg.sender==owner,"You are not the owner");
          keymapping[_address]=_key;
         urlmapping[_address]=_url;
         addressmapping[_address]=_dataid;
    }
    
   
    function set_authorization(address _subject, string memory _role) public{ //owner declares whether service provider is trusted or not
        require (msg.sender==owner,"You are not the owner");
        require(keccak256(bytes(_role)) == keccak256("trusted") || keccak256(bytes(_role)) == keccak256("untrusted"),"undefined policy");
        authmapping[_subject]=_role;
    }
    
     function get_identifier() public view returns(bytes32, bytes32, string memory){ // Service provider is able to access data identifiers 
        require(paused==false,"contract is paused by owner");
        require (msg.sender==owner || keccak256(bytes(authmapping[msg.sender])) == keccak256("trusted"),"policy doesnot allow to access");
        return(addressmapping[msg.sender],keymapping[msg.sender],urlmapping[msg.sender]);
    }
    
 
    function destroy_smartcontract() public {// owner is able to destroy smartcontract
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(owner);
    }
    
    function pause_smartcontract(bool _paused) public{ //owner is able to pause and unpause the contract 
        require(msg.sender==owner,"you are not the owner");
        paused=_paused;
    }
    

  }
