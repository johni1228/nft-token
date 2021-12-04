// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721Pausable.sol";
contract UniVerse is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    uint256 public constant MAX_ELEMENTS = 1000;
    uint256 public constant PRICE = 5 * 10**16; //TODO: update price
    uint256 public constant MAX_BY_MINT = 20;
    uint256 public constant MAX_BY_OWNER = 20;
    address public constant creatorAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    address public constant devAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    string public baseTokenURI;
    address[] public _whitedList;

    event CreateUniverse(uint256 indexed id);
    constructor(string memory baseURI) ERC721("UniVerse", "UNIV") {
        setBaseURI(baseURI);
        pause(true);
    }

    modifier saleIsOpen {
        require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
        if (_msgSender() != owner()) {
            require(!paused(), "Pausable: paused");
        }
        _;
    }

    modifier onlyWhitedListMemeber {
        require(isWhitedList(_msgSender()), "This address doesn't include in whitelist");
        _;
    }

    function isWhitedList(address someone) public view returns(bool) {
        uint256 initialization;
        for (initialization = 0; initialization < _whitedList.length; initialization++){
            if (someone == _whitedList[initialization]){
                return true;
            }
        }
        return false;
    }

    function setWhitedList(address[] memory row) public payable onlyOwner {
        _whitedList = row;
    }

    function removeWhiteList() public payable onlyOwner returns (bool) {
        address[] memory removeList;
        _whitedList = removeList;
        return true;
    }

    function getWhitedList() internal view returns (address[] memory) {
        return _whitedList;
    }

    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }
    function totalMint() public view returns (uint256) {
        return _totalSupply();
    }
    function mint(address _to) public payable onlyWhitedListMemeber saleIsOpen {
        uint256 total = _totalSupply();
        require(total + 1 <= MAX_ELEMENTS, "Max limit");
        require(total <= MAX_ELEMENTS, "Sale end");
        require(msg.value >= price(1), "Value below price");
        // uint256 ownedNftCount = balanceOf(_to);
        // require(ownedNftCount + _count <= MAX_BY_OWNER, "Can't have more than 20 NFTs");
        _mintAnElement(_to);
    }
    function _mintAnElement(address _to) private {
        uint id = _totalSupply();
        _tokenIdTracker.increment();
        _safeMint(_to, id);
        emit CreateUniverse(id);
    }
    function price(uint256 _count) public pure returns (uint256) {
        return PRICE.mul(_count);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }

    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function pause(bool val) public onlyOwner {
        if (val == true) {
            _pause();
            return;
        }
        _unpause();
    }

    function withdrawAll() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(devAddress, balance.mul(35).div(100));
        _widthdraw(creatorAddress, address(this).balance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
}
