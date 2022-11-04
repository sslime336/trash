## `tea` provides some easy to use APIs for encrypting and decrypting
## with TEA related algorithms. Also provides a simple API for
## constomizing your own padding function.

import private/[tea, xtea, xxtea, utils]

import std/base64
import std/sugar

runnableExamples:
  let
    data = "Have a nice day! 为美好世界献上祝福!"
    key = "Explosion!!!"
    encryptedData = encrypt(data, key)
    readableEncryptedData = makeReadable(encryptedData)
  echo "origin data: " & data
  echo "ater encrypt: " & encryptedData
  echo "make it readable: " & readableEncryptedData

  # assert decrypt(encryptedData, key) == data

proc makeReadable*(s: string): string =
  ## Since after encryption the string is not readable, this function
  ## is used to make the result readable encoded by base64.
  result = encode(s)

proc getRaw*(s: string): string =
  ## getRaw returns the raw representation of the encrypted string.
  ## Attention, decoded string may be unreadable.
  result = decode(s)

type
  Algorithm* = enum ## Algorithm used for encryption,
                    ## default is XXTEA which is also called CBTEA.
    TEA, XTEA, XXTEA, CBTEA

var selectedAlgorithm = XXTEA # default algorithm

proc useAlgorithm*(algorithm: Algorithm) =
  ## Available algorithms are TEA, XTEA, XXTEA and CBTEA.
  ## Notice that XXTEA is the default algorithm and
  ## CBTEA is the same as XXTEA.
  selectedAlgorithm = algorithm

#TODO: add a macro to generate PaddingFn?

proc setPaddingFn*(fn: uint32 -> uint32) =
  ## setPadFn is used to set the padding function when encrypting.
  ## Default padding function does nothing.
  paddingFn = fn

proc encrypt*(data, key: string, round = 32): string =
  ## Encrypt data with key and return the encrypted string.
  ## The default round is 32 using XXTEA algorithm.
  checkKey
  case selectedAlgorithm
  of TEA:
    result = tea.encrypt(data, key, round, paddingFn)
  of XTEA:
    result = xtea.encrypt(data, key, round, paddingFn)
  of XXTEA, CBTEA:
    result = xxtea.encrypt(data, key, round, paddingFn)

proc decrypt*(data, key: string, round = 32): string =
  ## Decrypt data with key and return the decrypted string.
  ## The default round is 32 using XXTEA algorithm.
  checkKey
  case selectedAlgorithm
  of TEA:
    result = tea.decrypt(data, key, round)
  of XTEA:
    result = xtea.decrypt(data, key, round)
  of XXTEA, CBTEA:
    result = xxtea.decrypt(data, key, round)
