import std/strutils
import std/random
import md5
import net
import tables
import message

type
  BytesBuffer* = distinct string

  Decoder = proc(qqcli: ref QQClient, data: BytesBuffer): auto
  Handler = proc(qqcli: ref QQClient, data: BytesBuffer): auto

  QQClient = object
    uin: int64
    passwordMd5: array[16, byte]

    nickname: string
    age: uint16
    gender: uint16
    friendList: seq[ref FriendInfo]
    groupList: seq[ref GroupInfo]

    sequenceId: uint16
    outGoingPacketSessionId: BytesBuffer
    randomKey: seq[byte]
    sock: Socket

    decoders: TableRef[string, Decoder]
    handlers: TableRef[string, Handler]

    syncCookie: BytesBuffer
    pubAccountCookie: BytesBuffer
    msgCtrlBuf: BytesBuffer
    ksid: BytesBuffer
    t104: BytesBuffer
    t149: BytesBuffer
    t150: BytesBuffer
    t528: BytesBuffer
    t530: BytesBuffer
    rollbackSig: BytesBuffer
    timeDiff: int64
    sigInfo: ref LoginSigInfo
    pwdFlag: bool
    running: bool

    lastMessageSeq: int32
    requestPacketRequestId: int32
    messageSeq: int32
    groupDataTransSeq: int32

    privateMessageHandlers: seq[PrivateMessageHandler]
    groupMessageHandlers: seq[GroupMessageHandler]

  PrivateMessageHandler = proc(qqcli: ref QQClient, pm: ref PrivateMessage)
  GroupMessageHandler = proc(qqcli: ref QQClient, gm: ref GroupMessage)

  LoginSigInfo = object
    loginBitmap: uint64
    tgt: BytesBuffer
    tgtKey: BytesBuffer

    userStKey: BytesBuffer
    userStWebSig: BytesBuffer
    sKey: BytesBuffer
    d2: BytesBuffer
    d2Key: BytesBuffer
    wtSeesionTicketKey: BytesBuffer
    deviceToken: BytesBuffer

  LoginError* = object of CatchableError

  DeciveLockError* = object of LoginError
  OtherLoginError* = object of LoginError
  NeedCaptchaError* = object of LoginError
  UnknownLoginError* = object of LoginError
  AlreadyRunningError* = object of LoginError

  LoginResponse* = object
    success: bool
    error: LoginError

    captchaImage: BytesBuffer
    captchSign: BytesBuffer

    errorMessage: string

  FriendInfo* = object
    uin: int64
    nickname: string
    remark: string
    faceId: int16

  FriendListResponse* = object
    totalCount: int32
    list: seq[ref FriendInfo]

  GroupInfo* = object
    uin: int64
    code: int64
    name: string
    memo: string
    ownerUin: uint32
    memberCount: uint
    maxMemberCount: uint16
    members: seq[GroupMemberInfo]

  GroupMemberInfo* = object
    uin: int64
    nickname: string
    cardName: string
    level: uint16
    joinTime: int64
    lastSpeakTime: int64
    specialTitle: string
    specialTitleExpireTime: int64
    job: string

  # unexported
  GroupMemberListResponse = object
    nexUin: int64
    list: seq[GroupMemberInfo]

  GroupImageUploadResponse = object
    resultCode: int32
    message: string
    isExists: bool

    uploadKey: BytesBuffer
    uploadIp: seq[int32]
    uploadPort: seq[int32]

# overload
proc toBytesBuffer*(str: string): BytesBuffer =
  result = BytesBuffer(str)

proc toBytesBuffer*(byteSeq: seq[byte]): BytesBuffer =
  for byteitem in byteSeq:
    result.string.add(byteitem.char)

proc newClient*(uin: int64, pwd: string): ref QQClient =
  result = new QQClient
  result.uin = uin
  result.passwordMd5 = block:
    let md5digest = getMd5(pwd)
    var pwdmd5: array[16, byte]
    for i in 0..<md5digest.len:
      pwdmd5[i] = md5digest[i].byte
    pwdmd5
  result.sequenceId = 0x3635
  result.outGoingPacketSessionId = @[0x02'u8, 0xb0, 0x5b, 0x8b].toBytesBuffer
  result.decoders = newTable[string, Decoder](16)
  result.handlers = newTable[string, Handler](16)
  result.sigInfo = new LoginSigInfo
  result.requestPacketRequestId = 1921334513
  result.messageSeq = 22911
  result.ksid = "|454001228437590|A8.2.7.27f6ea96".toBytesBuffer
  #TODO rand

