//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IPropyKeysAppraisal{

    
    struct Appraisal {
        uint256 runningSum;
        uint256 numberOfVotes;
        Vote[] votes;
        bool active;
    }

    struct Vote {
        address voter;
        uint256 price;
    }
  

}