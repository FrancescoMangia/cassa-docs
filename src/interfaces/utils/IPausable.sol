// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IPausable {
    /// @notice Returns true if the contract is paused, and false otherwise
    /// @return _paused True if paused, false otherwise
    function paused() external view returns (bool _paused);

    /// @notice Pause the contract, revert if already paused
    function pause() external;

    /// @notice Unpause the contract, revert if not paused
    function unpause() external;
}
