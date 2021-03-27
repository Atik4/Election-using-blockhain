// SPDX-License-Identifier: MIT
pragma solidity >=0.4.17 <0.9.0;

contract Ballot {
    
    struct Candidates {
        bytes32 name;
        uint voteCount;
        uint creationDate;
        uint expirationDate;
    }
    
    Candidates[] public candidates;
    address public manager;
    bytes32 public votingDistrict;
    mapping(address => bool) public voters;
    uint private maxCount = 0;
    int private winner = -1;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor (bytes32[] memory candidateNames, bytes32 district, uint amountOfHours) public {
        manager = msg.sender;
        votingDistrict = district;
    for (uint i = 0;i < candidateNames.length; i++) {
        candidates.push(Candidates({
        name: candidateNames[i],
        voteCount: 0,
        creationDate: now,
        expirationDate: now + amountOfHours
        }));
        }
    }
    
    function vote(uint candidate) public{
        require(!voters[msg.sender]);
        // if(now >
        // candidates[candidate].expirationDate){
        // revert();
        // }
        candidates[candidate].voteCount += 1;
        if(maxCount < candidates[candidate].voteCount){
            maxCount = candidates[candidate].voteCount;
            winner = int(candidate);
        }
    
        voters[msg.sender] = true;
    }
    
    function getCandidateName(uint index) public restricted view returns (bytes32)
    {
        require(now > candidates[index].expirationDate);
        return candidates[index].name;
    }
    
    function getVoteCount(uint index) public restricted view returns (uint)
    {
        //require(now > candidates[index].expirationDate);
        return candidates[index].voteCount;
    }
    
    function getWinner() public restricted view returns (int){
        return winner;
    }
    
    function getMaxCount() public restricted view returns (uint){
        return maxCount;
    }

}