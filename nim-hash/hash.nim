import util, os, strutils
import std/sha1

##[
  监控章节是否发生修改
]##

{.push used.}

var chapterLockFile =
  try:
    open("chapters.lock", fmReadWriteExisting)
  except IOError:
    echo "generate chapters.lock"
    open("chapters.lock", fmReadWrite)

proc hashDir(dir: string): string =
  for fileType, fileAbsPath in walkDir(dir):
    if fileType != pcFile: continue
    let hashcode = $secureHashFile(fileAbsPath)
    result.add(hashcode)

  result = $secureHash(result)

proc hashChapters(): string =
  let curDir = getCurrentDir()
  for (dirType, path) in walkDir(curDir):
    if dirType != pcDir: continue

    let dirName = path.split(r"\")[^1]
    if dirName in exceptDirs: continue

    let hashed = dirName & ": " & hashDir(path) & '\n'
    result.add(hashed)

proc overwriteLockFile(content: string) =
  open("chapters.lock", fmWrite).write(content)


proc getModifiedChaptersNames*(): seq[string] =
  let
    lockFileContent = chapterLockFile.readAll()
    curChapters = hashChapters()
    prevChaptersStatus = lockFileContent.split("\n")
    curChaptersStatus = curChapters.split("\n")

  defer: overwriteLockFile(curChapters)

  let
    prevChaptersStatusLen = prevChaptersStatus.len
    curChaptersStatusLen = curChaptersStatus.len
  if prevChaptersStatusLen != curChaptersStatusLen:
    return
  for i in 0..<prevChaptersStatus.len:
    if prevChaptersStatus[i] == curChaptersStatus[i]:
      continue
    result.add(curChaptersStatus[i].split(":")[0])


proc getModifiedChaptersIndexes*(): cint {.cdecl, exportc, dynlib.} =
  let
    lockFileContent = chapterLockFile.readAll()
    curChapters = hashChapters()
    prevChaptersStatus = lockFileContent.split("\n")
    curChaptersStatus = curChapters.split("\n")

  defer: overwriteLockFile(curChapters)

  let
    prevChaptersStatusLen = prevChaptersStatus.len
    curChaptersStatusLen = curChaptersStatus.len
  if prevChaptersStatusLen != curChaptersStatusLen:
    return
  for i in 0..<prevChaptersStatus.len:
    if prevChaptersStatus[i] == curChaptersStatus[i]:
      continue
    result = result or (1.cint shl i.cint)

{.pop.}

discard """
when isMainModule:
  let curHashedChapters = hashChapters()
  if curHashedChapters != chapterLockFile.readAll():
    echo "it has beed changed"
    open("chapters.lock", fmWrite).write(curHashedChapters)
  else:
    echo "nothing had been changed"
"""
if isMainModule:
  when defined(bitpos):
    echo getModifiedChaptersIndexes()
  else:
    for name in getModifiedChaptersNames():
      echo name
