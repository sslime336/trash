import faces
import tables
import strutils

type
  Text* = object
    content*: string

  Image* = object
    filename*: string
    url*: string
    data*: seq[byte]

  GroupImage* = object
    imageId: string
    md5: seq[byte]
    url: string

  Face* = object
    index: int32
    name: string

  MessageType = enum
    mtText, mtImage, mtGroupImage, mtFace

  IMessageElement = ref object
    case kind: MessageType
    of mtText:
      text: Text
    of mtImage:
      image: Image
    of mtGroupImage:
      groupImage: GroupImage
    of mtFace:
      face: Face


proc newText*(content: string): ref Text =
  result = new Text
  result.content = content

proc newNetImage*(filename, url: string): ref Image =
  result = new Image
  result.filename = filename
  result.url = url

proc newGroupImage*(id: string, md5: seq[byte]): ref GroupImage =
  result = new GroupImage
  result.imageId = id
  result.md5 = md5
  result.url = "http://gchat.qpic.cn/gchatpic_new/1/0-0-" & id[1..36].replace(
      "-", "") & "/0?term=2"


proc newFace*(index: int32): ref Face =
  var name: string = faceMap[index]
  if name == "":
    name = "未知表情"
  result = new Face
  result.index = index
  result.name = name

type
  PrivateMessage* = object
    id: int32
    internalId: int32
    self: int64
    target: int64
    time: int32
    sender: ref Sender
    elements: seq[IMessageElement]

  TempMessage* = object
    id: int32
    groupCode: int64
    groupName: string
    self: int64
    sender: ref Sender
    elements: seq[IMessageElement]

  GroupMessage* = object
    id: int32
    internalId: int32
    groupCode: int64
    groupName: string
    sender: ref Sender
    time: int32
    elements: seq[IMessageElement]

  SendingMessage* = object
    elements: seq[IMessageElement]

  Sender* = object
    uin: int64
    nickname: string
    cardName: string
    isFriend: bool

proc isAnnoymous(sender: ref Sender): bool =
  result = sender.uin == 80_000_000

proc `$`*(msg: ref PrivateMessage): string =
  for elem in msg.elements:
    case elem.kind
    of mtText:
      result.add elem.text.content
    of mtImage:
      result.add " [Image= " & elem.image.filename & " ] "
    of mtFace:
      result.add " [" & elem.face.name & "] "
    else: discard

proc `$`*(msg: ref GroupMessage): string =
  for elem in msg.elements:
    case elem.kind
    of mtText:
      result.add elem.text.content
    of mtImage:
      result.add " [Image= " & elem.image.filename & " ] "
    of mtFace:
      result.add " [" & elem.face.name & "] "
    of mtGroupImage:
      result.add "[Image= " & elem.groupImage.imageId & " ]"
