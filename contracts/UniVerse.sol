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

    IERC20 public UniverseToken;

    uint256 public constant MAX_ELEMENTS = 1000;
    uint256 public PRICE = 5 * 10**20; //TODO: update price
    uint256 public constant MAX_BY_MINT = 20;
    uint256 public constant MAX_BY_OWNER = 20;
    address public constant creatorAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    address public constant devAddress = 0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652; // TODO: update
    string public baseTokenURI;
    address[] public _whitedList;
    bool private isDistribute = true;

    mapping(uint256 => uint) public tokenRate;   // address => rate
    
    event CreateUniverse(uint256 indexed id);
    constructor(string memory baseURI, IERC20 _token) ERC721("UniVerse", "UNIV") {
        UniverseToken = _token;
        setBaseURI(baseURI);
        tokenRate[0] = 5;
        tokenRate[1] = 8;
        tokenRate[2] = 6;
        _whitedList.push(owner());
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

    function isWhitedList(address _address) public view returns(bool) {
        uint256 i = 0;
        for (i = 0; i < _whitedList.length; i++){
            if (_address == _whitedList[i]){
                return true;
            }
        }
        return false;
    }

    function setWhitedList(address[] memory row) external onlyOwner {
        require(row.length<101, "100 limit");
        _whitedList = row;
    }

    function removeWhiteList() public onlyOwner {
        _whitedList = new address[](100);
    }

    function _totalSupply() internal view returns (uint) {
        return _tokenIdTracker.current();
    }
    function totalMint() public view returns (uint256) {
        return _totalSupply();
    }
    function mint(address payable _to) public  onlyWhitedListMemeber saleIsOpen {
        // require(UniverseToken.balanceOf(_to) > 0, "You have the UniverseToken at least 1");
        uint256 total = _totalSupply();
        require(total + 1 <= MAX_ELEMENTS, "Max limit");
        require(total <= MAX_ELEMENTS, "Sale end");
        require(balanceOf(_to) < 2, "User only mint 1 NFTs");
        require(UniverseToken.balanceOf(msg.sender) > PRICE, "Your amount is low than price");
        UniverseToken.transferFrom(msg.sender, address(this), PRICE);
        _mintAnElement(_to);
    }
    function _mintAnElement(address _to) private {
        uint id = _totalSupply();
        _tokenIdTracker.increment();
        _mint(_to, id);
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

    function upgradToken(uint256 _id) external onlyOwner {  //TODO: update furture;
        require(tokenRate[_id] <= 8, "maximum upgrade");
        _burn(_id);
        _mint(ownerOf(_id), _id.add(MAX_ELEMENTS));
    }

    function distribute(uint256 _amount) internal isEnableDistribute {
        uint256 markertingAmount = _amount.mul(197).div(1000);
        uint256 distributeAmount = _amount.mul(803).div(1000);
        uint256 basicRate = 5;
        UniverseToken.transferFrom(marketingAddress, address(this), markertingAmount);
        for(uint i = 0; i< _totalSupply(); i++){
          address _address = ownerOf(i);
          basicRate = tokenRate[i];
          if(rewardPerUser[_address] == 0) {
            rewardPerUser[_address] = rewardAmount(basicRate, distributeAmount);
          }
          else {
            rewardPerUser[_address] = rewardPerUser[_address].add(rewardAmount(basicRate, distributeAmount));
          }
        }
    }

    function rewardWithdraw() external returns (bool) {
        require(rewardPerUser[msg.sender] > 0, "Reward is very small");
        uint256 reward = rewardPerUser[msg.sender];
        UniverseToken.transferFrom(address(this), msg.sender, reward);
        rewardPerUser[msg.sender] = 0;
        return true;
    }
}
