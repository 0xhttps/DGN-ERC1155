# DGN-ERC1155
# Created by DGNs
# https://twitter.com/dgn_alpha

This is an experimental contract made to build with.
Functions included allow you to:
- Create new tokens after deployment.
- Set maxSupply, publicMintLimit, tokenURI, whiteList, public/whitelist mint after deployment.

New additions to this contract are pausible. Ideas below:
 - Make mint payable, add a price variable to TokenInformation struct. Set it while setting supply?
    - make sure to create a withdraw function if doing the above.
 - Only let contract owner set supply of a given token once(adds transparency).
 - Only let a certain amount of tokens be made (adds transparency).
 - Use merkleroot to set WL instead of the given _setTokenWhitelist function(cheaper gas to WL).
 - Create seperate mint functions for public mint and whitelist mint (not needed but could be useful).
