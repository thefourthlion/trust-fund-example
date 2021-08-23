pragma solidity ^0.8.1;

contract Trust {
    mapping(address => uint) public amounts;
    mapping(address => uint) public matuirities;
    mapping(address => bool) public paid;
    address public admin;
    
    constructor(){
        admin = msg.sender;
    }
    
    function addKid(address kid, uint timeToMaturity) external payable {
        require(msg.sender == admin, 'Admin only!');
        require(amounts[msg.sender] == 0, 'This wallet is being used for another kid.');
        amounts[kid] = msg.value;
        matuirities[kid] = block.timestamp + timeToMaturity;
    }
    
    function withdraw() external {
        require(matuirities[msg.sender] <= block.timestamp, 'It is to early to withdraw.');
        require(amounts[msg.sender] > 0, 'Only my kid withdraw.');
        require(paid[msg.sender] == false, 'You have already been paid.');
        paid[msg.sender] = true;
        payable(msg.sender).transfer(amounts[msg.sender]);
    }
}