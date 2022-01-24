pragma solidity 0.7.0;

import "./IBank.sol";
import "./IERC20.sol";

contract Bank is IBank {

    mapping(address => Account) etherAccounts;
    mapping(address => Account) hakAccounts;
    mapping(address => uint) amountBorrowed;
    mapping(address => uint) lastBlockRepay;

    address ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function calculateEthInterest() private {
        if (etherAccounts[msg.sender].deposit > 0){
            uint blockAmount = block.number - etherAccounts[msg.sender].lastInterestBlock;
            blockAmount = blockAmount / 100;
            uint interest = (etherAccounts[msg.sender].deposit * 3 / 100) * blockAmount;
            etherAccounts[msg.sender].interest += interest;
        }
    }

    function calculateHAKInterest() private {
        if (hakAccounts[msg.sender].deposit > 0){
            uint blockAmount = block.number - hakAccounts[msg.sender].lastInterestBlock;
            blockAmount = blockAmount / 100;
            uint interest = (hakAccounts[msg.sender].deposit * 3 / 100) * blockAmount;
            hakAccounts[msg.sender].interest += interest;
        }
    }

    function deposit(address token, uint256 amount) override payable external returns (bool) {
        if (ethAddress == token){
            require(amount == msg.value, "The amount of Ether sent is different for the amount argument.");
            calculateEthInterest();
            etherAccounts[msg.sender].deposit += msg.value;
            etherAccounts[msg.sender].lastInterestBlock += block.number;
        } 
        else {
            IERC20 tokenContract = IERC20(token);
            require(tokenContract.transferFrom(msg.sender, address(this), amount),"The HAK transfer is not working.");
            calculateHAKInterest();
            hakAccounts[msg.sender].deposit += amount;
            hakAccounts[msg.sender].lastInterestBlock += block.number;
        }
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address token, uint256 amount) override external returns (uint256) {
        if (ethAddress == token){
            require(etherAccounts[msg.sender].deposit >= amount, "The amount is higher than the available balance.");
            calculateEthInterest();
            uint transferAmount = etherAccounts[msg.sender].deposit;
            transferAmount += etherAccounts[msg.sender].interest;
            etherAccounts[msg.sender].deposit = 0;
            etherAccounts[msg.sender].interest = 0;
            payable(msg.sender).transfer(transferAmount);
        } 
        else {
            IERC20 tokenContract = IERC20(token);
            calculateHAKInterest();
            uint transferAmount = hakAccounts[msg.sender].deposit;
            transferAmount += hakAccounts[msg.sender].interest;
            hakAccounts[msg.sender].deposit = 0;
            hakAccounts[msg.sender].interest = 0;
            require(tokenContract.transfer(msg.sender, transferAmount),"The HAK transfer is not working.");
        }
        emit Withdraw(msg.sender, token, amount);
    }

    function borrow(address token, uint256 amount) override external returns (uint256) {
        require(token == ethAddress, "Token must be set to 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE");
        uint maxRatio = 150 * etherAccounts[msg.sender].deposit /100;
        require(amountBorrowed[msg.sender] + amount > maxRatio, "Max amount borrowed");

        amountBorrowed[msg.sender] += amount;
        lastBlockRepay[msg.sender] = block.number;
        uint newCollateralRatio = amountBorrowed[msg.sender] * 100 / etherAccounts[msg.sender].deposit;

        emit Borrow(msg.sender,token,amount,newCollateralRatio);
    }

    function repay(address token, uint256 amount) override payable external returns (uint256) {
        
        uint blocks = block.number - lastBlockRepay[msg.sender];
        lastBlockRepay[msg.sender] = block.number;
        uint interest = blocks * 5 / 100;
        require(amount > interest, "The amount is not enough to pay the interests");
        amountBorrowed[msg.sender] -= (amount - interest);

        emit Repay(msg.sender, token, amountBorrowed[msg.sender]);

        return amountBorrowed[msg.sender];
    }

    function liquidate(address token, address account) override payable external returns (bool) {
        
    }

    function getCollateralRatio(address token, address account) override view external returns (uint256) {
        require (ethAddress != token);
        if (amountBorrowed[account] == 0) return type(uint256).max;
        if (hakAccounts[account].deposit == 0) return 0;
        return hakAccounts[account].deposit / amountBorrowed[account];
    }

    function getBalance(address token) override view external returns (uint256) {
        if (ethAddress == token) return etherAccounts[msg.sender].deposit;
        else return hakAccounts[msg.sender].deposit;
    }
}