// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDSCEngine is Script {
    DSCEngine public dscEngine;
    DecentralizedStableCoin public dscToken;
    address[] private tokenAddresses;
    address[] private priceFeddAdresses; 
    
    function run() external returns (DecentralizedStableCoin, DSCEngine, HelperConfig) {
        HelperConfig config = new HelperConfig();
        (address wethUsdPriceFeed, address wbtcUsdPriceFeed, address weth, address wbtc, uint256 deployerKey) =
            config.activeNetworkConfig();

        tokenAddresses = [weth, wbtc];
        priceFeddAdresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        vm.startBroadcast(deployerKey);
        dscToken = new DecentralizedStableCoin();
        dscEngine = new DSCEngine(tokenAddresses, priceFeddAdresses, address(dscToken));
        dscToken.transferOwnership(address(dscEngine)); 
        vm.stopBroadcast();
        return (dscToken, dscEngine, config);
    }
}
