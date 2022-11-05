import std/net

type
  Block = object
    size: int
    data: string

  Cmd = enum
    Get, Set, Del

  Status* = enum
    Ok, NotFound, Error, Fail, ClientError

type
  SSDBClient = ref object
    sock: Socket
    recvBuf: string

proc newSSDBClient*(host: string, port: Port): SSDBClient =
  result = new SSDBClient
  result.sock = newSocket()
  result.sock.connect(host, port)

proc send(client: SSDBClient, cmd: Cmd, args: seq[string]) =
  case cmd
  of Get:
    client.sock.send:
      "3\n" &
      "get\n" &
      $args[0].len & "\n" &
      args[0] & "\n" &
      "\n"
  of Set:
    client.sock.send:
      "3\n" &
      "set\n" &
      $args[0].len & "\n" &
      args[0] & "\n" &
      $args[1].len & "\n" &
      args[1] & "\n" &
      "\n"
  else: discard
  var buf: array[4096, byte]
  let n = client.sock.recv(buf[0].addr, 4096)
  _ = n

proc get*(client: SSDBClient, key: string): string =
  client.send(Get, @[key])
  result = client.recvBuf

proc set*(client: SSDBClient, key, value: string) =
  client.send(Set, @[key, value])


when isMainModule:
  var client = newSSDBClient("127.0.0.1", Port(8888))
  echo client.get("key")

