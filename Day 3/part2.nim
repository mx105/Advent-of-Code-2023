import std/[sequtils, strformat, strutils, times, tables]

type Number = object
  value: int
  startCol, endCol, row: int

type Star = object
  row, col: int

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

iterator findStars(line: string, rowNum: int): Star =
  for colNum, c in line:
    if c == '*':
      yield Star(row: rowNum, col: colNum)

proc getAdjacentNumbers(lines: seq[string], star: Star, numbers: seq[Number]): seq[Number] =
  let
    rows = lines.len
    cols = if rows > 0: lines[0].len else: 0
    rowStart = max(0, star.row - 1)
    rowEnd = min(rows - 1, star.row + 1)
    colStart = max(0, star.col - 1)
    colEnd = min(cols - 1, star.col + 1)

  for num in numbers:
    # Check if number overlaps with star's adjacent area
    if num.row >= rowStart and num.row <= rowEnd:
      let numberStart = num.startCol
      let numberEnd = num.endCol
      if not (numberEnd < colStart or numberStart > colEnd):
        result.add(num)

when isMainModule:
  let startTime = cpuTime()
  const filePath = "input.txt"
  let lines = parseInput(filePath)

  var
    allNumbers: seq[Number]
    allStars: seq[Star]
    total = 0

  for rowNum, line in lines:
    for num in findNumbers(line, rowNum):
      allNumbers.add(num)
    for star in findStars(line, rowNum):
      allStars.add(star)

  for star in allStars:
    let adjNumbers = getAdjacentNumbers(lines, star, allNumbers)
    if adjNumbers.len == 2:
      total += adjNumbers[0].value * adjNumbers[1].value

  echo &"Sum of Gear Ratios: {total}"
  echo &"Time taken: {cpuTime() - startTime:.3f} seconds"
