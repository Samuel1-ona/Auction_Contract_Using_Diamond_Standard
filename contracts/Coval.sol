// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Coval is ERC1155 {
    using Strings for uint256;

    uint256 private currentTokenId;
    mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC1155("URI") {}

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            tokenIdToLevels[tokenId].toString(),
            "</text>",
            "</svg>"
        );
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function mint() public {
        currentTokenId++;
        _mint(msg.sender, currentTokenId, 1, "");
        tokenIdToLevels[currentTokenId] = 0;
        _setURI(generateCharacter(currentTokenId));
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return generateCharacter(tokenId);
    }
}
