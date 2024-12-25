// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {DeployDecentralizedStableCoin} from "script/DeployDecentralizedStableCoin.s.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";

contract DecentralizedStableCoinTest is Test {
    DeployDecentralizedStableCoin deployer;
    DecentralizedStableCoin dscToken;

    function setUp() public {
        deployer = new DeployDecentralizedStableCoin();
        dscToken = new DecentralizedStableCoin();
        vm.prank(dscToken.owner());
    }

    function testRevertMustBeMoreThanZero() public {
        vm.expectRevert(
            DecentralizedStableCoin
                .DecentralizedStableCoin_MustBeMoreThanZero
                .selector
        );
        dscToken.burn(0);
    }

    function testRevertDecentralizedStableCoin_BurnAmountExceedBalance()
        public
    {
        dscToken.mint(dscToken.owner(), 10 ether);
        vm.expectRevert(
            DecentralizedStableCoin
                .DecentralizedStableCoin_BurnAmountExceedBalance
                .selector
        );
        dscToken.burn(40 ether);
    }

    function testMintSuccess() public {
        bool success = dscToken.mint(dscToken.owner(), 10 ether);
        uint256 balance = dscToken.getBalance();
        assertEq(success, true);
        assertEq(balance, 10 ether);
    }
}
