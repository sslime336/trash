import os, strutils

proc getFileNameFromAbsPath*(dir: string): string =
  result = dir.split("\\")[^1]

{.push inline, used.}

proc getCurModuleContent(pkgName: string): string =
  result =
    "module " & pkgName & "\n\n" & "go 1.19\n"

proc getCurReadmeContent(dirName: string): string =
  result =
    "# " & dirName & "\n\n"

var exceptDirs* = @[".git", "misc", ".vscode"]

proc addExceptDir(dirName: string) {.used.} =
  exceptDirs.add(dirName)

proc genBatchGoModFile() =
  let curDir = getCurrentDir()
  for (dirType, path) in walkDir(curDir):
    if dirType != pcDir: continue

    let dirName = path.split(r"\")[^1]
    if dirName in exceptDirs: continue

    echo "write in " & dirName
    let gomod = open(dirName&"/go.mod", mode = fmWrite)
    gomod.write(getCurModuleContent(dirName))

proc genBatchReadmeFile() =
  let curDir = getCurrentDir()
  for (dirType, path) in walkDir(curDir):
    if dirType != pcDir: continue

    let dirName = path.split(r"\")[^1]
    if dirName in exceptDirs: continue

    echo "write in " & dirName
    let readme = open(dirName&"/README.md", mode = fmWrite)
    readme.write(getCurReadmeContent(dirName))

let chapters = [
  "authority", "common-params", "configuration", "custom-server",
  "database-sql", "dependency-inject", "middlewire", "project-layer",
  "template-mvc", "warming-up"
]

proc `+=`(s: var string, ss: string) =
  s = s & " " & ss & " "

proc flat(strs: openArray[string]): string =
  for r in strs:
    result += r

proc addBatchGoFile2Workspace() =
  discard os.execShellCmd("go work init")
  discard os.execShellCmd("go work use " & chapters.flat())

proc grading() =
  proc checkAuthority(): bool =
    discard

{.pop.}

when isMainModule:
  when defined(init):
    addBatchGoFile2Workspace()
    genBatchReadmeFile()
    genBatchGoModFile()
  when defined(grading):
    grading()
