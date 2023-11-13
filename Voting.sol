// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public admin;
    mapping(address => bool) public registeredVoters;
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public voteCount;

    event VoterRegistered(address indexed voter);
    event VoteCasted(address indexed voter, string candidate);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(registeredVoters[msg.sender], "Voter is not registered");
        _;
    }

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "Voter has already casted a vote");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerVoter(address _voter) external onlyAdmin {
        registeredVoters[_voter] = true;
        emit VoterRegistered(_voter);
    }

    function castVote(string memory _candidate) external onlyRegisteredVoter hasNotVoted {
        voteCount[_candidate]++;
        hasVoted[msg.sender] = true;
        emit VoteCasted(msg.sender, _candidate);
    }

    function getVoteCount(string memory _candidate) external view returns (uint256) {
        return voteCount[_candidate];
    }
}