import std/tables

const
  delta* = 0x9e3779b9'u32
  fillnor* = 0xf8

type
  RequestPacket* = object
    iVersion*: int16
    cPacketType*: byte
    iMessageType*: int32
    iRequestType*: int32
    sServantName*: string
    sFuncName*: string
    sBuffer*: seq[byte]
    iTimeout*: int32
    context*: TableRef[string, string]
    status*: TableRef[string, string]

  RequestDataVersion3* = object
    map*: TableRef[string, seq[byte]]

  RequestDataVersion2* = object
    map*: TableRef[string, seq[byte]]

  SvcReqRegister* = object
    uin*: int64
    bid*: int64
    connType*: byte
    other*: string
    status*: int32
    onlinePush*: byte
    isOnline*: byte
    isShowOnline*: byte
    kickPC*: byte
    kickWeak*: byte
    timestamp*: int64
    iOSVersion*: int64
    netType*: byte
    buildVer*: string
    regType*: byte
    devParam*: seq[byte]
    guid*: seq[byte]
    localeId*: int32
    silentPush*: byte
    devName*: string
    devType*: string
    oSVer*: string
    openPush*: byte
    largeSeq*: int64
    lastWatchStartTime*: int64
    oldSSOIp*: int64
    newSSOIp*: int64
    channelNo*: string
    cPID*: int64
    vendorName*: string
    vendorOSName*: string
    iOSIdfa*: string
    b769*: seq[byte]
    isSetStatus*: byte
    serverBuf*: seq[byte]
    setMute*: byte

  FriendInfo* = object
    friendUin*: int64
    groupId*: byte
    faceId*: int16
    remark*: string
    qQType*: byte
    status*: byte
    memberLevel*: byte
    isMqqOnLine*: byte
    qQOnlineState*: byte
    isIphoneOnline*: byte
    detailStatusFlag*: byte
    qQOnlineStateV2*: byte
    showName*: string
    isRemark*: byte
    nick*: string
    specialFlag*: byte
    iMGroupID*: seq[byte]
    mSFGroupID*: seq[byte]
    termType*: int32
    network*: byte
    ring*: seq[byte]
    abiFlag*: int64
    faceAddonId*: int64
    networkType*: int32
    vipFont*: int64
    iconType*: int32
    termDesc*: string
    colorRing*: int64
    apolloFlag*: byte
    apolloTimestamp*: int64
    sex*: byte
    founderFont*: int64
    eimId*: string
    eimMobile*: string
    olympicTorch*: byte
    apolloSignTime*: int64
    laviUin*: int64
    tagUpdateTime*: int64
    gameLastLoginTime*: int64
    gameAppId*: int64
    cardID*: seq[byte]
    bitSet*: int64
    kingOfGloryFlag*: byte
    kingOfGloryRank*: int64
    masterUin*: string
    lastMedalUpdateTime*: int64
    faceStoreId*: int64
    fontEffect*: int64
    dOVId*: string
    bothFlag*: int64
    centiShow3DFlag*: byte
    intimateInfo*: seq[byte]
    showNameplate*: byte
    newLoverDiamondFlag*: byte
    extSnsFrdData*: seq[byte]
    mutualMarkData*: seq[byte]

  TroopListRequest* = object
    uin*: int64
    getMSFMsgFlag*: byte
    cookies*: seq[byte]
    groupInfo*: seq[int64]
    groupFlagExt*: byte
    version*: int32
    companyId*: int64
    versionNum*: int64
    getLongGroupName*: byte

  TroopNumber* = object
    groupUin*: int64
    groupCode*: int64
    flag*: byte
    groupInfoSeq*: int64
    groupName*: string
    groupMemo*: string
    groupFlagExt*: int64
    groupRankSeq*: int64
    certificationType*: int64
    shutUpTimestamp*: int64
    myShutUpTimestamp*: int64
    cmdUinUinFlag*: int64
    additionalFlag*: int64
    groupTypeFlag*: int64
    groupSecType*: int64
    groupSecTypeInfo*: int64
    groupClassExt*: int64
    appPrivilegeFlag*: int64
    subscriptionUin*: int64
    memberNum*: int64
    memberNumSeq*: int64
    memberCardSeq*: int64
    groupFlagExt3*: int64
    groupOwnerUin*: int64
    isConfGroup*: byte
    isModifyConfGroupFace*: byte
    isModifyConfGroupName*: byte
    cmdUinJoinTime*: int64
    companyId*: int64
    maxGroupMemberNum*: int64
    cmdUinGroupMask*: int64
    guildAppId*: int64
    guildSubType*: int64
    cmdUinRingtoneID*: int64
    cmdUinFlagEx2*: int64

  TroopMemberListRequest* = object
    uin*: int64
    groupCode*: int64
    nextUin*: int64
    groupUin*: int64
    version*: int64
    reqType*: int64
    getListAppointTime*: int64
    richCardNameVer*: byte

  TroopMemberInfo* = object
    memberUin*: int64
    faceId*: int16
    age*: byte
    gender*: byte
    nick*: string
    status*: byte
    showName*: string
    name*: string
    memo*: string
    autoRemark*: string
    memberLevel*: int64
    joinTime*: int64
    lastSpeakTime*: int64
    creditLevel*: int64
    flag*: int64
    flagExt*: int64
    point*: int64
    concerned*: byte
    shielded*: byte
    specialTitle*: string
    specialTitleExpireTime*: int64
    job*: string
    apolloFlag*: byte
    apolloTimestamp*: int64
    globalGroupLevel*: int64
    titleId*: int64
    shutUpTimestap*: int64
    globalGroupPoint*: int64
    richCardNameVer*: byte
    vipType*: int64
    vipLevel*: int64
    bigClubLevel*: int64
    bigClubFlag*: int64
    nameplate*: int64
    groupHonor*: seq[byte]

type
  JecWriter* = ref object
    buf: seq[byte]

proc newJceWriter*(): JecWriter =
  new result
  result.buf = @[]

#TODO wirte jce
proc wirteHead*(w: JecWriter, t: byte, tag: int) =
  if tag < 15:
    w.buf.add(byte((tag shl 4).byte or t))
  elif tag < 256:
    w.buf.add(byte(0xf0 or t))
    w.buf.add(byte(tag))

# write a byte
proc write*(w: JecWriter, b: byte, tag: int) =
  if b == 0:
    w.wirteHead(12, tag)
  else:
    w.wirteHead(0, tag)
    w.buf.add(b)


type
  JecReader* = ref object
    buf*: seq[byte]
    data*: seq[byte]

  HeadData* = ref object
    typ*: byte
    tag*: int


proc newJceReader*(): JecReader =
  new result
  result.data = @[]

proc readHead*(r:JecReader): HeadData =
  new result
  
