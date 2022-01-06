// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    // Mapping from token id to the owner of the token
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner address to the number of tokens they own
    mapping(address => Counters.Counter) private _ownedTokensCount;
    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "owner cannot be the null address");
        return _ownedTokensCount[_owner].current();
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        require(_exists(_tokenId), "token does not exist");
        return _tokenOwner[_tokenId];
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC771:minting to zero address");
        require(!_exists(tokenId), "ERC721:token already exists");
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "ERC721:to address cannot be the null address"
        );
        require(
            ownerOf(_tokenId) == _from,
            "ERC721:from address does not own this token"
        );

        _ownedTokensCount[_from].decrement();
        _ownedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        // the person approving is the owner of the token
        address owner = ownerOf(_tokenId);

        // we cant approve sending tokens of the owner to the owner (current caller)
        require(_to != owner, "Error-cannot transfer to the owner");

        //The current caller is the owner of the token
        require(msg.sender == owner, "Error-only the owner can approve");

        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId), "token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}
