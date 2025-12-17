// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICassaPolicy {
    /// @notice Returns the effective date of the policy
    /// @return timestamp The timestamp when the policy becomes effective
    function effectiveDate() external view returns (uint256 timestamp);

    /// @notice Returns the expiration date of the policy
    /// @return timestamp The timestamp when the policy expires
    function expirationDate() external view returns (uint256 timestamp);

    /// @notice Returns the settlement ratio and settlement status of the policy
    /// @return ratio The settlement ratio value scaled by 1e18 (1e18 = 100%)
    /// @return settled Whether the policy has been settled
    /// @return ok Whether the settlement calculation was successful
    function settlementRatio() external view returns (uint256 ratio, bool settled, bool ok);
}
