import utils
import std/unicode

proc teaEncrypt(data: var array[2, uint32], key: array[4, uint32],
    round = 32): array[2, uint32] =
  var
    v0 = data[0]
    v1 = data[1]
    sum = 0'u32
    i = 0
  while i < round:
    v0 += ((v1 shl 4) xor (v1 shr 5)) + v1 xor (sum + key[sum and 3])
    sum += 0x9e3779b9'u32
    v1 += ((v0 shl 4) xor (v0 shr 5)) + v0 xor (sum + key[sum shr 11 and 3])
    inc i
  result[0] = v0
  result[1] = v1

proc encrypt(data, key: string, round = 32): string =
  let
    modifiedKey = modifyKey(key)
    alignedData = alignData(data)
  var
    f: int
    runeBuf: array[2, uint32]
  for datacut in alignedData:
    if f == 2:
      let encryptedCut = teaEncrypt(runeBuf, modifiedKey, round)
      result.add encryptedCut[0].Rune
      result.add encryptedCut[1].Rune
      f = 0
    runeBuf[f] = datacut.uint32
    inc f


proc teaDecrypt(data: var array[2, uint32], key: array[4, uint32], round = 32): array[2, uint32]=
  var
    v0 = data[0]
    v1 = data[1]
    sum = 0xc6ef3720'u32
    i = 0
  while i < round:
    v1 -= ((v0 shl 4) xor (v0 shr 5)) + v0 xor (sum + key[sum shr 11 and 3])
    sum -= 0x9e3779b9'u32
    v0 -= ((v1 shl 4) xor (v1 shr 5)) + v1 xor (sum + key[sum and 3])
    inc i
  result[0] = v0
  result[1] = v1

proc decrypt(data, key: string, round = 32): string = 
  let
    modifiedKey = modifyKey(key)
    alignedData = alignData(data)
  var
    f: int
    runeBuf: array[2, uint32]
  for datacut in alignedData:
    if f == 2:
      let encryptedCut = teaDecrypt(runeBuf, modifiedKey, round)
      result.add encryptedCut[0].Rune
      result.add encryptedCut[1].Rune
      f = 0
    runeBuf[f] = datacut.uint32
    inc f

when isMainModule:
  assert decrypt(encrypt("123", "23"), "23") == "123"
