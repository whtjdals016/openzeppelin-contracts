// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2 (token/ERC721/extensions/ERC721Revealable.sol)

pragma solidity ^0.8.0;

import "../ERC721.sol";

/**
 * @dev ERC721 token with revealable feature.
 *
 * NFT projects often do a launching first, and later reveal the contents by changing baseUri.
 * However, having a funciton that could change the baseUri could be dangerous, given the
 * content could change after buying or minting the tokens without notice to the owners.
 * ERC721Revealable is inspired by Initializable, that it allows once to "reveal" the contents
 * after a successful public sale, while once revealed, the baseUri cannot be changed anymore,
 * protecting the owners from any potential harm caused by changing the baseUri.
 */
abstract contract ERC721Revealable is ERC721 {
    /**
     * @dev Indicates that the contract has been revealed.
     */
    bool private _revealed;

    /**
     * @dev Indicates that the contract is in the process of being revealed.
     */
    bool private _revealing;

    /**
     * @dev Modifier to protect an reveal function from being invoked twice.
     */
    modifier revealer() {
        require(_revealing || !_revealed, "Revealable: contract is already revealed!");

        bool isTopLevelCall = !_revealing;
        if (isTopLevelCall) {
            _revealing = true;
            _revealed = true;
        }

        _;

        if (isTopLevelCall) {
            _revealing = false;
        }
    }

    /**
     * @dev Function to reveal the real contents by updating the baseUri, 
     * but the function can be called only once.
     */
    function _reveal(string memory baseURI) external revealer {
        _setBaseURI(baseURI);
    }

    /**
     * @dev Private function to set baseUri.
     */
    function _setBaseURI(string memory baseURI) private {}
}

