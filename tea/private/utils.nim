import std/sugar
import std/unicode

type
  PaddingFn* = (b: uint32) -> uint32

var
  paddingFn*: PaddingFn = (b: uint32) => b

template checkKey*: untyped =
  assert key.len <= 16, "key length overflowed"

proc modifyKey*(key: string): array[4, uint32] {.inline.} =
  var i = 0
  for rune in key.runes:
    result[i] = rune.uint32
    inc i

proc alignData*(data: string): seq[Rune] =
  result = data.toRunes
  result[^1] = paddingFn(result[^1].uint32).Rune


when isMainModule:
  let key = "h，你好"
  var uint32s: array[4, uint32] = modifyKey(key)
  for u in uint32s:
    echo u
