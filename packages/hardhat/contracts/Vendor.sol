pragma solidity ^0.8.4;
// SPDX-License-Identifier: MIT

import "./openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address, uint256, uint256);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy some tokens");

        // Get the amount sent
        uint256 amountOfETH = msg.value;
        uint256 amountOfTokens = amountOfETH * tokensPerEth;

        // make a transfer to sender address
        yourToken.transfer(msg.sender, amountOfTokens);

        emit BuyTokens(msg.sender, amountOfETH, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // ToDo: create a sellTokens() function:
    function sellTokens(uint256 _amount) public {
        uint256 _tokenAmt = _amount / tokensPerEth;
        yourToken.transferFrom(msg.sender, address(this), _amount);
        (bool sent, bytes memory data) = msg.sender.call{value: _tokenAmt}("");
        emit SellTokens(msg.sender, _amount, _tokenAmt);
    }
}
