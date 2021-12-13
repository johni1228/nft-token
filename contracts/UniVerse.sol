// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721Pausable.sol";
import "./RewardSystem.sol";
import "./Token.sol";

contract UniVerse is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable, RewardSystem {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    // Token public UniverseToken;

    uint256 public constant MAX_ELEMENTS = 1000;
    uint256 public PRICE = 5 * 10**20; //TODO: update price
    uint256 public constant MAX_BY_MINT = 20;
    uint256 public constant MAX_BY_OWNER = 20;
    address public constant creatorAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    address public constant devAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    string public baseTokenURI;
    address[] public _whitedList;
    bool private isDistribute = true;

    mapping(address => uint) public ownerRate;   // address => rate
    mapping(uint => address) public tokenOwner;  // id => address

    event CreateUniverse(uint256 indexed id);
    constructor(string memory baseURI) ERC721("UniVerse", "UNIV") {
        // UniverseToken = _token;
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

    modifier isEnableDistribute {
        require(isDistribute == true);
        _;
    }

    
    modifier onlyWhitedListMemeber {
        require(isWhitedList(_msgSender()), "This address doesn't include in whitelist");
        _;
    }
    
    function triggerDistribute(bool _isDistribute) external onlyOwner {
        isDistribute = _isDistribute;
    }

    function isWhitedList(address someone) public view returns(bool) {
        uint256 initialization = 0;
        for (initialization = 0; initialization < _whitedList.length; initialization++){
            if (someone == _whitedList[initialization]){
                return true;
            }
        }
        return false;
    }

    function setWhitedList(address[] memory row) private onlyOwner {
        require(row.length<101, "100 limit");
        _whitedList = row;
    }

    function removeWhiteList() private onlyOwner{
        address[] memory removeList;
        _whitedList = removeList;
        return true;
    }

    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }
    function totalMint() public view returns (uint256) {
        return _totalSupply();
    }
    function mint(address _to) public payable onlyWhitedListMemeber saleIsOpen {
        // require(UniverseToken.balanceOf(_to) > 0, "You have the UniverseToken at least 1");
        uint256 total = _totalSupply();
        require(total + 1 <= MAX_ELEMENTS, "Max limit");
        require(total <= MAX_ELEMENTS, "Sale end");
        require(balanceOf(_to) < 2, "User only mint 1 NFTs");
        _mintAnElement(_to);
    }
    function _mintAnElement(address _to) private {
        uint id = _totalSupply();
        _tokenIdTracker.increment();
        _safeMint(_to, id);
        distribute(PRICE);
        emit CreateUniverse(id);
    }

    function setPrice(uint256 _price) public onlyOwner {
        PRICE = _price;
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

    function upgradToken(address memory _address) external onlyOwner {  //TODO: update furture;
        require(ownerRate[_address] <= 8, "maximum upgrade");
        removeToken(_address);
        mint(_address);
        ownerRate[_address]++;
    }

    function distribute(uint256 _amount) internal view isEnableDistribute {
        uint256 markertingAmount = _amount.mul(197).min(1000);
        uint256 distributeAmount = _amount.mul(803).min(1000);
        uint256 basicRate = 5;
        for(uint i = 0; i< _totalSupply(); i++){
          address _address = tokenOwner[i];
          basicRate = ownerRate[_address];
          rewardPerUser[_address] =rewardPerUser[_address].add(rewardAmount(basicRate, distributeAmount));
        }
    }

    function removeToken(address _address) private returns (bool) {   //TODO: will update furture
        TransferFrom(_address, "zero-address");
        return true;
    }
}
