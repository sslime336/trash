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

proc getModifiedChaptersNames*(): seq[string] =
  let prevChaptersStatus = chapterLockFile.readAll().split("\n")
  let curChaptersStatus = hashChapters().split("\n")
  for i in 0..<prevChaptersStatus.len:
    if prevChaptersStatus[i] == curChaptersStatus[i]:
      continue
    result.add(curChaptersStatus[i].split(":")[0])

proc getModifiedChaptersIndexes*(): cint {.cdecl, exportc, dynlib.} =
  let prevChaptersStatus = chapterLockFile.readAll().split("\n")
  let curChaptersStatus = hashChapters().split("\n")
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
    chapterLockFile.close()
    chapterLockFile = open("chapters.lock", fmWrite)
    chapterLockFile.write(curHashedChapters)
  else:
    echo "you haven't done anything!"
"""

when defined(bitpos):
  echo getModifiedChaptersIndexes()
else:
  for name in getModifiedChaptersNames():
    echo name
