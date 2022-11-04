import net
import times

type
  Writer = ref object
    buf: seq[byte]

# write raw data
proc write*(w: Writer, b: seq[byte]) =
  w.buf.add(b)

# write a byte
proc write*(w: Writer, b: byte) =
  w.buf.add(b)

# write an uint16
proc write*(w: Writer, v: uint16) =
  var b = newSeq[byte](2)
  b[0] = byte(v shr 8)
  b[1] = byte(v)
  w.write(b)

# write a uint32
proc write*(w: Writer, v: uint32) =
  var b = newSeq[byte](4)
  b[0] = byte(v shr 24)
  b[1] = byte(v shr 16)
  b[2] = byte(v shr 8)
  b[3] = byte(v)
  w.write(b)

# write an uint64
proc write*(w: Writer, v: uint64) =
  var b = newSeq[byte](8)
  b[0] = byte(v shr 56)
  b[1] = byte(v shr 48)
  b[2] = byte(v shr 40)
  b[3] = byte(v shr 32)
  b[4] = byte(v shr 24)
  b[5] = byte(v shr 16)
  b[6] = byte(v shr 8)
  b[7] = byte(v)
  w.write(b)

proc toBytesSeq(s: string): seq[byte] =
  result = newSeq[byte](s.len)
  for ch in s:
    result.add(byte(ch))

# write a string
proc write*(w: Writer, v: string) =
  w.write(uint32(v.len + 4))
  w.write(v.toBytesSeq)

# write a bool
proc write*(w: Writer, b: bool) =
  if b: w.write(byte(1))
  else: w.write(byte(0))

# write a TLV
proc writeTlv*(w: Writer, data: seq[byte]) =
  w.write(data.len.uint16)
  w.write(data)

proc t1*(uin: uint32, ip: seq[byte]): seq[byte] {.inline.} =
  assert ip.len == 4
  let w = new Writer
  w.write(0x01'u16)
  w.writeTlv:
    let tw = new Writer
    tw.write(1'u16)
    #TODO rand.uint32()
    tw.write( #[rand uint32]#
    "")
    tw.write(uin)
    tw.write(uint32((now().nanosecond()).float / 1e6))
    tw.write(ip)
    tw.write(0'u16)
    tw.buf
  result = w.buf

proc t2*(res: string, sign: seq[byte]): seq[byte] {.inline.} =
  let w = new Writer
  w.write(0x02'u16)
  w.writeTlv:
    let tw = new Writer
    tw.write(0x0'u16)
    tw.write(res)
    tw.writeTlv(sign)
    tw.buf
  result = w.buf

proc t100*(): seq[byte] {.inline.} = discard

proc t104*(): seq[byte] {.inline.} = discard

proc t106*(): seq[byte] {.inline.} = discard

proc t107*(): seq[byte] {.inline.} = discard

proc t109*(): seq[byte] {.inline.} = discard

proc t116*(): seq[byte] {.inline.} = discard

proc t124*(): seq[byte] {.inline.} = discard

proc t128*(): seq[byte] {.inline.} = discard

proc t141*(): seq[byte] {.inline.} = discard

proc t142*(): seq[byte] {.inline.} = discard

proc t144*(): seq[byte] {.inline.} = discard

proc t145*(): seq[byte] {.inline.} = discard

proc t147*(): seq[byte] {.inline.} = discard

proc t154*(): seq[byte] {.inline.} = discard

proc t166*(): seq[byte] {.inline.} = discard

proc t16e*(): seq[byte] {.inline.} = discard

proc t177*(): seq[byte] {.inline.} = discard

proc t18*(): seq[byte] {.inline.} = discard

proc t187*(): seq[byte] {.inline.} = discard

proc t188*(): seq[byte] {.inline.} = discard

proc t191*(): seq[byte] {.inline.} = discard

proc t194*(): seq[byte] {.inline.} = discard


proc t202*(): seq[byte] {.inline.} = discard

proc t511*(): seq[byte] {.inline.} = discard

proc t516*(): seq[byte] {.inline.} = discard

proc t521*(): seq[byte] {.inline.} = discard

proc t525*(): seq[byte] {.inline.} = discard

proc t52d*(): seq[byte] {.inline.} = discard

proc t536*(): seq[byte] {.inline.} = discard

proc t8*(): seq[byte] {.inline.} = discard
