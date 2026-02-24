// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IPaymaster, ExecutionResult, PAYMASTER_VALIDATION_SUCCESS_MAGIC} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";
import {IPaymasterFlow} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymasterFlow.sol";
import {Transaction} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Paymaster is IPaymaster, Ownable {
    address public allowedToken;

    constructor(address _token) {
        allowedToken = _token;
    }

    function validateAndPayForPaymasterTransaction(
        bytes32,
        bytes32,
        Transaction calldata _transaction
    ) external payable returns (bytes4 magic, bytes memory context) {
        magic = PAYMASTER_VALIDATION_SUCCESS_MAGIC;
        
        uint256 requiredETH = _transaction.gasLimit * _transaction.maxFeePerGas;

        // Pull tokens from user to this contract
        // Note: User must have approved this paymaster contract beforehand
        IERC20(allowedToken).transferFrom(address(uint160(_transaction.from)), address(this), requiredETH);

        // Pay the bootloader
        (bool success, ) = payable(msg.sender).call{value: requiredETH}("");
        require(success, "Payment to bootloader failed");
    }

    function postTransaction(
        bytes calldata _context,
        Transaction calldata _transaction,
        bytes32,
        bytes32,
        ExecutionResult _txResult,
        uint256 _maxRetransmissionCost
    ) external payable override {}

    receive() external payable {}
}
