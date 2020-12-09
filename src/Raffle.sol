/** 
  * SPDX-License-Identifier: MIT
  *    
  * David Moncayo
  * Raffle Smart Contract
  *
  * A smart contract that hosts a raffle, allowing
  * participants to buy as many tickets as they want
  * to increase their chances at winning the prize pool.
  * The caller of the contract (owner) receives a cut
 */

pragma solidity ^0.7.5;

contract Raffle {
    address payable owner;
    address payable winner;

    // The list of participants in the raffle
    // Every time one buys a ticket, their address is added
    // to this list. More tickets => higher chance of winning
    address[] participants;

    // The ticket price and raffle end time (in seconds or absolute UNIX timestamps)
    // as decided by the executor of this contract
    uint ticketPrice;
    uint raffleEndTime;
    
    // The final prize for the winner and owner of the raffle
    uint prizePool;

    // A check to see if the winner has been found
    bool private raffleOver;

    // Events that will be emitted on changes.
    event RaffleBegin();
    event EnteredRaffle(address buyer, uint amount);
    event WinnerPicked(address winner);
    
    constructor(uint _raffleTime, uint _ticketPrice) payable {
        ticketPrice =_ticketPrice;
        raffleEndTime = block.timestamp + _raffleTime;
        owner = msg.sender;
        raffleOver = false;

        emit RaffleBegin();
    }
    
    function getParticipants() public view returns(address[] memory) { return participants; }
    
    function getOwner() public view returns (address) { return address(owner); }
    
    function getWinner() public view returns (address) { return address(winner); }
    
    function getPrizePool() public view returns (uint) { return prizePool; }
    
    function getTicketPrice() public view returns (uint) { return ticketPrice; }
    
    function getRaffleEndTime() public view returns (uint) { return raffleEndTime; }
    
    function howMuchLonger() public view returns (uint) { return raffleEndTime - block.timestamp; }
    
    // The function for a participant to buy n amount of raffle tickets
    function buyTicket() external payable {
        require(block.timestamp <= raffleEndTime, "The raffle is over.");
        require(msg.value == ticketPrice, "You did not pay the ticket price." );
        
        emit EnteredRaffle(msg.sender, msg.value);
        
        // Increase the price pool and add another name to the raffle
        prizePool += msg.value;
        participants.push(msg.sender);
    }
    

    // Randomly selects a winner from the list of participants
    function drawWinner() external {
        require(block.timestamp >= raffleEndTime, "The raffle is not over yet.");
        
        // Random number taken from current block's hash to find
        // a winner from the current list of participants and 
        // payout to the address
        uint winnerIdx = uint(blockhash(block.number-1)) % participants.length;
        winner = payable(participants[winnerIdx]);
        raffleOver = true;

        emit WinnerPicked(winner);
    }
    
    function payout() external {
        require(block.timestamp >= raffleEndTime, "The raffle is not over yet.");
        require(raffleOver == true, "The winner hasn't been drawn yet.");

        // Owner will get 5% of the payout
        uint commission = prizePool / 20;
        uint winnerPayout = prizePool - commission;        
        
        // Transfer the raffle winnings
        owner.transfer(commission);
        winner.transfer(winnerPayout);
        
        // Destroys the contract
        selfdestruct(owner);
    }
}