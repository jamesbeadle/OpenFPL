# http-loopback

## Description
"a Motoko agent for the Internet Computer"

This is my attempt at recreating Rocklabs' IC-PY Python Agent in Motoko.

This package enables Motoko canisters to call other canisters using the Http Outcalls feature of the Internet Computer.

## Changelog
v0.2.0 - Breaking change to State type and methods to allow for type migrations

## Major Dependencies
tecdsa - Allows you to generate and manage Threshold ECDSA identities

https://mops.one/tecdsa

utilities - Provides convenient classes for nonce generation and fee management

https://mops.one/utilities

## CAUTION
I'm publishing this package because it *seems* to work fine and I want to share with others.

I've marked this as an alpha release because I have done very little testing outside of making a simple query and update call.

Any and all feedback would be appreciated. I plan to update documentation as soon as I can.

## Example
Please see the "test/" directory for an example:

https://github.com/bittoko/http-loopback/tree/main/test

I have deployed the test canister on mainnet and it *seems* to work fine.