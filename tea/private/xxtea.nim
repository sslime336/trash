import utils

template mx(z, y: uint32, p: int, sum: uint32, key: array[4, uint32]): uint32 =
  ((z shr 5) xor (y shl 2)) +
  ((y shr 3) xor (z shl 4)) xor (sum xor y) +
  (key[p.uint32 and 3 xor e] xor z)

let delta = 0x9e3779b9'u32

proc cbtea(data: var array[2, uint32], n: var int, key: array[4, uint32]) =
  var
    y, z, sum: uint32
    rounds, e: uint32
  if n > 1:
    rounds = 6 + (52 / n).uint32
    sum = 0
    z = data[n-1]
    while rounds > 0:
      sum += delta
      e = (sum shr 2) and 3
      for p in 0..<n-1:
        y = data[p+1]
        data[p] += mx(z, y, p, sum, key)
        z = data[p]
      y = data[0]
      data[n-1] += ((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4)) xor (
          sum xor y) + (key[z and 3 xor e] xor z)
      z = data[n-1]
      dec rounds
  elif n < -1:
    n = -n
    rounds = 6 + (52 / n).uint32
    sum = rounds * delta
    y = data[0]
    while rounds > 0:
      e = (sum shr 2) and 3
      for p in n-1..0:
        z = data[p-1]
        data[p] -= ((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4)) xor (
            sum xor y) + (key[p.uint32 and 3 xor e] xor z)
        y = data[p]
      z = data[n-1]
      data[0] -= ((z shr 5) xor (y shl 2)) + ((y shr 3) xor (z shl 4)) xor (
          sum xor y) + (key[y.uint32 and 3 xor e] xor z)
      y = data[0]
      dec sum
      dec rounds

proc encrypt*(data, key: string, round = 32, paddingFn: PaddingFn): string =
  ""

proc decrypt*(data, key: string, round = 32): string =
  ""
