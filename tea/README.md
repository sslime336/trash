# tea

It's dead. Because I'm lazy :P

English | [简体中文](README.zh-CN.md)

---

TEA(Tiny Encryption Algorithm) implementation in pure nim.

## Notice

This lib is still under development, and the API may change in the future.

And it doesn't work properly.

## What's TEA?

TEA is a block cipher designed by David Wheeler and Roger Needham at the Cambridge Computer Laboratory. It is a 64-bit block cipher with a 128-bit key. It is a Feistel cipher with 64 rounds. The algorithm is public domain.

See in Wiki: <https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm>

## About

Implementation of TEA related algorithms in Nim-lang, and provide some simple APIs.

## Find more about TEA

[**XTEA**](https://en.wikipedia.org/wiki/XTEA) - First version of Block TEA's successor.

[**XXTEA(CBTEA)**](https://en.wikipedia.org/wiki/XXTEA) - Corrected Block TEA's successor.

## Doc

To generate docs, please run `nim doc tea.nim` at project root.
