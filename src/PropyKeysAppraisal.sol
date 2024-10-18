//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.24;

import {PropyKeys} from "./PropyKeys.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IPropyKeysAppraisal} from "../interfaces/IPropyKeysAppraisal.sol";
contract PropyKeysAppraisal is Ownable, IPropyKeysAppraisal {

    ///ERRORS
    error InvalidPrice(uint256 price);
    error AppraisalNotActive(uint256 tokenId);
    error AlreadyVoted(address appraiser);
    error MaxToleranceInvalid(uint256 tolerance);

    ///EVENTS
    event FinalPriceSet(uint256 price);
    event VoteSubmitted(address appraiser,uint256 tokenid, uint256 price);


    mapping (address user => mapping(uint256 tokenId => bool voted)) userVoted;
    mapping (uint256 tokenId => Appraisal appraisal) public propyKeyToAppraisal;
    address propyKeys;
    mapping(uint256 tokenId => uint256 price) public prices;
    uint256 public maxTolerancePercentage; //max value is 1e4 (100%) 


    constructor(address _propyKeys) Ownable(msg.sender) {
        propyKeys = _propyKeys;
    }

    /// ADMIN FUNCTIONS ///

    //Admin function to set the final price of the token and end the appraisal process
    function setPrice(uint256 tokenId, uint256 price) public onlyOwner {
        prices[tokenId] = price;
        propyKeyToAppraisal[tokenId].active = false;

        //Distribute points of every user who has participated in the appraisal
        _distributePoints(tokenId);
        emit FinalPriceSet(price);
    }

    function setMaxTolerance(uint256 _maxTolerancePercentage) public onlyOwner {
        if (_maxTolerancePercentage > 1e4) revert MaxToleranceInvalid(_maxTolerancePercentage);
        maxTolerancePercentage = _maxTolerancePercentage;
    }


    function _distributePoints(uint256 tokenId) internal {
        Vote[] memory _votes = propyKeyToAppraisal[tokenId].votes;
        uint256 _finalPrice = prices[tokenId];
        for (uint i=0;i<_votes.length;++i) {
            uint256 distanceToFinalPrice = _abs(_votes[i].price, _finalPrice);
            //Check if the user has voted within the tolerance
            if (distanceToFinalPrice * 1e4 / _finalPrice  >= maxTolerancePercentage) {
                continue;
        }
            //TODO: Distribute points here
        }
    }
    //In case the appraisal is not a one-off event, we include an admin function to set the appraisal as active again
    function startNewAppraisal(uint256 tokenId) public onlyOwner {
        propyKeyToAppraisal[tokenId].active = true;
    }

    function appraise(uint256 tokenId, uint256 price) public {
        if (price == 0 ) revert InvalidPrice(0);
        Appraisal storage _appraisal = propyKeyToAppraisal[tokenId];
        if (!_appraisal.active) revert AppraisalNotActive(tokenId);
        if (userVoted[msg.sender][tokenId]) revert AlreadyVoted(msg.sender);
        //TODO implement some sort of "vote weighting" here. 
        _appraisal.runningSum += price;
        ++_appraisal.numberOfVotes;


        //store data
        propyKeyToAppraisal[tokenId] = _appraisal;
        emit VoteSubmitted(msg.sender, tokenId, price);
    }

        function _abs(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x - y : y - x;
    }

}