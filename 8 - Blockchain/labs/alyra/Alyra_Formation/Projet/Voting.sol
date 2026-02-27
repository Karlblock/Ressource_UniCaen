// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Voting is Ownable {

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }


    mapping(address => Voter) public voters;
     // all propositions : 
    Proposal[] public proposals;
    uint public winningProposalID;

    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);    
    event VoterRegistered(address voterAddress); 
    event unregistered(address voterAddress);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);
    

    // workflow initialisation :
    
    WorkflowStatus public voteStatus = WorkflowStatus.RegisteringVoters;


    modifier wlVoter(address _addr) {
        require(voters[msg.sender].isRegistered == true, "not on the wl");
        _;
    }

    constructor() {

       address owner = msg.sender;
       voters[owner].isRegistered = true;
    }

    // add voters to wl

    function addWL(address _voter) external onlyOwner{
        require(voteStatus == WorkflowStatus.RegisteringVoters, "waiting on the register WL ended");
        // require(!voters[_voter].isRegistered, "you are already registered"); 
        // or   
        require(voters[_voter].isRegistered != true, "you are already registered");
        voters[_voter].isRegistered = true;
        emit VoterRegistered(_voter);
    }

    function delWL(address _addr) external  wlVoter(_addr) {
        voters[_addr].isRegistered = false;
        emit unregistered(_addr);
    }

//  Quelques get pour infos

    function getProposals() external view  returns(Proposal[] memory) {
        
        return proposals;

    }
   
// Status 

    function changeWorkflowStatus(WorkflowStatus _status) external onlyOwner {
        voteStatus = _status;
    }


// action 

//add vote :

    function registerVote(uint proposalId) external   {
        require(voters[msg.sender].isRegistered,"Your address is not on the WL");
        require(voters[msg.sender].hasVoted == false, "Address has already voted");
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = proposalId;
        proposals[proposalId].voteCount++;
        emit Voted(msg.sender, proposalId);
        }

// add proposal : 

    function addProposal(string memory _desc) external {
        require(voters[msg.sender].isRegistered == true, "address not whitelisted");
        // voteStatus = WorkflowStatus.ProposalsRegistrationStarted;
        require(voteStatus == WorkflowStatus.ProposalsRegistrationStarted, 'Proposals are not allowed yet');
        Proposal memory proposal;
        proposal.description = _desc;
        proposals.push(proposal);
        
        emit ProposalRegistered(proposals.length-1);
    }


// décompte des votes 

    function tallyVotes() external onlyOwner {
        require(voteStatus == WorkflowStatus.VotingSessionEnded, "please make the status ended");
        uint _winningProposalId;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > proposals[_winningProposalId].voteCount) {
                _winningProposalId = i;
            }
        }

        winningProposalID = _winningProposalId;
        
        voteStatus = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }

    
}
