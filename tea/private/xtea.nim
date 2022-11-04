import utils
import std/unicode

proc xteaEncrypt*(data: var array[2, uint32], key: array[4, uint32], round = 32) =
  var
    v0 = data[0]
    v1 = data[1]
    sum = 0'u32
    delta = 0x9E3779B9'u32
    i = 0
  while i < round:
    v0 += ((v1 shl 4) xor (v1 shr 5)) + v1 xor (sum + key[sum and 3])
    sum += delta
    v1 += ((v0 shl 4) xor (v0 shr 5)) + v0 xor (sum + key[sum shr 11 and 3])
    inc i
  data[0] = v0
  data[1] = v1

proc encrypt*(data, key: string, round = 32): string =
  ""

proc xteaDecript*(data: var array[2, uint32], key: array[4, uint32], round = 32) =
  var
    v0 = data[0]
    v1 = data[1]
    sum = 0xC6EF3720'u32
    delta = 0x9E3779B9'u32
    i = 0
  while i < round:
    v1 -= ((v0 shl 4) xor (v0 shr 5)) + v0 xor (sum + key[sum shr 11 and 3])
    sum -= delta
    v0 -= ((v1 shl 4) xor (v1 shr 5)) + v1 xor (sum + key[sum and 3])
    inc i
  data[0] = v0
  data[1] = v1

proc decrypt*(data, key: string, round = 32): string =
  ""
