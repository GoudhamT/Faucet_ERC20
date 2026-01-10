//SPDX-License-Identifier:MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FaucetToken is ERC20 {
    /*Errors */
    error FaucetToken__InvalidAddress(address);
    /*Events*/
    event FaucetToken__Minted(address indexed user, uint256 value);
    event FaucetToken__TokenAdded(address indexed user, uint256 value);

    address public owner;
    // mapping(address => uint256) private faucetClaim;
    uint256 constant INITIAL_SUPPLY = 100 ether;
    mapping(address => uint256) private claimedAt;
    uint256 private constant CLAIM_VALUE = 1 ether;
    uint256 private constant COOL_DOWN_TIME = 1 days;

    constructor() ERC20("GTToken", "GT") {
        owner = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    modifier validateClaimTime(address _user) {
        _validateClaimTime(_user);
        _;
    }

    function _validateClaimTime(address _user) internal view {
        uint256 usersTime = claimedAt[_user];
        if (usersTime != 0) {
            require(
                block.timestamp > (usersTime + COOL_DOWN_TIME),
                "Wait for some more hours"
            );
        }
    }

    function mint(uint256 _value) public onlyOwner {
        _mint(msg.sender, _value);
        emit FaucetToken__Minted(msg.sender, _value);
    }

    function claim(address _user) public validateClaimTime(_user) {
        if (_user == address(0)) {
            revert FaucetToken__InvalidAddress(_user);
        }
        bool status = transfer(_user, CLAIM_VALUE);
        if (status) {
            claimedAt[_user] = block.timestamp;
        }
        emit FaucetToken__TokenAdded(_user, CLAIM_VALUE);
    }

    /*Getter functions */
    function getOwner() external view returns (address) {
        return owner;
    }

    function getTimeDetails(address _user) external view returns (uint256) {
        return claimedAt[_user];
    }
}
