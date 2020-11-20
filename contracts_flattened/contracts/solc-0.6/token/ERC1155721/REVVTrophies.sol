// Sources flattened with hardhat v2.0.3 https://hardhat.org

// File @animoca/ethereum-contracts-core_library/contracts/utils/types/UInt256ToDecimalString.sol@v3.1.1

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

library UInt256ToDecimalString {

    function toDecimalString(uint256 value) internal pure returns (string memory) {
        // Inspired by OpenZeppelin's String.toString() implementation - MIT licence
        // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/8b10cb38d8fedf34f2d89b0ed604f2dceb76d6a9/contracts/utils/Strings.sol
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = byte(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }
}


// File @animoca/ethereum-contracts-core_library/contracts/utils/types/Bytes32ToBase32String.sol@v3.1.1

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

library Bytes32ToBase32String {

    /**
     * @dev public function to convert bytes32 to string
     * @param value bytes32 value to convert
     * @return string string convert from given bytes32
     */
    function toBase32String(bytes32 value) internal pure returns (string memory) {
        bytes32 base32Alphabet = 0x6162636465666768696A6B6C6D6E6F707172737475767778797A323334353637;
        uint256 i = uint256(value);
        uint256 k = 52;
        bytes memory bstr = new bytes(k);
        bstr[--k] = base32Alphabet[uint8((i % 8) << 2)]; // uint8 s = uint8((256 - skip) % 5);  // (i % (2**s)) << (5-s)
        i /= 8;
        while (k > 0) {
            bstr[--k] = base32Alphabet[i % 32];
            i /= 32;
        }
        return string(bstr);
    }
}


// File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
 * (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(value)));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint256(_at(set._inner, index)));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

   /**
    * @dev Returns the value stored at position `index` in the set. O(1).
    *
    * Note that there are no guarantees on the ordering of values inside the
    * array, and it may change when more values are added or removed.
    *
    * Requirements:
    *
    * - `index` must be strictly less than {length}.
    */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}


// File @openzeppelin/contracts/utils/Address.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts/GSN/Context.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/AccessControl.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;



/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControl is Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    struct RoleData {
        EnumerableSet.AddressSet members;
        bytes32 adminRole;
    }

    mapping (bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members.contains(account);
    }

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) public view returns (uint256) {
        return _roles[role].members.length();
    }

    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
        return _roles[role].members.at(index);
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");

        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) public virtual {
        require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");

        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
        _roles[role].adminRole = adminRole;
    }

    function _grantRole(bytes32 role, address account) private {
        if (_roles[role].members.add(account)) {
            emit RoleGranted(role, account, _msgSender());
        }
    }

    function _revokeRole(bytes32 role, address account) private {
        if (_roles[role].members.remove(account)) {
            emit RoleRevoked(role, account, _msgSender());
        }
    }
}


// File @animoca/ethereum-contracts-core_library/contracts/access/MinterRole.sol@v3.1.1

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * Contract module which allows derived contracts access control over token
 * minting operations.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyMinter`, which can be applied to the minting functions of your contract.
 * Those functions will only be accessible to accounts with the minter role
 * once the modifer is put in place.
 */
contract MinterRole is AccessControl {

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    /**
     * Modifier to make a function callable only by accounts with the minter role.
     */
    modifier onlyMinter() {
        require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
        _;
    }

    /**
     * Constructor.
     */
    constructor () internal {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        emit MinterAdded(_msgSender());
    }

    /**
     * Validates whether or not the given account has been granted the minter role.
     * @param account The account to validate.
     * @return True if the account has been granted the minter role, false otherwise.
     */
    function isMinter(address account) public view returns (bool) {
        require(account != address(0), "MinterRole: address zero cannot be minter");
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    /**
     * Grants the minter role to a non-minter.
     * @param account The account to grant the minter role to.
     */
    function addMinter(address account) public onlyMinter {
        require(!isMinter(account), "MinterRole: add an account already minter");
        grantRole(DEFAULT_ADMIN_ROLE, account);
        emit MinterAdded(account);
    }

    /**
     * Renounces the granted minter role.
     */
    function renounceMinter() public onlyMinter {
        renounceRole(DEFAULT_ADMIN_ROLE, _msgSender());
        emit MinterRemoved(_msgSender());
    }

}


// File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


// File @openzeppelin/contracts/GSN/IRelayRecipient.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
 *
 * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
 */
interface IRelayRecipient {
    /**
     * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
     */
    function getHubAddr() external view returns (address);

    /**
     * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
     * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
     *
     * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
     * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
     * and the transaction executed with a gas price of at least `gasPrice`. ``relay``'s fee is `transactionFee`, and the
     * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
     * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
     * over all or some of the previous values.
     *
     * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
     * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
     *
     * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
     * rejected. A regular revert will also trigger a rejection.
     */
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
     * pre-charge the sender of the transaction.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}.
     *
     * Returns a value to be passed to {postRelayedCall}.
     *
     * {preRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
     * will not be executed, but the recipient will still be charged for the transaction's cost.
     */
    function preRelayedCall(bytes calldata context) external returns (bytes32);

    /**
     * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
     * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
     * contract-specific bookkeeping.
     *
     * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
     * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
     * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
     *
     *
     * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
     * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
     * transaction's cost.
     */
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}


// File @openzeppelin/contracts/GSN/IRelayHub.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
 * directly.
 *
 * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
 * how to deploy an instance of `RelayHub` on your local test network.
 */
interface IRelayHub {
    // Relay management

    /**
     * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
     * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
     * cannot be its own owner.
     *
     * All Ether in this function call will be added to the relay's stake.
     * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
     *
     * Emits a {Staked} event.
     */
    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    /**
     * @dev Emitted when a relay's stake or unstakeDelay are increased
     */
    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    /**
     * @dev Registers the caller as a relay.
     * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
     *
     * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
     * `transactionFee` is not enforced by {relayCall}.
     *
     * Emits a {RelayAdded} event.
     */
    function registerRelay(uint256 transactionFee, string calldata url) external;

    /**
     * @dev Emitted when a relay is registered or re-registered. Looking at these events (and filtering out
     * {RelayRemoved} events) lets a client discover the list of available relays.
     */
    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    /**
     * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
     *
     * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
     * callable.
     *
     * Emits a {RelayRemoved} event.
     */
    function removeRelayByOwner(address relay) external;

    /**
     * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
     */
    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    /** Deletes the relay from the system, and gives back its stake to the owner.
     *
     * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
     *
     * Emits an {Unstaked} event.
     */
    function unstake(address relay) external;

    /**
     * @dev Emitted when a relay is unstaked for, including the returned stake.
     */
    event Unstaked(address indexed relay, uint256 stake);

    // States a relay can be in
    enum RelayState {
        Unknown, // The relay is unknown to the system: it has never been staked for
        Staked, // The relay has been staked for, but it is not yet active
        Registered, // The relay has registered itself, and is active (can relay calls)
        Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
    }

    /**
     * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
     * to return an empty entry.
     */
    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    // Balance management

    /**
     * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
     *
     * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
     *
     * Emits a {Deposited} event.
     */
    function depositFor(address target) external payable;

    /**
     * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
     */
    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    /**
     * @dev Returns an account's deposits. These can be either a contract's funds, or a relay owner's revenue.
     */
    function balanceOf(address target) external view returns (uint256);

    /**
     * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
     * contracts can use it to reduce their funding.
     *
     * Emits a {Withdrawn} event.
     */
    function withdraw(uint256 amount, address payable dest) external;

    /**
     * @dev Emitted when an account withdraws funds from `RelayHub`.
     */
    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    // Relaying

    /**
     * @dev Checks if the `RelayHub` will accept a relayed operation.
     * Multiple things must be true for this to happen:
     *  - all arguments must be signed for by the sender (`from`)
     *  - the sender's nonce must be the current one
     *  - the recipient must accept this transaction (via {acceptRelayedCall})
     *
     * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
     * code if it returns one in {acceptRelayedCall}.
     */
    function canRelay(
        address relay,
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external view returns (uint256 status, bytes memory recipientContext);

    // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
    enum PreconditionCheck {
        OK,                         // All checks passed, the call can be relayed
        WrongSignature,             // The transaction to relay is not signed by requested sender
        WrongNonce,                 // The provided nonce has already been used by the sender
        AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
        InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
    }

    /**
     * @dev Relays a transaction.
     *
     * For this to succeed, multiple conditions must be met:
     *  - {canRelay} must `return PreconditionCheck.OK`
     *  - the sender must be a registered relay
     *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
     *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
     * recipient) use all gas available to them
     *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
     * spent)
     *
     * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
     * function and {postRelayedCall} will be called in that order.
     *
     * Parameters:
     *  - `from`: the client originating the request
     *  - `to`: the target {IRelayRecipient} contract
     *  - `encodedFunction`: the function call to relay, including data
     *  - `transactionFee`: fee (%) the relay takes over actual gas cost
     *  - `gasPrice`: gas price the client is willing to pay
     *  - `gasLimit`: gas to forward when calling the encoded function
     *  - `nonce`: client's nonce
     *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
     *  - `approvalData`: dapp-specific data forwarded to {acceptRelayedCall}. This value is *not* verified by the
     * `RelayHub`, but it still can be used for e.g. a signature.
     *
     * Emits a {TransactionRelayed} event.
     */
    function relayCall(
        address from,
        address to,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata signature,
        bytes calldata approvalData
    ) external;

    /**
     * @dev Emitted when an attempt to relay a call failed.
     *
     * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
     * actual relayed call was not executed, and the recipient not charged.
     *
     * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
     * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
     */
    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    /**
     * @dev Emitted when a transaction is relayed.
     * Useful when monitoring a relay's operation and relayed calls to a contract
     *
     * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
     *
     * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
     */
    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    // Reason error codes for the TransactionRelayed event
    enum RelayCallStatus {
        OK,                      // The transaction was successfully relayed and execution successful - never included in the event
        RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
        PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
        PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
        RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
    }

    /**
     * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
     * spend up to `relayedCallStipend` gas.
     */
    function requiredGas(uint256 relayedCallStipend) external view returns (uint256);

    /**
     * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
     */
    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);

     // Relay penalization.
     // Any account can penalize relays, removing them from the system immediately, and rewarding the
    // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
    // still loses half of its stake.

    /**
     * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
     * different data (gas price, gas limit, etc. may be different).
     *
     * The (unsigned) transaction data and signature for both transactions must be provided.
     */
    function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;

    /**
     * @dev Penalize a relay that sent a transaction that didn't target ``RelayHub``'s {registerRelay} or {relayCall}.
     */
    function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;

    /**
     * @dev Emitted when a relay is penalized.
     */
    event Penalized(address indexed relay, address sender, uint256 amount);

    /**
     * @dev Returns an account's nonce in `RelayHub`.
     */
    function getNonce(address from) external view returns (uint256);
}


// File @openzeppelin/contracts/GSN/GSNRecipient.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;



/**
 * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
 * and enables GSN support on all contracts in the inheritance tree.
 *
 * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
 *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
 * provided by derived contracts. See the
 * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
 * information on how to use the pre-built {GSNRecipientSignature} and
 * {GSNRecipientERC20Fee}, or how to write your own.
 */
abstract contract GSNRecipient is IRelayRecipient, Context {
    // Default RelayHub address, deployed on mainnet and all testnets at the same address
    address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;

    uint256 constant private _RELAYED_CALL_ACCEPTED = 0;
    uint256 constant private _RELAYED_CALL_REJECTED = 11;

    // How much gas is forwarded to postRelayedCall
    uint256 constant internal _POST_RELAYED_CALL_MAX_GAS = 100000;

    /**
     * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
     */
    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);

    /**
     * @dev Returns the address of the {IRelayHub} contract for this recipient.
     */
    function getHubAddr() public view override returns (address) {
        return _relayHub;
    }

    /**
     * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
     * use the default instance.
     *
     * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
     * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
     */
    function _upgradeRelayHub(address newRelayHub) internal virtual {
        address currentRelayHub = _relayHub;
        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");

        emit RelayHubChanged(currentRelayHub, newRelayHub);

        _relayHub = newRelayHub;
    }

    /**
     * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
     * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
     */
    // This function is view for future-proofing, it may require reading from
    // storage in the future.
    function relayHubVersion() public view returns (string memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return "1.0.0";
    }

    /**
     * @dev Withdraws the recipient's deposits in `RelayHub`.
     *
     * Derived contracts should expose this in an external interface with proper access control.
     */
    function _withdrawDeposits(uint256 amount, address payable payee) internal virtual {
        IRelayHub(_relayHub).withdraw(amount, payee);
    }

    // Overrides for Context's functions: when called from RelayHub, sender and
    // data require some pre-processing: the actual sender is stored at the end
    // of the call data, which in turns means it needs to be removed from it
    // when handling said data.

    /**
     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
     */
    function _msgSender() internal view virtual override returns (address payable) {
        if (msg.sender != _relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    /**
     * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
     * and a reduced version for GSN relayed calls (where msg.data contains additional information).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
     */
    function _msgData() internal view virtual override returns (bytes memory) {
        if (msg.sender != _relayHub) {
            return msg.data;
        } else {
            return _getRelayedCallData();
        }
    }

    // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
    // internal hook.

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * This function should not be overridden directly, use `_preRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function preRelayedCall(bytes memory context) public virtual override returns (bytes32) {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        return _preRelayedCall(context);
    }

    /**
     * @dev See `IRelayRecipient.preRelayedCall`.
     *
     * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call preprocessing they may wish to do.
     *
     */
    function _preRelayedCall(bytes memory context) internal virtual returns (bytes32);

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * This function should not be overridden directly, use `_postRelayedCall` instead.
     *
     * * Requirements:
     *
     * - the caller must be the `RelayHub` contract.
     */
    function postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) public virtual override {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        _postRelayedCall(context, success, actualCharge, preRetVal);
    }

    /**
     * @dev See `IRelayRecipient.postRelayedCall`.
     *
     * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
     * must implement this function with any relayed-call postprocessing they may wish to do.
     *
     */
    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal virtual;

    /**
     * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
     * will be charged a fee by RelayHub
     */
    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
        return _approveRelayedCall("");
    }

    /**
     * @dev See `GSNRecipient._approveRelayedCall`.
     *
     * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
     */
    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
        return (_RELAYED_CALL_ACCEPTED, context);
    }

    /**
     * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
     */
    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
        return (_RELAYED_CALL_REJECTED + errorCode, "");
    }

    /*
     * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
     * `serviceFee`.
     */
    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
        // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
        // charged for 1.4 times the spent amount.
        return (gas * gasPrice * (100 + serviceFee)) / 100;
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
        // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
        // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
        // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
        // bytes. This can always be done due to the 32-byte prefix.

        // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
        // easiest/most-efficient way to perform this operation.

        // These fields are not accessible from assembly
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    function _getRelayedCallData() private pure returns (bytes memory) {
        // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
        // we must strip the last 20 bytes (length of an address type) from it.

        uint256 actualDataLength = msg.data.length - 20;
        bytes memory actualData = new bytes(actualDataLength);

        for (uint256 i = 0; i < actualDataLength; ++i) {
            actualData[i] = msg.data[i];
        }

        return actualData;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File @animoca/ethereum-contracts-core_library/contracts/payment/PayoutWallet.sol@v3.1.1

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
    @title PayoutWallet
    @dev adds support for a payout wallet
    Note: .
 */
contract PayoutWallet is Ownable
{
    event PayoutWalletSet(address payoutWallet_);

    address payable public payoutWallet;

    constructor(address payoutWallet_) internal {
        setPayoutWallet(payoutWallet_);
    }

    function setPayoutWallet(address payoutWallet_) public onlyOwner {
        require(payoutWallet_ != address(0), "The payout wallet must not be the zero address");
        require(payoutWallet_ != address(this), "The payout wallet must not be the contract itself");
        require(payoutWallet_ != payoutWallet, "The payout wallet must be different");
        payoutWallet = payable(payoutWallet_);
        emit PayoutWalletSet(payoutWallet);
    }
}


// File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0

/*
https://github.com/OpenZeppelin/openzeppelin-contracts

The MIT License (MIT)

Copyright (c) 2016-2019 zOS Global Limited

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


// File @animoca/ethereum-contracts-erc20_base/contracts/metatx/ERC20Fees.sol@v3.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;




/**
    @title ERC20Fees
    @dev a GSNRecipient contract with support for ERC-20 fees
    Note: .
 */
abstract contract ERC20Fees is GSNRecipient, PayoutWallet
{
    enum ErrorCodes {
        INSUFFICIENT_BALANCE,
        RESTRICTED_METHOD
    }

    IERC20 public gasToken;
    uint public gasPriceScaling = _GAS_PRICE_SCALING_SCALE;

    uint internal constant _GAS_PRICE_SCALING_SCALE = 1000;

    /**
     * @dev Constructor function
     */
    constructor(address gasTokenAddress, address payoutWallet) internal PayoutWallet(payoutWallet) {
        setGasToken(gasTokenAddress);
    }

    function setGasToken(address gasTokenAddress) public onlyOwner {
        gasToken = IERC20(gasTokenAddress);
    }

    function setGasPrice(uint gasPriceScaling_) public onlyOwner {
        gasPriceScaling = gasPriceScaling_;
    }

    /**
     * @dev Withdraws the recipient's deposits in `RelayHub`.
     */
    function withdrawDeposits(uint256 amount, address payable payee) external onlyOwner {
        _withdrawDeposits(amount, payee);
    }

/////////////////////////////////////////// GSNRecipient ///////////////////////////////////
    /**
     * @dev Ensures that only users with enough gas payment token balance can have transactions relayed through the GSN.
     */
    function acceptRelayedCall(
        address,
        address from,
        bytes memory,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256,
        uint256,
        bytes memory,
        uint256 maxPossibleCharge
    )
        public
        virtual
        override
        view
        returns (uint256, bytes memory)
    {
        if (gasToken.balanceOf(from) < (SafeMath.mul(maxPossibleCharge, gasPriceScaling) / _GAS_PRICE_SCALING_SCALE)) {
            return _rejectRelayedCall(uint256(ErrorCodes.INSUFFICIENT_BALANCE));
        }

        return _approveRelayedCall(abi.encode(from, maxPossibleCharge, transactionFee, gasPrice));
    }

    /**
     * @dev Implements the precharge to the user. The maximum possible charge (depending on gas limit, gas price, and
     * fee) will be deducted from the user balance of gas payment token. Note that this is an overestimation of the
     * actual charge, necessary because we cannot predict how much gas the execution will actually need. The remainder
     * is returned to the user in {_postRelayedCall}.
     */
    function _preRelayedCall(bytes memory context) internal override returns (bytes32) {
        (address from, uint256 maxPossibleCharge) = abi.decode(context, (address, uint256));

        // The maximum token charge is pre-charged from the user
        require(
            gasToken.transferFrom(from, payoutWallet, SafeMath.mul(maxPossibleCharge, gasPriceScaling) / _GAS_PRICE_SCALING_SCALE),
            "ERC20Fees: pre-charge failed"
        );
    }

    /**
     * @dev Returns to the user the extra amount that was previously charged, once the actual execution cost is known.
     */
    function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal override {
        (address from, uint256 maxPossibleCharge, uint256 transactionFee, uint256 gasPrice) =
            abi.decode(context, (address, uint256, uint256, uint256));

        // actualCharge is an _estimated_ charge, which assumes postRelayedCall will use all available gas.
        // This implementation's gas cost can be roughly estimated as 10k gas, for the two SSTORE operations in an
        // ERC20 transfer.
        uint256 overestimation = _computeCharge(SafeMath.sub(_POST_RELAYED_CALL_MAX_GAS, 10000), gasPrice, transactionFee);
        actualCharge = SafeMath.sub(actualCharge, overestimation);

        // After the relayed call has been executed and the actual charge estimated, the excess pre-charge is returned
        require(
            gasToken.transferFrom(payoutWallet, from, SafeMath.mul(SafeMath.sub(maxPossibleCharge, actualCharge), gasPriceScaling) / _GAS_PRICE_SCALING_SCALE),
            "ERC20Fees: send back change failed"
        );
    }

    /**
     * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
     * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
     */
    function _msgSender() internal virtual override(Context, GSNRecipient) view returns (address payable) {
        return GSNRecipient._msgSender();
    }

    /**
     * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
     * and a reduced version for GSN relayed calls (where msg.data contains additional information).
     *
     * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
     */
    function _msgData() internal virtual override(Context, GSNRecipient) view returns (bytes memory) {
        return GSNRecipient._msgData();
    }
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC721 Non-Fungible Token Standard, basic interface
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 * Note: The ERC-165 identifier for this interface is 0x80ac58cd.
 */
interface IERC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /**
     * @dev Gets the balance of the specified address
     * @param owner address to query the balance of
     * @return balance uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Gets the owner of the specified ID
     * @param tokenId uint256 ID to query the owner of
     * @return owner address currently marked as the owner of the given ID
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return operator address currently approved for the given token ID
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     * @param operator operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner,address operator) external view returns (bool);

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Metadata.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 * Note: The ERC-165 identifier for this interface is 0x5b5e139f.
 */
interface IERC721Metadata {

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory);

    /**
     * @dev Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     * @return string URI of given token ID
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Receiver.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
    @title ERC721 Non-Fungible Token Standard, token receiver
    @dev See https://eips.ethereum.org/EIPS/eip-721
    Interface for any contract that wants to support safeTransfers from ERC721 asset contracts.
    Note: The ERC-165 identifier for this interface is 0x150b7a02.
 */
interface IERC721Receiver {

    /**
        @notice Handle the receipt of an NFT
        @dev The ERC721 smart contract calls this function on the recipient
        after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
        otherwise the caller will revert the transaction. The selector to be
        returned can be obtained as `this.onERC721Received.selector`. This
        function MAY throw to revert and reject the transfer.
        Note: the ERC721 contract address is always the message sender.
        @param operator The address which called `safeTransferFrom` function
        @param from The address which previously owned the token
        @param tokenId The NFT identifier which is being transferred
        @param data Additional data with no specified format
        @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


// File @openzeppelin/contracts/introspection/IERC165.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/introspection/ERC165.sol@v3.2.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC-1155 Multi Token Standard, basic interface
 * @dev See https://eips.ethereum.org/EIPS/eip-1155
 * Note: The ERC-165 identifier for this interface is 0xd9b67a26.
 */
interface IERC1155 {

    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );

    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    event URI(
        string _value,
        uint256 indexed _id
    );

    /**
     * @notice Transfers `value` amount of an `id` from  `from` to `to`  (with safety call).
     * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
     * MUST revert if `to` is the zero address.
     * MUST revert if balance of holder for token `id` is lower than the `value` sent.
     * MUST revert on any other error.
     * MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
     * After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     * @param from    Source address
     * @param to      Target address
     * @param id      ID of the token type
     * @param value   Transfer amount
     * @param data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    /**
     * @notice Transfers `values` amount(s) of `ids` from the `from` address to the `to` address specified (with safety call).
     * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
     * MUST revert if `to` is the zero address.
     * MUST revert if length of `ids` is not the same as length of `values`.
     * MUST revert if any of the balance(s) of the holder(s) for token(s) in `ids` is lower than the respective amount(s) in `values` sent to the recipient.
     * MUST revert on any other error.
     * MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
     * Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
     * After the above conditions for the transfer(s) in the batch are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
     * @param from    Source address
     * @param to      Target address
     * @param ids     IDs of each token type (order and length must match _values array)
     * @param values  Transfer amounts per token type (order and length must match _ids array)
     * @param data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `to`
    */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;

    /**
     * @notice Get the balance of an account's tokens.
     * @param owner  The address of the token holder
     * @param id     ID of the token
     * @return       The _owner's balance of the token type requested
     */
    function balanceOf(address owner, uint256 id) external view returns (uint256);

    /**
     * @notice Get the balance of multiple account/token pairs
     * @param owners The addresses of the token holders
     * @param ids    ID of the tokens
     * @return       The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
     * @dev MUST emit the ApprovalForAll event on success.
     * @param operator Address to add to the set of authorized operators
     * @param approved True if the operator is approved, false to revoke approval
    */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @notice Queries the approval status of an operator for a given owner.
     * @param owner     The owner of the tokens
     * @param operator  Address of authorized operator
     * @return          True if the operator is approved, false if not
    */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155MetadataURI.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC-1155 Multi Token Standard, optional metadata URI extension
 * @dev See https://eips.ethereum.org/EIPS/eip-1155
 * Note: The ERC-165 identifier for this interface is 0x0e89341c.
 */
interface IERC1155MetadataURI {
    /**
     * @notice A distinct Uniform Resource Identifier (URI) for a given token.
     * @dev URIs are defined in RFC 3986.
     * The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
     * The uri function SHOULD be used to retrieve values if no event was emitted.
     * The uri function MUST return the same value as the latest event for an _id if it was emitted.
     * The uri function MUST NOT be used to check for the existence of a token as it is possible for an implementation to return a valid string even if the token does not exist.
     * @return URI string
     */
    function uri(uint256 id) external view returns (string memory);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC721/IERC721Exists.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC721 Non-Fungible Token Standard, optional exists extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 * Note: The ERC-165 identifier for this interface is 0x4f558e79.
 */
interface IERC721Exists {

    /**
     * @dev Checks the existence of an Non-Fungible Token
     * @return bool true if the token belongs to a non-zero address, false otherwise
     */
    function exists(uint256 nftId) external view returns (bool);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155AssetCollections.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC-1155 Multi Token Standard, optional Asset Collections extension
 * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
 * Interface for fungible/non-fungible collections management on a 1155-compliant contract.
 * This proposal attempts to rationalize the co-existence of fungible and non-fungible tokens
 * within the same contract. We consider that there 3 types of identifiers:
 * (a) Fungible Collections identifiers, each representing a set of Fungible Tokens,
 * (b) Non-Fungible Collections identifiers, each representing a set of Non-Fungible Tokens,
 * (c) Non-Fungible Tokens identifiers. 


 * In the same way a fungible token (represented by its balance) belongs to a particular id
 * which can be used to store common information about this token, including the metadata.
 *
 * Note: The ERC-165 identifier for this interface is 0x469bd23f.
 */
interface IERC1155AssetCollections {

    /**
     * @dev Returns whether or not an ID represents a Fungible Collection.
     * @param id The ID to query.
     * @return bool true if id represents a Fungible Collection, false otherwise.
     */
    function isFungible(uint256 id) external view returns (bool);

    /**
     * @dev Returns the parent collection ID of a Non-Fungible Token ID.
     * This function returns either a Fungible Collection ID or a Non-Fungible Collection ID.
     * This function SHOULD NOT be used to check the existence of a Non-Fungible Token.
     * This function MAY return a value for a non-existing Non-Fungible Token.
     * @param id The ID to query. id must represent an existing/non-existing Non-Fungible Token, else it throws.
     * @return uint256 the parent collection ID.
     */
    function collectionOf(uint256 id) external view returns (uint256);

    /**
     * @dev Returns the owner of a Non-Fungible Token.
     * @param nftId The identifier to query. MUST represent an existing Non-Fungible Token, else it throws.
     * @return owner address currently marked as the owner of the Non-Fungible Token.
     */
    function ownerOf(uint256 nftId) external view returns (address owner);

    /**
     * @dev Checks the existence of an Non-Fungible Token
     * @return bool true if the token belongs to a non-zero address, false otherwise
     */
    function exists(uint256 nftId) external view returns (bool);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @title ERC-1155 Multi Token Standard, token receiver
 * @dev See https://eips.ethereum.org/EIPS/eip-1155
 * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
 * Note: The ERC-165 identifier for this interface is 0x4e2312e0.
 */
interface IERC1155TokenReceiver {

    /**
     * @notice Handle the receipt of a single ERC1155 token type.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
     * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
     * This function MUST revert if it rejects the transfer.
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param operator  The address which initiated the transfer (i.e. msg.sender)
     * @param from      The address which previously owned the token
     * @param id        The ID of the token being transferred
     * @param value     The amount of tokens being transferred
     * @param data      Additional data with no specified format
     * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @notice Handle the receipt of multiple ERC1155 token types.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
     * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
     * This function MUST revert if it rejects the transfer(s).
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
     * @param from      The address which previously owned the token
     * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
     * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
     * @param data      Additional data with no specified format
     * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155AssetsInventory.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;








/**
 * @title ERC1155AssetsInventory, a contract which manages up to multiple Collections of Fungible and Non-Fungible Tokens
 * @dev In this implementation, with N representing the Non-Fungible Collection mask length, identifiers can represent either:
 * (a) a Fungible Collection:
 *     - most significant bit == 0
 * (b) a Non-Fungible Collection:
 *     - most significant bit == 1
 *     - (256-N) least significant bits == 0
 * (c) a Non-Fungible Token:
 *     - most significant bit == 1
 *     - (256-N) least significant bits != 0
 */
abstract contract ERC1155AssetsInventory is IERC1155, IERC1155MetadataURI, IERC1155AssetCollections, ERC165, Context
{
    using Address for address;
    using SafeMath for uint256;

    // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;

    // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
    bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;

    // Non-fungible bit. If an id has this bit set, it is a non-fungible (either collection or token)
    uint256 internal constant _NF_BIT = 1 << 255;

    // Mask for non-fungible collection (including the nf bit)
    uint256 internal _NF_COLLECTION_MASK;

    mapping(uint256 => mapping(address => uint256)) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    /**
     * @dev Constructor function
     * @param nfMaskLength number of bits in the Non-Fungible Collection mask. MUST be within [1, 255].
     * If nfMaskLength == 1, there is one Non-Fungible Collection represented by the most significant
     * bit set to 1 and other bits set to 0.
     * If nfMaskLength > 1, there are multiple Non-Fungible Collections encoded on additional bits.
     */
    constructor(uint256 nfMaskLength) internal {
        require(
            nfMaskLength > 0 && nfMaskLength < 256,
            "ERC1155: incorrect non-fugible mask length"
        );
        uint256 mask = (1 << nfMaskLength) - 1;
        mask = mask << (256 - nfMaskLength);
        _NF_COLLECTION_MASK = mask;

        _registerInterface(type(IERC1155).interfaceId);
        _registerInterface(type(IERC1155MetadataURI).interfaceId);
        _registerInterface(type(IERC1155AssetCollections).interfaceId);
        _registerInterface(type(IERC721Exists).interfaceId);
    }

//////////////////////////////////////////// ERC1155 //////////////////////////////////////////////

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override
    {
        address sender = _msgSender();
        bool operatable = (from == sender) || _operatorApprovals[from][sender];

        _beforeSingleTransfer(from, to, id, value, data);

        if (isFungible(id) && value > 0) {
            require(operatable, "ERC1155: transfer by a non-approved sender");
            _transferFungible(from, to, id, value, false);
        } else if (_isNFT(id) && value == 1) {
            _transferNonFungible(from, to, id, operatable, false);
        } else {
            revert("ERC1155: incorrect transfer parameters");
        }

        emit TransferSingle(sender, from, to, id, value);

        _callOnERC1155Received(from, to, id, value, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public virtual override
    {
        require(ids.length == values.length, "ERC1155: inconsistent array lengths");

        address sender = _msgSender();
        bool operatable = (from == sender) || _operatorApprovals[from][sender];

        _beforeBatchTransfer(from, to, ids, values, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 value = values[i];

            if (isFungible(id) && value > 0) {
                require(operatable, "AssetsInventory: transfer by a non-approved sender");
                _transferFungible(from, to, id, value, false);
            } else if (_isNFT(id) && value == 1) {
                _transferNonFungible(from, to, id, operatable, false);
            } else {
                revert("ERC1155: incorrect transfer parameters");
            }
        }

        emit TransferBatch(sender, from, to, ids, values);

        _callOnERC1155BatchReceived(from, to, ids, values, data);
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     */
    function balanceOf(address tokenOwner, uint256 id) public virtual override view returns (uint256) {
        require(tokenOwner != address(0), "ERC1155: balance of the zero address");

        if (_isNFT(id)) {
            return _owners[id] == tokenOwner ? 1 : 0;
        }

        return _balances[id][tokenOwner];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     */
    function balanceOfBatch(
        address[] memory tokenOwners,
        uint256[] memory ids
    ) public virtual override view returns (uint256[] memory)
    {
        require(tokenOwners.length == ids.length, "ERC1155: inconsistent array lengths");

        uint256[] memory balances = new uint256[](tokenOwners.length);

        for (uint256 i = 0; i < tokenOwners.length; ++i) {
            require(tokenOwners[i] != address(0), "ERC1155: balance of the zero address");

            uint256 id = ids[i];

            if (_isNFT(id)) {
                balances[i] = _owners[id] == tokenOwners[i] ? 1 : 0;
            } else {
                balances[i] = _balances[id][tokenOwners[i]];
            }
        }

        return balances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        address sender = _msgSender();
        require(operator != sender, "ERC1155: setting approval to caller");
        _operatorApprovals[sender][operator] = approved;
        emit ApprovalForAll(sender, operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address tokenOwner, address operator) public virtual override view returns (bool) {
        return _operatorApprovals[tokenOwner][operator];
    }

/////////////////////////////////////// ERC1155AssetCollections ////////////////////////////////////////

    /**
     * @dev See {IERC1155AssetCollections-isFungible}.
     */
    function isFungible(uint256 id) public virtual override view returns (bool) {
        return id & (_NF_BIT) == 0;
    }

    /**
     * @dev See {IERC1155AssetCollections-collectionOf}.
     */
    function collectionOf(uint256 nftId) public virtual override view returns (uint256) {
        require(_isNFT(nftId), "ERC1155: collection of incorrect NFT id");
        return nftId & _NF_COLLECTION_MASK;
    }

    /**
     * @dev See {IERC1155AssetCollections-ownerOf}.
     */
    function ownerOf(uint256 nftId) public virtual override view returns (address) {
        require(_isNFT(nftId), "ERC1155: owner of incorrect NFT id");
        address tokenOwner = _owners[nftId];
        require(tokenOwner != address(0), "ERC1155: owner of non-existing NFT");
        return tokenOwner;
    }

    /**
     * @dev See {IERC1155AssetCollections-exists}.
     */
    function exists(uint256 nftId) public virtual override view returns (bool) {
        address tokenOwner = _owners[nftId];
        return tokenOwner != address(0);
    }

/////////////////////////////////////// ERC1155MetadataURI ////////////////////////////////////////

    function uri(uint256 id) external virtual override view returns (string memory) {
        return _uri(id);
    }

/////////////////////////////////////// Metadata Internal /////////////////////////////////////////

    /**
     * @dev (abstract) Internal function which returns an URI for a given identifier
     * @param id uint256 identifier to query
     * @return string the metadata URI
     */
    function _uri(uint256 id) internal virtual view returns (string memory);

////////////////////////////////////// Collections Internal ///////////////////////////////////////

    /**
     * @dev This function creates the collection id.
     * @param collectionId collection identifier
     */
    function _createCollection(uint256 collectionId) internal virtual {
        require(!_isNFT(collectionId), "ERC1155: create collection with wrong id");
        emit URI(_uri(collectionId), collectionId);
    }

    /**
     * @dev Internal function to check whether an identifier represents an NFT
     * @param id The identifier to query
     * @return bool true if the identifier represents an NFT
     */
    function _isNFT(uint256 id) internal virtual view returns (bool) {
        return (id & (_NF_BIT) != 0) && (id & (~_NF_COLLECTION_MASK) != 0);
    }

/////////////////////////////////////// Transfers Internal ////////////////////////////////////////

    /**
     * @dev Internal function to transfer the ownership of an NFT to another address
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the NFT
     * @param to address to receive the ownership of the NFT
     * @param nftId uint256 identifier of the NFT to be transferred
     * @param operatable bool to indicate whether the msg sender is operator
     * @param burn bool to indicate whether this is part of a burn operation
     */
    function _transferNonFungible(
        address from,
        address to,
        uint256 nftId,
        bool operatable,
        bool burn
    ) internal virtual
    {
        if (burn) {
            require(to == address(0), "ERC1155: burn to a non-zero address");
        } else {
            require(to != address(0), "ERC1155: transfer to the zero address");
        }

        require(from == _owners[nftId], "ERC1155: transfer of a non-owned NFT");
        require(operatable, "ERC1155: transfer by a non-approved sender");

        uint256 nfCollection = nftId & _NF_COLLECTION_MASK;
        _balances[nfCollection][from] = _balances[nfCollection][from].sub(1);

        if (!burn) {
            _balances[nfCollection][to] = _balances[nfCollection][to].add(1);
        }

        _owners[nftId] = to;
    }

    /**
     * @dev Internal function to move `collectionId` fungible tokens `value` from `from` to `to`.
     * @param from current owner of the `collectionId` fungible token
     * @param to address to receive the ownership of the given `collectionId` fungible token
     * @param collectionId uint256 ID of the fungible token to be transferred
     * @param value uint256 transfer amount
     * @param burn bool to indicate whether this is part of a burn operation
     */
    function _transferFungible(
        address from,
        address to,
        uint256 collectionId,
        uint256 value,
        bool burn
    ) internal virtual
    {
        if (burn) {
            require(to == address(0), "ERC1155: burn to a non-zero address");
        } else {
            require(to != address(0), "ERC1155: transfer to the zero address");
        }

        _balances[collectionId][from] = _balances[collectionId][from].sub(value);
        if (!burn) {
            _balances[collectionId][to] = _balances[collectionId][to].add(value);
        }
    }

//////////////////////////////////////// Minting Internal /////////////////////////////////////////

    /**
     * @dev Internal function to mint one NFT
     * @param to address recipient that will own the minted token
     * @param nftId uint256 identifier of the NFT to be minted
     * @param data bytes optional data to send along with the call
     * @param safe bool whether to call the receiver interface
     * @param batch bool whether this function is called as part of a batch operation
     */
    function _mintNonFungible(
        address to,
        uint256 nftId,
        bytes memory data,
        bool safe,
        bool batch
    ) internal virtual
    {
        require(!exists(nftId), "ERC1155: minting an existing id");

        if (!batch) {
            require(to != address(0), "ERC1155: minting to the zero address");
            require(_isNFT(nftId), "ERC1155: minting an incorrect NFT id");
            _beforeSingleTransfer(address(0), to, nftId, 1, data);
        }

        uint256 collection = nftId & _NF_COLLECTION_MASK;

        _owners[nftId] = to;
        _balances[collection][to] = _balances[collection][to].add(1);

        if (!batch) {
            emit TransferSingle(_msgSender(), address(0), to, nftId, 1);
        }

        emit URI(_uri(nftId), nftId);

        if (safe && !batch) {
            _callOnERC1155Received(address(0), to, nftId, 1, data);
        }
    }

    /**
     * @dev Internal function to non-safely mint fungible tokens
     * @param to address recipient that will own the minted tokens
     * @param collectionId uint256 identifier of the fungible collection to mint
     * @param value uint256 amount of tokens to mint
     * @param data bytes optional data to send along with the call
     * @param safe bool whether to call the receiver interface
     * @param batch bool whether this function is called as part of a batch mint
     */
    function _mintFungible(
        address to,
        uint256 collectionId,
        uint256 value,
        bytes memory data,
        bool safe,
        bool batch
    ) internal virtual
    {
        if (!batch) {
            require(to != address(0), "ERC1155: minting to the zero address");
            require(value > 0, "ERC1155: minting zero value");
            require(isFungible(collectionId), "ERC1155: minting an incorrect fungible collection id");

            _beforeSingleTransfer(address(0), to, collectionId, value, data);
        }

        _balances[collectionId][to] = _balances[collectionId][to].add(value);

        if (!batch) {
            emit TransferSingle(_msgSender(), address(0), to, collectionId, value);
        }

        if (safe && !batch) {
            _callOnERC1155Received(address(0), to, collectionId, value, data);
        }
    }

    /**
     * @dev Internal function to non-safely mint a batch of new tokens
     * @param to address address that will own the minted tokens
     * @param ids uint256[] identifiers of the tokens to be minted
     * @param values uint256[] amounts of tokens to be minted
     * @param data bytes optional data to send along with the call
     * @param safe bool whether to call the receiver interface
     */
    function _batchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data,
        bool safe
    ) internal virtual
    {
        require(ids.length == values.length, "ERC1155: inconsistent array lengths");
        require(to != address(0), "ERC1155: minting to the zero address");

        bool batch = true;

        for (uint256 i = 0; i < ids.length; i++) {
            if (_isNFT(ids[i]) && values[i] == 1) {
                _mintNonFungible(to, ids[i], data, safe, batch);
            } else if (isFungible(ids[i]) && values[i] > 0) {
                _mintFungible(to, ids[i], values[i], data, safe, batch);
            } else {
                revert("ERC1155: incorrect minting parameters");
            }
        }

        emit TransferBatch(_msgSender(), address(0), to, ids, values);

        if (safe) {
            _callOnERC1155BatchReceived(address(0), to, ids, values, data);
        }
    }

//////////////////////////////////////// Burning Internal /////////////////////////////////////////

    /**
     * @dev Internal function to burn some tokens
     * @param from address the current tokens owner
     * @param id uint256 identifier of the id to burn
     * @param value uint256 the amount of token to burn
     */
    function _burnFrom(
        address from,
        uint256 id,
        uint256 value
    ) internal virtual
    {
        address to = address(0);
        address sender = _msgSender();
        bool operatable = (from == sender) || _operatorApprovals[from][sender];

        _beforeSingleTransfer(from, to, id, value, "");

        if (isFungible(id) && value > 0) {
            require(operatable, "ERC1155: transfer by a non-approved sender");
            _transferFungible(from, to, id, value, true);
        } else if (_isNFT(id) && value == 1) {
            _transferNonFungible(from, to, id, operatable, true);
        } else {
            revert("ERC1155: transfer of a non-fungible collection");
        }

        emit TransferSingle(sender, from, to, id, value);
    }

///////////////////////////////////// Receiver Calls Internal /////////////////////////////////////

    /**
     * @dev Internal function to invoke {IERC1155TokenReceiver-onERC1155Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param id uint256 identifier to be transferred
     * @param value uint256 amount to be transferred
     * @param data bytes optional data to send along with the call
     */
    function _callOnERC1155Received(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) internal
    {
        if (!to.isContract()) {
            return;
        }

        bytes4 retval = IERC1155TokenReceiver(to).onERC1155Received(
            _msgSender(),
            from,
            id,
            value,
            data
        );

        require(
            retval == _ERC1155_RECEIVED,
            "ERC1155: receiver contract refused the transfer"
        );
    }

    /**
     * @dev Internal function to invoke {IERC1155TokenReceiver-onERC1155BatchReceived} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param ids uint256 identifiers to be transferred
     * @param values uint256 amounts to be transferred
     * @param data bytes optional data to send along with the call
     */
    function _callOnERC1155BatchReceived(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) internal
    {
        if (!to.isContract()) {
            return;
        }

        bytes4 retval = IERC1155TokenReceiver(to).onERC1155BatchReceived(
            _msgSender(),
            from,
            ids,
            values,
            data
        );

        require(
            retval == _ERC1155_BATCH_RECEIVED,
            "ERC1155: receiver contract refused the transfer"
        );
    }

/////////////////////////////////////////// Hooks ///////////////////////////////////////

    /**
     * @dev Hook that is called before a single token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `value` * ``from``'s `id` will be
     * transferred to `to`.
     * - when `from` is zero, `value` * `id` will be minted for `to`.
     * - when `to` is zero, `value` * ``from``'s `id` will be burned.
     * - `from` and `to` are never both zero.
     *
     */
    function _beforeSingleTransfer(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes memory data
    ) internal virtual { }

    /**
     * @dev Hook that is called before a batch token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `values` * ``from``'s `ids` will be
     * transferred to `to`.
     * - when `from` is zero, `values` * `ids` will be minted for `to`.
     * - when `to` is zero, `values` * ``from``'s `ids` will be burned.
     * - `from` and `to` are never both zero.
     *
     */
    function _beforeBatchTransfer(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) internal virtual { }
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155721/AssetsInventory.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;





/**
 * @title AssetsInventory, an ERC1155AssetsInventory with additional support for ERC721.
 */
abstract contract AssetsInventory is IERC721, IERC721Metadata, ERC1155AssetsInventory
{
    using SafeMath for uint256;
    using Address for address;

    //bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
    bytes4 constant internal _ERC721_RECEIVED = 0x150b7a02;

    mapping(uint256 => address) internal _nftApprovals;
    mapping(address => uint256) internal _nftBalances;

    constructor(uint256 nfMaskLength) internal ERC1155AssetsInventory(nfMaskLength) {
        _registerInterface(type(IERC721).interfaceId);
        _registerInterface(type(IERC721Metadata).interfaceId);
    }

//////////////////////////////////////// ERC721 ///////////////////////////////////////////////////

    function balanceOf(address tokenOwner) public virtual override view returns (uint256) {
        require(tokenOwner != address(0), "AssetsInventory: balance of the zero address");
        return _nftBalances[tokenOwner];
    }

    function ownerOf(uint256 nftId) public virtual override(IERC721, ERC1155AssetsInventory) view returns (address)
    {
        return super.ownerOf(nftId);
    }

    function approve(address to, uint256 nftId) public virtual override {
        address tokenOwner = ownerOf(nftId);
        require(to != tokenOwner, "AssetsInventory: approve to approved user");

        address sender = _msgSender();
        require(
            (sender == tokenOwner) || _operatorApprovals[tokenOwner][sender],
            "AssetsInventory: approve by non-operator user"
        );

        _nftApprovals[nftId] = to;
        emit Approval(tokenOwner, to, nftId);
    }

    function getApproved(uint256 nftId) public virtual override view returns (address) {
        require(
            _isNFT(nftId) && exists(nftId),
            "AssetsInventory: getting approval of an incorrect or non-existing NFT"
        );
        return _nftApprovals[nftId];
    }

    function isApprovedForAll(
        address tokenOwner,
        address operator
    ) public virtual override(IERC721, ERC1155AssetsInventory) view returns (bool)
    {
        return super.isApprovedForAll(tokenOwner, operator);
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override(IERC721, ERC1155AssetsInventory)
    {
        return super.setApprovalForAll(operator, approved);
    }

    function transferFrom(address from, address to, uint256 nftId) public virtual override {
        _transferFrom(from, to, nftId, "", false);
    }

    function safeTransferFrom(address from, address to, uint256 nftId) public virtual override {
        _transferFrom(from, to, nftId, "", true);
    }

    function safeTransferFrom(address from, address to, uint256 nftId, bytes memory data) public virtual override {
        _transferFrom(from, to, nftId, data, true);
    }

    function tokenURI(uint256 nftId) external virtual override view returns (string memory) {
        require(exists(nftId), "AssetsInventory: token URI of non-existing NFT");
        return _uri(nftId);
    }

/////////////////////////////////////// Transfers Internal ////////////////////////////////////////

    /**
     * @dev Internal function to transfer the ownership of a given NFT to another address
     * Emits Transfer and TransferSingle events
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param nftId uint256 ID of the token to be transferred
     * @param safe bool to indicate whether the transfer is safe
    */
    function _transferFrom(
        address from,
        address to,
        uint256 nftId,
        bytes memory data,
        bool safe
    ) internal virtual
    {
        address sender = _msgSender();
        bool operatable = (from == sender) || _operatorApprovals[from][sender];

        _transferNonFungible(from, to, nftId, operatable, false);

        emit TransferSingle(sender, from, to, nftId, 1);

        // if (to.isContract) {
            _callOnERC721Received(from, to, nftId, data, safe);
        // }
    }

    function _transferNonFungible(
        address from,
        address to,
        uint256 nftId,
        bool operatable,
        bool burn
    ) internal virtual override
    {
        require(
            operatable || (_nftApprovals[nftId] == _msgSender()),
            "ERC1155: transfer of a non-owned NFT"
        );

        _nftApprovals[nftId] = address(0);

        _nftBalances[from] = _nftBalances[from].sub(1);

        if (!burn) {
            _nftBalances[to] = _nftBalances[to].add(1);
        }

        emit Transfer(from, to, nftId);

        super._transferNonFungible(
            from,
            to,
            nftId,
            true,
            burn
        );
    }

//////////////////////////////////////// Minting Internal /////////////////////////////////////////

    function _mintNonFungible(
        address to,
        uint256 nftId,
        bytes memory data,
        bool safe,
        bool batch
    ) internal virtual override
    {
        _nftBalances[to] = _nftBalances[to].add(1);

        emit Transfer(address(0), to, nftId);

        super._mintNonFungible(to, nftId, data, safe, batch);
    }

///////////////////////////////////// Receiver Calls Internal /////////////////////////////////////

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     * First,
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param nftId uint256 identifiers to be transferred
     * @param data bytes optional data to send along with the call
     * @param safe bool whether it is part of a safe transfer
     */
    function _callOnERC721Received(
        address from,
        address to,
        uint256 nftId,
        bytes memory data,
        bool safe
    ) internal
    {
        if (!to.isContract()) {
            return;
        }

        if (_isERC1155TokenReceiver(to)) {
            _callOnERC1155Received(from, to, nftId, 1, data);
        } else {
            if (safe) {
                bytes4 retval = IERC721Receiver(to).onERC721Received(
                    _msgSender(),
                    from,
                    nftId,
                    data
                );
                require(
                    retval == _ERC721_RECEIVED,
                    "AssetsInventory: wrong ERC721Receiver return value"
                );
            }
        }
    }

    /**
     * @dev internal function to tell whether a contract is an ERC1155 Receiver contract
     * @param _contract address query contract addrss
     * @return wheter the given contract is an ERC1155 Receiver contract
     */
    function _isERC1155TokenReceiver(address _contract) internal view returns(bool) {
        bool success;
        uint256 result;
        bytes4 INTERFACE_ID_ERC165 = 0x01ffc9a7;
        bytes4 erc1155ReceiverID = 0x4e2312e0;

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            // Find empty storage location using "free memory pointer"
            let x:= mload(0x40)
            // Place signature at beginning of empty storage
            mstore(x, INTERFACE_ID_ERC165) // ERC165 interfaceId
            // Place first argument directly next to signature
            mstore(add(x, 0x04), erc1155ReceiverID) // ERC1155TokenReceiver interfaceId

            success:= staticcall(
                10000,          // 10k gas
                _contract,     // To addr
                x,             // Inputs are stored at location x
                0x24,          // Inputs are 36 bytes long
                x,             // Store output over input (saves space)
                0x20)          // Outputs are 32 bytes long

            result:= mload(x)                 // Load the result
        }
        // (10000 / 63) "not enough for supportsInterface(...)" // consume all gas, so caller can potentially know that there was not enough gas
        assert(gasleft() > 158);
        return success && result == 1;
    }
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/ICoreMetadataDelegator.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @dev Interface for an Inventory Metadata Delegator.
 */
interface ICoreMetadataDelegator {

    /**
     * @dev Get the address of the delegator contract.
     */
    function coreMetadataImplementer() external view returns (address);
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/ICoreMetadata.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;

/**
 * @dev Interface for retrieving core metadata attributes encoded in an integer
 * and based on a specific bits layout. A layout consists of a mapping of names
 * to bits position inside a uint256. The position is characterised by a length
 * and an index and must remain in the bounds of 256 bits. Positions of a layout
 * may overlap.
 * Note that these functions are expected to work for any integer provided and
 * should not be expected to have knowledge of the existence of a token in a
 * specific contract.
 */
interface ICoreMetadata {

    /**
     * @dev Retrieve the value of a specific attribute for an integer
     * @param integer uint256 the integer to inspect
     * @param name bytes32 the attribute name to retrieve
     * @return value uint256 the value of the attribute
     */
    function getAttribute(
        uint256 integer,
        bytes32 name
    ) external view returns (uint256 value);

    /**
     * @dev Retrieve the value of a specific attribute for an integer
     * @param integer uint256 the integer to inspect
     * @param names bytes32[] the list of attribute names to retrieve
     * @return values uint256[] the values of the attributes
     */
    function getAttributes(
        uint256 integer,
        bytes32[] calldata names
    ) external view returns (uint256[] memory values);

    /**
     * @dev Retrieve the whole core metadata for an integer
     * @param integer uint256 the integer to inspect
     * @return names bytes32[] the names of the metadata attributes
     * @return values uint256[] the values of the metadata attributes
     */
    function getAllAttributes(uint256 integer) external view returns (
        bytes32[] memory names,
        uint256[] memory values
    );
}


// File @animoca/ethereum-contracts-assets_inventory/contracts/metadata/CoreMetadataDelegator.sol@v5.0.0

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;



/**
 * @dev Abstract Core Metadata Delegator contract.
 */
abstract contract CoreMetadataDelegator is ICoreMetadataDelegator, ERC165 {

    address public override coreMetadataImplementer;

    constructor() internal {
        _registerInterface(type(ICoreMetadataDelegator).interfaceId);
    }

    function _setInventoryMetadataImplementer(address implementer) internal {
        require(
            IERC165(implementer).supportsInterface(type(ICoreMetadata).interfaceId),
            "CoreMetadataDelegator: implementer does not implement ICoreMetadata"
        );
        coreMetadataImplementer = implementer;
    }
}


// File contracts/solc-0.6/token/ERC1155721/REVVTrophies.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;





interface MetadataLayoutSetter {
    function setLayout(
        uint256 collectionId,
        bytes32[] calldata names,
        uint256[] calldata lengths,
        uint256[] calldata indices
    ) external;
}

contract REVVTrophies is AssetsInventory, ERC20Fees, CoreMetadataDelegator, MinterRole {
    using UInt256ToDecimalString for uint256;
    using Bytes32ToBase32String for bytes32;

    string public constant override name = "REVV Trophies";
    string public constant override symbol = "REVV-T";
    string private _uriPrefix = "https://revvmotorsport.com/trophies/json/";
    uint256 private constant _nfMaskLength = 32;

    constructor(address gasTokenAddress, address payoutWallet) public AssetsInventory(_nfMaskLength) ERC20Fees(gasTokenAddress, payoutWallet) {}

    function setInventoryMetadataImplementer(address implementer) external onlyOwner {
        _setInventoryMetadataImplementer(implementer);
    }

    /**
     * @dev This function creates the collection id.
     * @param collectionId collection identifier
     */
    function createCollection(
        uint256 collectionId,
        bytes32[] calldata names,
        uint256[] calldata lengths,
        uint256[] calldata indices
    ) external onlyMinter {
        MetadataLayoutSetter(coreMetadataImplementer).setLayout(collectionId, names, lengths, indices);
        _createCollection(collectionId);
    }

    /**
     * @dev Public function to mint a batch of new tokens
     * Reverts if some the given token IDs already exist
     * @param to address[] List of addresses that will own the minted tokens
     * @param ids uint256[] List of ids of the tokens to be minted
     * @param values uint256[] List of quantities of ft to be minted
     */
    function batchMint(
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bool safe
    ) external onlyMinter {
        _batchMint(to, ids, values, "", safe);
    }

    function _uri(uint256 id) internal view override returns (string memory) {
        return string(abi.encodePacked(abi.encodePacked(_uriPrefix, id.toDecimalString())));
    }

    /////////////////////////////////////////// TokenURI////////////////////////////////////

    /**
     * @dev Public function to update the metadata URI prefix
     * @param uriPrefix string the new URI prefix
     */
    function setUriPrefix(string calldata uriPrefix) external onlyOwner {
        _uriPrefix = uriPrefix;
    }

    /////////////////////////////////////////// GSN Context ///////////////////////////////////

    function _msgSender() internal view virtual override(Context, ERC20Fees) returns (address payable) {
        return super._msgSender();
    }

    function _msgData() internal view virtual override(Context, ERC20Fees) returns (bytes memory) {
        return super._msgData();
    }
}
