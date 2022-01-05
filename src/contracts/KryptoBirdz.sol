// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBird is ERC721Connector {
    string[] public KryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptobird) public {
        require(!_kryptoBirdzExists[_kryptobird], "Kryptobird already exists");

        KryptoBirdz.push(_kryptobird);
        uint256 _id = uint256(KryptoBirdz.length) - 1;
        _mint(msg.sender, _id);
        _kryptoBirdzExists[_kryptobird] = true;
    }

    constructor() ERC721Connector("KryptoBird", "KBIRDZ") {}
}
