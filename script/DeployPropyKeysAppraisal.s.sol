// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PropyKeysAppraisal} from "../src/PropyKeysAppraisal.sol";
import {PropyKeys} from "../src/PropyKeys.sol"; 

contract PropyKeyAppraisalDeployScript is Script {
    PropyKeysAppraisal public propyKeysAppraisal;
    PropyKeys public propyKeys;

    function setUp() public {
        // Initialize any necessary state or contracts here
    }

    function run() public {
        vm.startBroadcast();

        // Deploy the PopyKeys NFT contract
        propyKeys = new PropyKeys();

        // Deploy the Appraisal contract, passing the address of the PopyKeys contract if needed
        propyKeysAppraisal = new PropyKeysAppraisal(address(propyKeys));

        vm.stopBroadcast();
    }
}

