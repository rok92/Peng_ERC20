// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PengToken is ERC20, ERC20Burnable, Ownable {
    uint256 constant maxSupply = 1000000000000 * (10 ** 18);

    mapping(address => bool) controllers;

    modifier onlyControllerOrOwner() {
        require(controllers[msg.sender] || msg.sender == owner(), "Only controllers or owner can call");
        _;
    }

    constructor() ERC20("PengToken", "PT") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) external onlyControllerOrOwner {
        require((totalSupply() + amount) <= maxSupply, "Maximum supply has been reached");
        _mint(to, amount);
    }

    function burnFrom(address account, uint256 amount) public override onlyControllerOrOwner {
        _burn(account, amount);
    }

    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }

    function getMaxSupply() public pure returns (uint256) {
        return maxSupply;
    }
}
