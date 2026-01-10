// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployToken} from "script/DeployScript.s.sol";
import {FaucetToken} from "../src/TokenFaucet.sol";

contract FaucetTokenTest is Test {
    DeployToken public deployer;
    FaucetToken public ft;
    address OWNER = makeAddr("owner");

    event FaucetToken__Minted(address indexed user, uint256 value);
    event FaucetToken__TokenAdded(address indexed user, uint256 value);

    error FaucetToken__InvalidAddress(address);

    function setUp() public {
        deployer = new DeployToken();
        // ft = deployer.run();
        vm.prank(OWNER);
        ft = new FaucetToken();
    }

    function testCheckOwner() public view {
        assert(ft.getOwner() == OWNER);
    }

    function testCheckBalanceOfOwner() public view {
        console.log("owner balance ", ft.balanceOf(OWNER));
        assert(ft.balanceOf(OWNER) == 100 ether);
    }

    function testValidateSymbol() public view {
        assert(keccak256(bytes(ft.symbol())) == keccak256(bytes("GT")));
        assertEq(ft.name(), "GTToken");
    }

    function testMintWhenNotOwner() public {
        uint256 newValue = 10 ether;
        address USER = makeAddr("USER");
        vm.prank(USER);
        vm.expectRevert();
        ft.mint(newValue);
    }

    function testMintEvent() public {
        uint256 newValue = 10 ether;
        vm.expectEmit(true, false, false, true);
        emit FaucetToken__Minted(OWNER, newValue);
        vm.prank(OWNER);
        ft.mint(newValue);
    }

    function testClaimRevertWhenNoAddress() public {
        address noAddress = address(0);
        vm.expectRevert(
            abi.encodeWithSelector(
                FaucetToken__InvalidAddress.selector,
                noAddress
            )
        );
        ft.claim(noAddress);
    }

    function testClaimWithTime() public {
        //Arrange
        vm.deal(OWNER, 200 ether);
        console.log("contract add", address(this));
        address TESTUSER = makeAddr("user");
        vm.prank(OWNER);
        ft.claim(TESTUSER);
        //Act
        uint256 time = ft.getTimeDetails(TESTUSER);
        //Assert
        assert(time != 0);
    }

    function testClaimandCheckUserBalance() public {
        //Arrange
        address USER = makeAddr("user");
        vm.prank(OWNER);
        ft.claim(USER);
        //Act
        uint256 userBalance = ft.balanceOf(USER);
        //Assert
        assert(userBalance == 1e18);
    }

    function testClaimEventConfirm() public {
        //Arrange
        vm.prank(OWNER);
        address USER = makeAddr("user");
        vm.expectEmit(true, false, false, true);

        //Act / Assert
        emit FaucetToken__TokenAdded(USER, 1e18);
        ft.claim(USER);
    }

    function testClaimAndReclaim() public {
        //Arrange
        address USER = makeAddr("user");
        vm.prank(OWNER);
        //Act
        ft.claim(USER);
        vm.prank(USER);

        //Assert
        vm.expectRevert();
        ft.claim(USER);
    }

    function testClaimAndReclaimNextDay() public {
        //Arrange
        address USER = makeAddr("USER");
        vm.prank(OWNER);
        //Act
        ft.claim(USER);
        vm.warp((block.timestamp + 1 days) + 1);
        vm.roll(block.number + 1);
        //Assert
        vm.prank(OWNER);
        ft.claim(USER);
    }

    function testFullCycle() public {
        //Arrange
        address USER = makeAddr("user");
        address TESTUSER = makeAddr("testuser");
        uint256 ownerBalance = ft.balanceOf(OWNER);
        //Act
        vm.prank(OWNER);
        ft.claim(USER);
        vm.prank(OWNER);
        ft.claim(TESTUSER);
        //Assert
        console.log("owner", ft.balanceOf(OWNER));
        console.log("user", ft.balanceOf(USER));
        console.log("testuser", ft.balanceOf(TESTUSER));
        assertEq(
            (ft.balanceOf(USER) + ft.balanceOf(TESTUSER) + ft.balanceOf(OWNER)),
            ownerBalance
        );
    }
}
