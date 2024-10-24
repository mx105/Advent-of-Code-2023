import std/[sequtils, strformat, strutils, times]

type Number = object
  value: int
  startCol, endCol, row: int

proc parseInput(filePath: string): seq[string] =
  toSeq(lines(filePath))

iterator findNumbers(line: string, rowNum: int): Number =
  var
    curNum = ""
    startCol = -1

  template yieldNumber() =
    if curNum.len > 0:
      yield Number(
        value: parseInt(curNum),
        startCol: startCol,
        endCol: if startCol == -1: line.high else: i-1,
        row: rowNum
      )
      curNum.setLen(0)
      startCol = -1

  for i, c in line:
    if c.isDigit:
      if startCol == -1: startCol = i
      curNum.add(c)
    else:
      yieldNumber()

  # Handle number at end of line
  if startCol != -1:
    yield Number(
      value: parseInt(curNum),
      startCol: startCol,
      endCol: line.high,
      row: rowNum
    )

func isSpecial(c: char): bool =
  not c.isDigit and c != '.'

func hasAdjacentSymbol(lines: seq[string], num: Number): bool =
  let
    rows = lines.len
    cols = if rows > 0: lines[0].len else: 0
    rowStart = max(0, num.row - 1)
    rowEnd = min(rows - 1, num.row + 1)
    colStart = max(0, num.startCol - 1)
    colEnd = min(cols - 1, num.endCol + 1)

  for row in rowStart..rowEnd:
    for col in colStart..colEnd:
      if lines[row][col].isSpecial:
        return true
  false

when isMainModule:
  let startTime = cpuTime()
  const filePath = "input.txt"
  var total = 0
  let lines = parseInput(filePath)
  for rowNum, line in lines:
    for num in findNumbers(line, rowNum):
      if hasAdjacentSymbol(lines, num):
        total += num.value
  echo &"Sum of Part Numbers: {total}"
  echo &"Time taken: {cpuTime() - startTime:.3f} seconds"
