// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Food.sol";
import "./Market.sol";

contract Pet is ERC721 {
    Food private _food;
    mapping(uint256 => uint256) private _starve;
    mapping(address => uint256[]) private _petsOf;
    mapping(uint256 => string) private _images;

    modifier onlyToken() {
        require(
            _msgSender() == address(_food),
            "Only token is allowed to perform this operation"
        );
        _;
    }

    constructor(Food food_) ERC721("Pet", "PET") {
        _food = food_;
    }

    function food() public view returns (Food) {
        return _food;
    }

    function petsOf(address owner) public view returns (uint256[] memory) {
        return _petsOf[owner];
    }

    function imageOf(uint256 tokenId) public view returns (string memory) {
        return _images[tokenId];
    }

    function mint(string memory imageUrl) external {
        uint256 tokenId = getTokenId(msg.sender, imageUrl);
        _safeMint(_msgSender(), tokenId);
        _images[tokenId] = imageUrl;
        _starve[tokenId] = block.timestamp + 4 hours;
    }

    function feed(uint256 tokenId) external onlyToken {
        require(_starve[tokenId] > block.timestamp, "Pet is death");
        _starve[tokenId] = block.timestamp + 4 hours;
    }

    function getTokenId(address owner, string memory imageUrl)
        public
        pure
        returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(owner, imageUrl)));
    }
}
